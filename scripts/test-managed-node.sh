#!/usr/bin/env bash

set -euo pipefail

# If any command fails, print a clear error message before exiting.
trap 'echo "ERROR: Managed Node role test failed. Review the output above and the evidence files."; exit 1' ERR

cd /vagrant

#  https://docs.ansible.com/projects/ansible/latest/reference_appendices/config.html#avoiding-security-risks-with-ansible-cfg-in-the-current-directory
export ANSIBLE_CONFIG=/vagrant/ansible.cfg

mkdir -p /vagrant/evidence

echo "Validate 'test-managed-node-role.yml' syntax" 
ansible-playbook  ansible/tests/test-managed-node-role.yml --syntax-check

echo "Run 'test-managed-node-role.yml' check mode preview"
ansible-playbook ansible/tests/test-managed-node-role.yml --check --diff | tee /vagrant/evidence/test-managed-node-role-output.txt

echo "Running 'managed-node-role' tests"
ansible-playbook ansible/tests/test-managed-node-role.yml | tee /vagrant/evidence/test-managed-node-role-output.txt

echo "Managed Node role test completed successfully"