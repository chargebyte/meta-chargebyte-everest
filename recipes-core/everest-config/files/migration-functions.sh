# this script is to be sourced by a Bourne shell

export EVEREST_CONFIG_FILE=/etc/everest/config.yaml
export EVEREST_CONFIG_MIGRATION_DIR=/usr/libexec/everest/migration.d
export MARKER_DIR=/var/lib/everest/migration

# run_once():
# <unique identified> <program> [<program argument> [<...>]]
function run_once() {
    if [ $# -lt 2 ]; then
        return 1;
    fi

    MARKER="$1"
    shift

    if [ ! -d "$MARKER_DIR" ]; then
        mkdir -p "$MARKER_DIR" || return 1
    fi

    MARKERFILE="$MARKER_DIR/$MARKER"
    if [ ! -f "$MARKER_DIR/$MARKER" ]; then
        # run the given tool
        "$@"
        [ $? == 0 ] || return 1
        touch "$MARKERFILE"
    fi
}
