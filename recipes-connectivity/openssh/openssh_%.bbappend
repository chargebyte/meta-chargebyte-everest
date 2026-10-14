# sshd is socket-activated. The ssh-autostart condition determines whether
# the enabled socket actually starts listening at boot.
SYSTEMD_AUTO_ENABLE:${PN}-sshd = "enable"
