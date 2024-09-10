LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "git://github.com/chargebyte/everest-chargebyte.git;branch=main;protocol=https"

SRCREV = "fafbdd15570c656d482bad7c38e71bd587525f8b"
PV = "0.16.0+git${SRCPV}"

S = "${WORKDIR}/git"

inherit cmake pkgconfig python3native

DEPENDS = " \
    everest-core \
    evcli-native \
    libgpiod \
    sigslot \
"

INSANE_SKIP:${PN} = "already-stripped useless-rpaths arch file-rdeps"

FILES:${PN} += "${datadir}/everest/*"

EXTRA_OECMAKE += " \
    -DDISABLE_EDM=ON \
    -Deverest-chargebyte_USE_PYTHON_VENV=OFF \
"

EVEREST_EXCLUDE_MODULES ??= ""

EVEREST_EXCLUDE_MODULES:chargesom ??= " \
    CbTarragonDIs \
    CbTarragonDriver \
    CbTarragonPlugLock \
"

EVEREST_EXCLUDE_MODULES:tarragon ??= " \
    CbChargeSOMDriver \
"

EXTRA_OECMAKE += "-DEVEREST_EXCLUDE_MODULES='${@";".join(d.getVar('EVEREST_EXCLUDE_MODULES', True).split())}'"

do_install:append() {
    # version_information.txt from multiple repositories are in conflict
    rm -f ${D}${datadir}/everest/version_information.txt
}
