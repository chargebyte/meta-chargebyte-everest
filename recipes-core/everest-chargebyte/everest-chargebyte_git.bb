LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

SRC_URI = "git://github.com/chargebyte/everest-chargebyte.git;branch=main;protocol=https"

SRCREV = "76c037e7c7fed109847cb244df97bf3de7b50da8"
PV = "0.21.0+git${SRCPV}"

S = "${WORKDIR}/git"

inherit cmake pkgconfig python3native

DEPENDS = " \
    everest-core \
    evcli-native \
    libgpiod \
    sigslot \
    systemd \
    libsocketcan \
"

INSANE_SKIP:${PN} = "already-stripped useless-rpaths arch file-rdeps"
INSANE_SKIP:${PN}-dev = "already-stripped useless-rpaths arch file-rdeps"

FILES:${PN} += "${datadir}/everest/*"
FILES:${PN}-dev += "${bindir}/dump_infypower_canid"

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
