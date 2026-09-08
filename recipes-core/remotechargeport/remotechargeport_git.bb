SUMMARY = "EVerest modules for satellite charge ports"
HOMEPAGE = "https://github.com/mhei/remotechargeport"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1ebbd3e34237af26da5dc08a4e440464"

SRC_URI = " \
    git://github.com/mhei/remotechargeport.git;branch=main;protocol=https \
    file://systemaggregatorftpd \
    file://systemaggregatorftpd-generator \
    file://systemaggregatorftpd.socket \
    file://systemaggregatorftpd@.service \
    file://factory-reset \
"

SRCREV = "527a8948ab5108a464890777862831c0eb44ba19"
PV = "2026.10.0-pre1+git${SRCPV}"

S = "${WORKDIR}/git"

inherit cmake pkgconfig systemd python3native

DEPENDS = " \
    everest-core \
    evcli-native \
    libbaptismdata \
    rpclib \
"

RDEPENDS:${PN} += "rpclib"

INSANE_SKIP:${PN} = "already-stripped useless-rpaths arch file-rdeps"

EXTRA_OECMAKE += " \
    -DDISABLE_EDM=ON \
    -Dremotechargeport_USE_PYTHON_VENV=OFF \
"

SYSTEMD_SERVICE:${PN} = ""
SYSTEMD_AUTO_ENABLE = "disable"

FILES:${PN} += " \
    ${datadir}/everest \
    ${systemd_unitdir} \
"

do_install:append() {
    # install environment configuration for helper ftpd
    install -m 0755 -d ${D}${sysconfdir}/default
    install -m 0644 ${WORKDIR}/systemaggregatorftpd ${D}${sysconfdir}/default/systemaggregatorftpd

    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${WORKDIR}/systemaggregatorftpd@.service ${D}${systemd_system_unitdir}/
        install -m 0644 ${WORKDIR}/systemaggregatorftpd.socket ${D}${systemd_system_unitdir}/
        install -d ${D}${systemd_unitdir}/system-generators
        install -m 0755 ${WORKDIR}/systemaggregatorftpd-generator ${D}${systemd_unitdir}/system-generators/
    fi

    # don't install example configuration
    rm -rf ${D}${sysconfdir}/everest

    # version_information.txt from multiple repositories are in conflict
    rm -f ${D}${datadir}/everest/version_information.txt

    install -d ${D}${libexecdir}/factory-reset.d
    install -m 0755 ${WORKDIR}/factory-reset ${D}${libexecdir}/factory-reset.d/50_remotechargeport
}
