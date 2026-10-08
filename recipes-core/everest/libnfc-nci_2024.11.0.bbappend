SRCREV = "c76c54428de1064c35b9de6b221adad5e6f6a9a1"
PV = "2026.10.0"

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
