LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "git://github.com/chargebyte/everest-chargebyte.git;branch=main;protocol=https"

SRCREV = "9709c13993eca6716c9664b05d4de3033a13771f"
PV = "0.14.0+git${SRCPV}"

S = "${WORKDIR}/git"

inherit cmake pkgconfig python3native

DEPENDS = " \
    everest-core \
    evcli-native \
    libgpiod \
"

INSANE_SKIP:${PN} = "already-stripped useless-rpaths arch file-rdeps"

FILES:${PN} += "${datadir}/everest/*"

EXTRA_OECMAKE += " \
    -DDISABLE_EDM=ON \
    -Deverest-chargebyte_USE_PYTHON_VENV=OFF \
"

do_install:append() {
    # version_information.txt from multiple repositories are in conflict
    rm -f ${D}${datadir}/everest/version_information.txt
}
