LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "git://github.com/chargebyte/everest-chargebyte.git;branch=main;protocol=https"

SRCREV = "2f8e3fcff873e3fbe4fc437015d72c2b0fcfa590"
PV = "0.11.0+git${SRCPV}"

S = "${WORKDIR}/git"

inherit cmake pkgconfig

DEPENDS = " \
    everest-core \
    evcli-native \
    libgpiod \
"

INSANE_SKIP:${PN} = "already-stripped useless-rpaths arch file-rdeps"

FILES:${PN} += "${datadir}/everest/*"

EXTRA_OECMAKE += "-DDISABLE_EDM=ON"
