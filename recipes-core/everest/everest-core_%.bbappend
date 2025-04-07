FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://02-led-boot-notification.conf \
    file://0001-Drop-timestamp-from-logging.patch \
    file://journalctl-alias.sh \
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
    DummyBankSessionTokenProvider \
    DummyTokenProvider \
    DummyTokenProviderManual \
    DummyTokenValidator \
    DummyV2G \
    EnergyManager \
    EnergyNode \
    ErrorHistory \
    Evse15118D20 \
    EvseManager \
    EvseSecurity \
    EvseSlac \
    EvseV2G \
    EvSlac \
    GenericPowermeter \
    IMDSimulator \
    IsoMux \
    LemDCBM400600 \
    OCPP \
    OCPP201 \
    PacketSniffer \
    PersistentStore \
    PN532TokenProvider \
    PN7160TokenProvider \
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

    # install alias for journalctl convenience
    install -d ${D}${sysconfdir}/profile.d/
    install -m 0644 ${WORKDIR}/journalctl-alias.sh ${D}${sysconfdir}/profile.d/

    # additional systemd configuration for everest.service
    install -d ${D}${systemd_system_unitdir}/everest.service.d/
    install -m 0644 ${WORKDIR}/02-led-boot-notification.conf ${D}${systemd_system_unitdir}/everest.service.d/
}

FILES:${PN} += " \
    ${systemd_system_unitdir}/everest.service.d/* \
"
