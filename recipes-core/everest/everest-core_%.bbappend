# When switching to a specific branch/remote of everest core, do that by
# choosing the meta-everest layer from that branch.
SRC_URI += "file://everest.service \
"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://02-led-boot-notification.conf \
    file://0001-Drop-timestamp-from-logging.patch \
    file://0001-lib-everest-log-pretty-print-none-info-messages.patch \
    file://0001-PN7160TokenProvider-rework-linking-to-libnfs-nci.patch \
    file://0001-lib-everest-ocpp-export-everest-util-dependency.patch \
    file://journalctl-alias.sh \
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
    CarloGavazzi_EM580 \
    ChargerInfo \
    DCSupplySimulator \
    DPM1000 \
    DZG_GSH01 \
    DoldRN5893 \
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
    Huawei_V100R023C10 \
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
    rm -rf ${D}${sysconfdir}/everest/run_tmux_helper.sh

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
