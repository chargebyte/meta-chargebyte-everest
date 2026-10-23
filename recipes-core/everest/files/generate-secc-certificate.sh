#!/bin/sh
# Create a fallback certificate for EvseSecurity's default V2G directories.
# SECC_CERT_DIR can override the directory when running this script manually.
set -eu
umask 077

cert_dir=${SECC_CERT_DIR:-/etc/everest/certs/client/cso}

# Leave existing certificates alone, including expired or invalid ones.
for cert in "$cert_dir"/*.pem "$cert_dir"/*.crt "$cert_dir"/*.der; do
    if [ -e "$cert" ] || [ -L "$cert" ]; then
        exit 0
    fi
done

mkdir -p "$cert_dir"
work_dir=$(mktemp -d "$cert_dir/.selfsigned-XXXXXX")
key_file=$cert_dir/SECC_SELF_SIGNED.key
cert_file=$cert_dir/SECC_SELF_SIGNED.pem
key_installed=false
cert_installed=false

cleanup() {
    if [ "$key_installed" = true ] && [ "$cert_installed" = false ]; then
        rm -f "$key_file"
    fi
    rm -rf "$work_dir"
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM

# Use a configuration file so hostname characters are not interpreted as a DN.
common_name=$(uname -n)
cat > "$work_dir/openssl.cnf" <<EOF
[req]
prompt = no
distinguished_name = subject
x509_extensions = server
[subject]
C = DE
O = chargebyte
CN = $common_name
[server]
basicConstraints = critical,CA:FALSE
keyUsage = critical,digitalSignature
extendedKeyUsage = serverAuth
EOF

openssl req -new -x509 -newkey ec -pkeyopt ec_paramgen_curve:secp384r1 \
    -nodes -sha384 -days 3650 -config "$work_dir/openssl.cnf" \
    -keyout "$work_dir/secc.key" -out "$work_dir/secc.pem"
chmod 0644 "$work_dir/secc.pem"

# Publish complete files without overwriting existing files or symlinks.
ln "$work_dir/secc.key" "$key_file"
key_installed=true
ln "$work_dir/secc.pem" "$cert_file"
cert_installed=true
echo "Created self-signed SECC certificate: $cert_file"
