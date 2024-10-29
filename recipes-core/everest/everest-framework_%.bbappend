FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " \
    file://0001-Fix-flush-MQTT-connect-message-immediately.patch \
"

# we don't require nodejs-native when we disable javascript modules
DEPENDS:remove = "nodejs-native"

# then we can also reset this (was enabled in upstream recipe)
do_configure[network] = "0"

# globally disable javascript modules for our embedded platforms
EXTRA_OECMAKE += " \
    -DEVEREST_ENABLE_JS_SUPPORT=OFF \
"
