LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = "git://github.com/chargebyte/everest-chargebyte.git;branch=feature/adapt-cbsystem-to-2409;protocol=https \
           file://0001-CMake-drop-everest-system-package-dependency.patch \
"

SRCREV = "485c124c38738164711a49c454cae44fad1c0f08"
PV = "0.32.0.1+git${SRCPV}"

S = "${WORKDIR}/git"

inherit cmake pkgconfig python3native

DEPENDS = " \
    everest-core \
    evcli-native \
    libgpiod \
    ${@bb.utils.contains_any("MACHINE", "chargesom lime parsley", "ra-utils", "", d)} \
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
    CbParsleyDriver \
    CbTarragonDIs \
    CbTarragonDriver \
    CbTarragonPlugLock \
"

EVEREST_EXCLUDE_MODULES:evachargese ??= " \
    CbChargeSOMDriver \
    CbParsleyDriver \
    CbTarragonDIs \
    CbTarragonDriver \
    CbTarragonPlugLock \
"

EVEREST_EXCLUDE_MODULES:lime ??= " \
    CbTarragonDIs \
    CbTarragonDriver \
    CbParsleyDriver \
"

EVEREST_EXCLUDE_MODULES:tarragon ??= " \
    CbChargeSOMDriver \
    CbParsleyDriver \
"

EVEREST_EXCLUDE_MODULES:parsley ??= " \
    CbChargeSOMDriver \
    CbGPIOEnergyLimits \
    CbGPIOSMITH \
    CbTarragonDIs \
    CbTarragonDriver \
    CbTarragonPlugLock \
"

EXTRA_OECMAKE += "-DEVEREST_EXCLUDE_MODULES='${@";".join(d.getVar('EVEREST_EXCLUDE_MODULES', True).split())}'"

do_install:append() {
    # version_information.txt from multiple repositories are in conflict
    rm -f ${D}${datadir}/everest/version_information.txt
}
