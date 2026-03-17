FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:remove = "file://Fixup-dependencies-for-newer-npm-versions.patch"
SRC_URI += "file://Fixup-dependencies-for-newer-npm-versions.fixed.patch"
