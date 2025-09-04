# TODO: Temporary override to use custom branch/commit.
#       Remove these lines once the upstream for the json-rpc-api pull request
#       (https://github.com/EVerest/everest-core/pull/1324) has been merged.
SRC_URI = "git://github.com/chargebyte/everest-core.git;protocol=https;branch=feature/json-rpc-api-2025.8.0 \
           file://everest.service \
           "
SRCREV = "be8125e647b27ccb9e08923210f872be608102af"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://02-led-boot-notification.conf \
    file://0001-Drop-timestamp-from-logging.patch \
    file://journalctl-alias.sh \
"

# we don't require nodejs-native when we disable javascript modules
DEPENDS:remove = "nodejs-native"

# add RpcApi dependency
DEPENDS += "json-rpc-cxx"

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
    EvAPI \
    EvManager \
    Evse15118D20 \
    EvseManager \
    EvseSecurity \
    EvseSlac \
    EvseV2G \
    EvSlac \
    GenericPowermeter \
    IMDSimulator \
    IsabellenhuetteIemDcr \
    IsoMux \
    LemDCBM400600 \
    OCPP \
    OCPP201 \
    OVMSimulator \
    PacketSniffer \
    PersistentStore \
    PN532TokenProvider \
    PN7160TokenProvider \
    RpcApi \
    SerialCommHub \
    Setup \
    StaticISO15118VASProvider \
    Store \
    System \
    YetiSimulator \
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
