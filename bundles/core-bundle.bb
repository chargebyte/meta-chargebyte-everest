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

RAUC_BUNDLE_EXTRA_FILES += "post-install.d"

RAUC_BUNDLE_COMPATIBLE ?= "I2SE Tarragon"

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

def get_bundlename(d):
    from datetime import datetime
    ts = datetime.now().strftime("%Y-%m-%d-%H%M")

    if d.getVar('MACHINE', True) == "evachargese":
        machine = "EVAchargeSE"
    elif d.getVar('MACHINE', True) == "tarragon":
        machine = "Tarragon"
    else:
        machine = "Unknown"

    if d.getVar('CUSTOMER', True) != "" and d.getVar('CUSTOMER', True) is not None:
        customer = "_" + d.getVar('CUSTOMER', True)
    else:
        customer = ""

    return "EVerest-Firmware_%s%s_%s" % (machine, customer, ts)

BUNDLE_NAME ?= "${@get_bundlename(d)}"
