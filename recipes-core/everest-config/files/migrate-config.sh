#!/bin/sh

# Migration scripts and tools are placed here
EVEREST_CONFIG_MIGRATION_DIR=/usr/libexec/everest/migration.d

echo "Starting to migrate EVerest configurations"

# Run the migration tools
for script in "${EVEREST_CONFIG_MIGRATION_DIR}"/*.sh; do
    "${script}"
done

echo "EVerest configurations migrated successfully"
