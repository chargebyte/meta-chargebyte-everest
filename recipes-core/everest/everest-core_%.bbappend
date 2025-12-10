# TODO: Temporary override to use custom branch/commit.
#       Remove these lines once the upstream for the json-rpc-api pull request
#       (https://github.com/EVerest/everest-core/pull/1324) has been merged.
SRC_URI = "git://github.com/chargebyte/everest-core.git;protocol=https;branch=feature/json-rpc-api-2025.8.0 \
           file://everest.service \
"

SRCREV = "14709eefd97811b86882413abf4760b229097066"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://02-led-boot-notification.conf \
    file://0001-Drop-timestamp-from-logging.patch \
    file://0001-EvseV2G-restore-ISO-15118-2-supportedAppProtocolRes-.patch \
    file://journalctl-alias.sh \
"
SRC_URI:append:parsley = "file://0001-Adding-MCS-feature.patch \
    file://0001-Add-EVTerminationCode.patch \
    file://0002-Add-response_code.patch \
    file://0001-Fix-Authentication-after-plugin.patch \
"


# we don't require nodejs-native when we disable javascript modules
DEPENDS:remove = "nodejs-native"

# add RpcApi dependency
DEPENDS += "json-rpc-cxx"

# globally disable javascript modules for our embedded platforms
EXTRA_OECMAKE += " \
    -DEVEREST_ENABLE_JS_SUPPORT=OFF \
"

# we don't build bring up modules
DEPENDS:remove = "ftxui"
EXTRA_OECMAKE += " \
    -DEVEREST_EXCLUDE_DEPENDENCIES='ftxui' \
"

# don't build/include undesired modules: some of the everest-core modules do not make sense
# on our chargebyte embedded platforms, e.g. BSPs for other boards, javascript simulations
# or similar; so the following list defines which modules we want to have in our standard image
EVEREST_INCLUDE_MODULES = " \
    API \
    AST_DC650 \
    Acrel_DJSF1352_RN \
    Auth \
    Bender_isoCHA425HV \
    ChargerInfo \
    DCSupplySimulator \
    DPM1000 \
    DZG_GSH01 \
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
    EvSlac \
    Evse15118D20 \
    EvseManager \
    EvseSecurity \
    EvseSlac \
    EvseV2G \
    GenericPowermeter \
    Huawei_R100040Gx \
    IMDSimulator \
    InfyPower \
    InfyPower_BEG1K075G \
    IsabellenhuetteIemDcr \
    IsoMux \
    LemDCBM400600 \
    Linux_Systemd_Rauc \
    LocalAllowlistTokenValidator \
    NxpNfcFrontendTokenProvider \
    OCPP \
    OCPP201 \
    OVMSimulator \
    PN532TokenProvider \
    PN7160TokenProvider \
    PacketSniffer \
    PersistentStore \
    RpcApi \
    SerialCommHub \
    Setup \
    StaticISO15118VASProvider \
    Store \
    System \
    UUGreenPower_UR1000X0 \
    Winline \
    YamlStore \
"

EXTRA_OECMAKE += "-DEVEREST_INCLUDE_MODULES='${@";".join(d.getVar('EVEREST_INCLUDE_MODULES', True).split())}'"

do_install:append() {
    # cleanup installed config files
    rm -rf ${D}${sysconfdir}/everest/config*.yaml

    # remove bring-up stuff
    rm -rf ${D}${sysconfdir}/everest/bringup

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
