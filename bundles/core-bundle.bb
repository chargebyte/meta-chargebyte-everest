# Recipe to create a firmware update bundle using rauc
#
# Note that you need to configure RAUC_KEY_FILE and RAUC_CERT_FILE to
# point to contain the full path to your key and cert.
# Depending on you requirements you can either set them via global
# configuration or from a bundle recipe bbappend.
#
# The configuration here adds some scripts which are executed after
# the bundle was installed on the target system. These scripts e.g.
# copy over existing configurations files etc.
#

inherit bundle

LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI += " \
    file://hooks.sh \
    file://post-install.d \
"

DEPENDS += "e2fsprogs-native"

RAUC_BUNDLE_EXTRA_FILES += "post-install.d"

RAUC_BUNDLE_COMPATIBLE:chargesom ?= "chargebyte Charge SOM"
RAUC_BUNDLE_COMPATIBLE:evachargese ?= "I2SE EVAcharge SE"
RAUC_BUNDLE_COMPATIBLE:tarragon ?= "I2SE Tarragon"
RAUC_BUNDLE_COMPATIBLE:parsley ?= "chargebyte Charge Control Y"

RAUC_BUNDLE_HOOKS[file] = "hooks.sh"

RAUC_BUNDLE_SLOTS = "rootfs customerfs"

RAUC_IMAGE_FSTYPE = "ext4"

RAUC_SLOT_rootfs = "core-image-minimal"
RAUC_SLOT_rootfs[hooks] = "post-install"

RAUC_SLOT_customerfs = "customerfs"
RAUC_SLOT_customerfs[type] = "file"
RAUC_SLOT_customerfs[file] = "customerfs.tar.gz"
RAUC_SLOT_customerfs[rename] = "customerfs.tar.gz"
RAUC_SLOT_customerfs[hooks] = "post-install"

BUNDLE_EXTENSION ?= ".image"

# Important: Using the verity bundle format requires the dm-verity features being enabled in
# the running system kernel. If they are not supported yet, update the system using a plain
# bundle with the kernel features enabled, followed by an update using the new verity format.
# https://rauc.readthedocs.io/en/latest/integration.html#bundle-format-migration
RAUC_BUNDLE_FORMAT = "verity"


# Helper function for reading the system version from the rootfs
# file /usr/share/secc/VERSION.
def _read_version_from_rootfs(d):
    import glob
    import os
    import subprocess

    deploy_dir = d.getVar("DEPLOY_DIR_IMAGE")
    machine = d.getVar("MACHINE")
    image_name = d.getVar("RAUC_SLOT_rootfs")
    fstype = d.getVar("RAUC_IMAGE_FSTYPE")

    candidates = [
        f"{deploy_dir}/{image_name}-{machine}.{fstype}",
        f"{deploy_dir}/{image_name}-{machine}.rootfs.{fstype}",
        f"{deploy_dir}/{image_name}.{fstype}",
    ] + glob.glob(f"{deploy_dir}/{image_name}-*.{fstype}")

    image_path = next((p for p in candidates if os.path.exists(p)), None)
    if not image_path:
        bb.warn("RAUC: could not locate rootfs image to read /usr/share/secc/VERSION")
        return None

    try:
        return subprocess.check_output(
            ["debugfs", "-R", "cat /usr/share/secc/VERSION", image_path],
            text=True,
        ).strip() or None
    except Exception as exc:
        bb.warn(f"RAUC: failed to read VERSION from {image_path}: {exc}")
        return None


# Helper function for exporting the RAUC_BUNDLE_VERSION and BUNDLE_NAME to the
# environment before a bitbake build step.
def _update_bundle_metadata(d):
    version = _read_version_from_rootfs(d)
    if version:
        d.setVar("RAUC_BUNDLE_VERSION", version)
        bb.note(f"RAUC: set RAUC_BUNDLE_VERSION to '{version}' from rootfs")
    else:
        bb.warn("RAUC: /usr/share/secc/VERSION is empty; leaving RAUC_BUNDLE_VERSION unchanged")

    bundle_name = _get_bundlename(d)
    d.setVar("BUNDLE_NAME", bundle_name)
    bb.note(f"RAUC: using bundle name '{bundle_name}'")


# Helper function in order to get the bundle name depending on MACHINE,
# SUBMACHINE and CUSTOMER definition of this image. The system version
# will be added into the final image name too.
def _get_bundlename(d):
    from datetime import datetime
    ts = datetime.now().strftime("%Y-%m-%d-%H%M")
    version = d.getVar('RAUC_BUNDLE_VERSION') or d.getVar('PV') or "unknown"

    if d.getVar('MACHINE', True) == "evachargese":
        machine = "EVAchargeSE"
    elif d.getVar('MACHINE', True) == "tarragon":
        machine = "Tarragon"
    elif d.getVar('MACHINE', True) == "chargesom":
        if d.getVar('SUBMACHINE', True) == "dc-evb":
            machine = "Charge-SOM-Single-Channel-DC-Carrier-Board"
        else:
            machine = "Charge-SOM-unspecified"
    elif d.getVar('MACHINE', True) == "parsley":
        machine = "Parsley"
    else:
        machine = "Unknown"

    if d.getVar('CUSTOMER', True) != "" and d.getVar('CUSTOMER', True) is not None:
        customer = "_" + d.getVar('CUSTOMER', True)
    else:
        customer = ""

    return "EVerest-Firmware_%s%s_%s_%s" % (machine, customer, version, ts)


# Bitbake pre function
python rauc_update_bundle_metadata() {
    _update_bundle_metadata(d)
}

# The environment will not be kept from one build step to an other.
# We need to export the BUNDLE_NAME and RAUC_BUNDLE_VERSION before
# each step where they are required.

do_configure[prefuncs] += "rauc_update_bundle_metadata "
do_deploy[prefuncs] += "rauc_update_bundle_metadata "

BUNDLE_NAME ?= "${@_get_bundlename(d)}"
