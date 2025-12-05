FILESEXTRAPATHS:prepend := "${THISDIR}/libiso15118:"

SRC_URI:append:parsley = " \
    file://libiso15118_Ev_Termination_Code.patch \
    file://libiso15118_Publish_ResponseCode.patch \
"
