# explicitly require libgpiod for chargebyte's kernels
PACKAGECONFIG += "libgpiod"

EXTRA_OECMAKE += " \
    -DLIBNFCNCI_BUILD_EXAMPLES=ON \
"

# split examples into dedicated package
PACKAGE_BEFORE_PN += "${PN}-bin"
FILES:${PN}-bin = "${bindir}/*"
