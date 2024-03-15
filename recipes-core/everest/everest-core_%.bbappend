FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://0001-Implement-system-interface.patch \
    file://0001-System-delayed-reset-execution.patch \
"

# don't build/include undesired modules: some of the everest-core modules do not make sense
# on our chargebyte embedded platforms, e.g. BSPs for other boards, javascript simulations
# or similar; so the following list defines which modules we want to have in our standard image
EVEREST_INCLUDE_MODULES = " \
    API \
    Auth \
    DCSupplySimulator \
    DPM1000 \
    DummyTokenProvider \
    DummyTokenProviderManual \
    DummyTokenValidator \
    DummyV2G \
    EnergyManager \
    EnergyNode \
    EvseManager \
    EvseSecurity \
    EvseSlac \
    EvseV2G \
    EvSlac \
    GenericPowermeter \
    IMDSimulator \
    LemDCBM400600 \
    OCPP \
    OCPP201 \
    PacketSniffer \
    PersistentStore \
    PN532TokenProvider \
    PowermeterBSM \
    SerialCommHub \
    Setup \
    Store \
    System \
"

EXTRA_OECMAKE += "-DEVEREST_INCLUDE_MODULES='${@";".join(d.getVar('EVEREST_INCLUDE_MODULES', True).split())}'"

do_install:append() {
    # cleanup installed config files
    rm -rf ${D}${sysconfdir}/everest/config*.yaml

    # create persistent state directory
    install -d -m 0755 ${D}${localstatedir}/lib/everest

    # remove unneeded files from image
    rm -rf ${D}${datadir}/everest/docker
}
