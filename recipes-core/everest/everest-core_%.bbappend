FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI = " \
    git://github.com/chargebyte/everest-core.git;branch=cb-tarragon-bsp;protocol=https \
    file://everest.service \
    file://default_logging.cfg \
"

SRCREV="810c767eaf006223025593838b36f5a8623387c2"

inherit systemd

FILES:${PN} += " \
    ${sysconfdir}/everest/* \
    ${systemd_system_unitdir}/everest.service \
"

SYSTEMD_AUTO_ENABLE:${PN} = "enable"
SYSTEMD_PACKAGES = "${PN}"

SYSTEMD_SERVICE:${PN} = "everest.service"

EXTRA_OECMAKE += "-DEVEREST_PROJECT_DIRS:STRING=${STAGING_DIR_TARGET}/usr/share/everest/"

do_install:append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/everest.service ${D}${systemd_system_unitdir}
    install -d ${D}${sysconfdir}/everest
    ln -s config-chargebyte-tarragon.yaml ${D}${sysconfdir}/everest/config.yaml
    install -m 0644 ${WORKDIR}/default_logging.cfg ${D}${sysconfdir}/everest
}
