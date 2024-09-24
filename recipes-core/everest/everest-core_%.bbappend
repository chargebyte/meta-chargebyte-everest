FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://0001-Drop-timestamp-from-logging.patch \
    file://journalctl-alias.sh \
    file://0001-Registered-time_sync_callback-in-OCPP201-module.patch \
    file://0001-API-make-error-history-requirement-optional.patch \
    file://0001-Make-correct-phase-count-available-in-API.patch \
"

# we don't require nodejs-native when we disable javascript modules
DEPENDS:remove = "nodejs-native"

# globally disable javascript modules for our embedded platforms
EXTRA_OECMAKE += " \
    -DEVEREST_ENABLE_JS_SUPPORT=OFF \
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
    ErrorHistory \
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
# force use of mbedtls (for EvseV2G)
EXTRA_OECMAKE += "-DUSING_MBED_TLS=ON"
DEPENDS += "mbedtls"

do_install:append() {
    # cleanup installed config files
    rm -rf ${D}${sysconfdir}/everest/config*.yaml

    # create persistent state directory
    install -d -m 0755 ${D}${localstatedir}/lib/everest

    # remove unneeded files from image
    rm -rf ${D}${datadir}/everest/docker

    # install alias for journalctl convenience
    install -d ${D}${sysconfdir}/profile.d/
    install -m 0644 ${WORKDIR}/journalctl-alias.sh ${D}${sysconfdir}/profile.d/
}
