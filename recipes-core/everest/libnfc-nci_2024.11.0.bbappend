FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

# overwrite source until our PR is merged
SRC_URI = "git://github.com/chargebyte/linux_libnfc-nci.git;branch=feature/libgpiod;protocol=https"
SRCREV = "7524e3dd25220e31a828718aeb3f7e6981659000"

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
