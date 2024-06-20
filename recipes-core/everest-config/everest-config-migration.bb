DESCRIPTION = "Run the EVerest configuration migration before starting EVerest."
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

RDEPENDS:${PN} += "everest-core"

SRC_URI = " \
    file://01-migrate-configuration.conf \
    file://migrate-config.sh \
    file://migration-functions.sh \
"

inherit allarch

S = "${WORKDIR}"

FILES:${PN} += " \
    ${systemd_system_unitdir}/everest.service.d/* \
    ${libexecdir}/everest/migration/migrate-config.sh \
    ${libexecdir}/everest/migration/migration-functions.sh \
"

do_install() {
    # Systemd configuration for everest.service
    install -d ${D}${systemd_system_unitdir}/everest.service.d/
    install -m 0644 ${WORKDIR}/*.conf ${D}${systemd_system_unitdir}/everest.service.d/

    # Migration tool
    install -d ${D}${libexecdir}/everest/migration
    install -m 0755 ${WORKDIR}/migrate-config.sh ${D}${libexecdir}/everest/migration
    install -m 0755 ${WORKDIR}/migration-functions.sh ${D}${libexecdir}/everest/migration
}
