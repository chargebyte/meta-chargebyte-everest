SUMMARY = "Set of packages used in EVerest based distributions"
LICENSE = "Apache-2.0"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = " \
    packagegroup-bsp \
    boost \
    boost-program-options \
    everest-core \
    everest-framework \
    remotechargeport \
    mosquitto \
    openssl-bin \
    rauc \
    tzdata tzdata-europe \
    mosquitto-clients \
    tcpdump \
"
