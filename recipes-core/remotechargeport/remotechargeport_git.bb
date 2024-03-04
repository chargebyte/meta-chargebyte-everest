SUMMARY = "EVerest modules for satellite charge ports"
HOMEPAGE = "https://github.com/mhei/remotechargeport"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1ebbd3e34237af26da5dc08a4e440464"

SRC_URI = " \
    git://github.com/mhei/remotechargeport.git;branch=improve-get-diagnostics;protocol=https \
    file://systemaggregatorftpd \
    file://systemaggregatorftpd.socket \
    file://systemaggregatorftpd@.service \
"

SRCREV = "${AUTOREV}"
PV = "2024.02.0+git${SRCPV}"

S = "${WORKDIR}/git"

inherit cmake systemd

DEPENDS = " \
    everest-core \
    evcli-native \
    rpclib \
"

RDEPENDS:${PN} += "rpclib"

INSANE_SKIP:${PN} = "already-stripped useless-rpaths arch file-rdeps"

EXTRA_OECMAKE += "-DDISABLE_EDM=ON"

SYSTEMD_SERVICE:${PN} = "systemaggregatorftpd.socket systemaggregatorftpd@.service"

do_install:append() {
    # install environment configuration for helper ftpd
    install -m 0755 -d ${D}${sysconfdir}/default
    install -m 0644 ${WORKDIR}/systemaggregatorftpd ${D}${sysconfdir}/default/systemaggregatorftpd

    if ${@bb.utils.contains('DISTRO_FEATURES', 'systemd', 'true', 'false', d)}; then
        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${WORKDIR}/systemaggregatorftpd@.service ${D}${systemd_system_unitdir}/
        install -m 0644 ${WORKDIR}/systemaggregatorftpd.socket ${D}${systemd_system_unitdir}/
    fi

    # don't install example configuration
    rm -rf ${D}${sysconfdir}/everest

    # this module has no data files
    rm -rf ${D}${datadir}
}
