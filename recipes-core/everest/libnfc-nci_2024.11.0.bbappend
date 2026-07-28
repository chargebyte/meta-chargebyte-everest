FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# overwrite source until our PR is merged
SRC_URI = "git://github.com/chargebyte/linux_libnfc-nci.git;branch=feature/libgpiod;protocol=https"
SRCREV = "ce5f6b2733b89c040f4fa9065e4a1d7e36e0327e"

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
