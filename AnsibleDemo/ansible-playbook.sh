#!/bin/bash
set -o nounset -o pipefail -o errexit

# Load all variables from .env and export them all for Ansible to read
set -o allexport
source "$(dirname "$0")/.env"
set +o allexport

# Run Ansible
#exec ansible webhosts -m ping -i ./inventory.yaml
exec ansible-playbook -i ./inventory.yaml --tags $1 ./playbook.yaml
