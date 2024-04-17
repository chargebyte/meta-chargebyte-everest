# Workaround: internal production environment requires the tool "burnutil"
# to be included in the installed firmware but since we don't have a normal
# user (dependency) we have to force-pull it here. This might be reverted
# when the internal production process is adapted.
RDEPENDS:${PN} += "libcrypti2c"
