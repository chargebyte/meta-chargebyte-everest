FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# overwrite source until our PR is merged
SRC_URI = "git://github.com/chargebyte/linux_libnfc-nci.git;branch=feature/libgpiod;protocol=https"
SRCREV = "7524e3dd25220e31a828718aeb3f7e6981659000"

# TEMPORARY: demoapp/main.c calls PrintNDEFContent() above its definition
# with no forward declaration. GCC 14+ treats that as a hard error (was
# just a warning before), which breaks the build on wrynose's GCC 15.3.0
# toolchain. Send upstream to chargebyte/linux_libnfc-nci (feature/libgpiod
# branch) -- drop this patch (and this comment) once it lands there.
SRC_URI += "file://0001-demoapp-forward-declare-PrintNDEFContent-before-fir.patch"

inherit pkgconfig

DEPENDS += "\
    libgpiod \
"

EXTRA_OECMAKE += " \
    -DLIBNFCNCI_LIBGPIOD=ON \
    -DLIBNFCNCI_BUILD_EXAMPLES=ON \
"

# split examples into dedicated package
PACKAGE_BEFORE_PN += "${PN}-bin"
FILES:${PN}-bin = "${bindir}/*"

do_install:append() {
    # Both files below have a machine/module-specific override elsewhere
    # (everest-core's PN7160TokenProvider ships its own libnfc-nci.conf;
    # everest-basefiles ships a chargesom-specific libnfc-nxp.conf via the
    # private everest-configuration repo). Drop the generic upstream
    # defaults so dpkg doesn't hit a "trying to overwrite" file conflict.
    rm -f ${D}${sysconfdir}/everest/libnfc_config/libnfc-nci.conf
    rm -f ${D}${sysconfdir}/everest/libnfc_config/libnfc-nxp.conf
}
