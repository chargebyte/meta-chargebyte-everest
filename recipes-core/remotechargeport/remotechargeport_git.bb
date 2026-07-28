SUMMARY = "EVerest modules for satellite charge ports"
HOMEPAGE = "https://github.com/mhei/remotechargeport"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1ebbd3e34237af26da5dc08a4e440464"

SRC_URI = " \
    git://github.com/mhei/remotechargeport.git;branch=main;protocol=https \
    file://systemaggregatorftpd \
    file://systemaggregatorftpd.socket \
    file://systemaggregatorftpd@.service \
"

SRCREV = "e9a6651d683e372eb6765500c2c74df401ab6af6"
PV = "2026.02.0+git${SRCPV}"


inherit cmake systemd python3native

DEPENDS = " \
    everest-core \
    evcli-native \
    rpclib \
"

RDEPENDS:${PN} += "rpclib"

INSANE_SKIP:${PN} = "already-stripped useless-rpaths arch file-rdeps"

EXTRA_OECMAKE += " \
    -DDISABLE_EDM=ON \
    -Dremotechargeport_USE_PYTHON_VENV=OFF \
"

SYSTEMD_SERVICE:${PN} = "systemaggregatorftpd.socket systemaggregatorftpd@.service"

FILES:${PN} += " ${datadir}/everest"

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

    # version_information.txt from multiple repositories are in conflict
    rm -f ${D}${datadir}/everest/version_information.txt
}
