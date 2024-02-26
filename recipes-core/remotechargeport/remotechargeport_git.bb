SUMMARY = "EVerest modules for satellite charge ports"
HOMEPAGE = "https://github.com/mhei/remotechargeport"
LICENSE = "GPL-3.0-only"
LIC_FILES_CHKSUM = "file://LICENSE;md5=1ebbd3e34237af26da5dc08a4e440464"

SRC_URI = "git://github.com/mhei/remotechargeport.git;branch=main;protocol=https"

SRCREV = "${AUTOREV}"
PV = "2024.02.0+git${SRCPV}"

S = "${WORKDIR}/git"

inherit cmake

DEPENDS = " \
    everest-core \
    evcli-native \
    rpclib \
"

RDEPENDS:${PN} += "rpclib"

INSANE_SKIP:${PN} = "already-stripped useless-rpaths arch file-rdeps"

EXTRA_OECMAKE += "-DDISABLE_EDM=ON"

do_install:append() {
    # don't install example configuration
    rm -rf ${D}${sysconfdir}

    # this module has no data files
    rm -rf ${D}${datadir}
}
