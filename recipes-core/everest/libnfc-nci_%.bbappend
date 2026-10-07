FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRCREV = "c76c54428de1064c35b9de6b221adad5e6f6a9a1"
PV = "2026.10.0"

# TEMPORARY: demoapp/main.c calls PrintNDEFContent() above its definition
# without a forward declaration, which is a hard error since GCC 14.
# Drop once fixed in EVerest/linux_libnfc-nci.
SRC_URI += "file://0001-demoapp-forward-declare-PrintNDEFContent-before-fir.patch"

# drop this section when it goes upstream into meta-everest's recipe
inherit pkgconfig
PACKAGECONFIG ??= ""
PACKAGECONFIG[libgpiod] = "-DLIBNFCNCI_LIBGPIOD=ON,-DLIBNFCNCI_LIBGPIOD=OFF,libgpiod"

# explicitly require libgpiod for chargebyte's kernels
PACKAGECONFIG += "libgpiod"

EXTRA_OECMAKE += " \
    -DLIBNFCNCI_BUILD_EXAMPLES=ON \
"

# split examples into dedicated package
PACKAGE_BEFORE_PN += "${PN}-bin"
FILES:${PN}-bin = "${bindir}/*"

do_install:append() {
    # Both files have a machine/module specific version elsewhere
    # (everest-core's PN7160TokenProvider ships its own libnfc-nci.conf,
    # everest-basefiles a chargesom specific libnfc-nxp.conf). Drop the
    # generic upstream defaults to avoid dpkg file conflicts.
    rm -f ${D}${sysconfdir}/everest/libnfc_config/libnfc-nci.conf
    rm -f ${D}${sysconfdir}/everest/libnfc_config/libnfc-nxp.conf
}
