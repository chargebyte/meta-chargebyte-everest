SUMMARY = "mhei's EVerest modules"
HOMEPAGE = "https://github.com/mhei/everest-mhei"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1ebbd3e34237af26da5dc08a4e440464"

SRC_URI = "git://github.com/mhei/everest-mhei.git;branch=main;protocol=https"

SRCREV = "1b29f76e20c99b6e714378534ad9bbccabddba4e"
PV = "2026.02.0+git${SRCPV}"

S = "${WORKDIR}/git"

inherit cmake pkgconfig python3native

# gensio and sigslot are also required by the unconditionally built utils library.
# The EVDev modules are excluded on parsley, so libevdev is not needed there.
DEPENDS = " \
    everest-core \
    evcli-native \
    gensio \
    libbaptismdata \
    ${@bb.utils.contains_any("MACHINE", "parsley", "", "libevdev", d)} \
    libgpiod \
    sigslot \
"

INSANE_SKIP:${PN} = "already-stripped useless-rpaths arch file-rdeps"

EXTRA_OECMAKE += " \
    -DDISABLE_EDM=ON \
    -Deverest-mhei_USE_PYTHON_VENV=OFF \
"

EVEREST_EXCLUDE_MODULES ??= ""

EVEREST_EXCLUDE_MODULES:chargesom ??= " \
    DummyEvSlac \
    MCSTesterEV \
    EVAchargeSEEV \
    EVAchargeSEEVSE \
"

EVEREST_EXCLUDE_MODULES:evachargese ??= " \
    DummyEvSlac \
    MCSTesterEV \
"

EVEREST_EXCLUDE_MODULES:lime ??= " \
    DummyEvSlac \
    MCSTesterEV \
    EVAchargeSEEV \
    EVAchargeSEEVSE \
"

EVEREST_EXCLUDE_MODULES:tarragon ??= " \
    DummyEvSlac \
    MCSTesterEV \
    EVAchargeSEEV \
    EVAchargeSEEVSE \
"

EVEREST_EXCLUDE_MODULES:parsley ??= " \
    DummyEvSlac \
    MCSTesterEV \
    EVAchargeSEEV \
    EVAchargeSEEVSE \
    GenericEVDevTokenProvider \
    SimpleEVDevTxStopBtn \
    StronglinkSL032TokenProvider \
"

EXTRA_OECMAKE += "-DEVEREST_EXCLUDE_MODULES='${@";".join(d.getVar('EVEREST_EXCLUDE_MODULES', True).split())}'"

do_install:append() {
    # don't install example configuration
    rm -rf ${D}${sysconfdir}/everest

    # version_information.txt from multiple repositories are in conflict
    rm -f ${D}${datadir}/everest/version_information.txt

    # drop the whole directory - not needed at the moment
    rm -rf ${D}${datadir}
}
