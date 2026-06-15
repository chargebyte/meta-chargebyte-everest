FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# overwrite source until our PR is merged
SRC_URI = "git://github.com/chargebyte/linux_libnfc-nci.git;branch=feature/libgpiod;protocol=https"
SRCREV = "ce5f6b2733b89c040f4fa9065e4a1d7e36e0327e"

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
