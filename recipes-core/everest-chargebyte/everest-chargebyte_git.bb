LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "git://github.com/chargebyte/everest-chargebyte.git;branch=main;protocol=https"

SRCREV = "0f26aa9d21b9e819dbdf02090c2533f6f4e36c88"
PV = "0.12.0+git${SRCPV}"

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
