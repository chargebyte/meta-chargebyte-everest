#!/bin/sh

case "$1" in
	install-check)
		if [ "$RAUC_MF_COMPATIBLE" != "$RAUC_SYSTEM_COMPATIBLE" ]; then
			echo "Compatible does not match!" 1>&2
			exit 10
		fi
		;;

	slot-pre-install)
		[ -d "$RAUC_MOUNT_PREFIX/bundle/pre-install.d" ] && \
		/bin/run-parts -a "$RAUC_SLOT_CLASS" -a "$RAUC_SLOT_MOUNT_POINT" -a "$RAUC_MOUNT_PREFIX/bundle" -- "$RAUC_MOUNT_PREFIX/bundle/pre-install.d"
		;;

	slot-post-install)
		[ -d "$RAUC_MOUNT_PREFIX/bundle/post-install.d" ] && \
		/bin/run-parts -a "$RAUC_SLOT_CLASS" -a "$RAUC_SLOT_MOUNT_POINT" -a "$RAUC_MOUNT_PREFIX/bundle" -- "$RAUC_MOUNT_PREFIX/bundle/post-install.d"
		;;

	*)
		exit 1
		;;
esac

exit 0
