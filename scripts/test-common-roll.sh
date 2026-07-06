#!/usr/bin/env bash

set -euo pipefail

# If any command fails, print a clear error message before exiting.
trap 'echo "ERROR: Common role test failed. Review the output above and the evidence files."; exit 1' ERR

cd /vagrant

#  https://docs.ansible.com/projects/ansible/latest/reference_appendices/config.html#avoiding-security-risks-with-ansible-cfg-in-the-current-directory
export ANSIBLE_CONFIG=/vagrant/ansible.cfg

mkdir -p /vagrant/evidence

echo "Validate 'test-common-role.yml' syntax" 
ansible-playbook  ansible/tests/test-common-role.yml --syntax-check

echo "Run 'test-common-role.yml' check mode preview"
ansible-playbook ansible/tests/test-common-role.yml --check --diff | tee /vagrant/evidence/test-common-role-output.txt

echo "Running 'common-role' tests"
ansible-playbook ansible/tests/test-common-role.yml | tee /vagrant/evidence/test-common-role-output.txt

echo "Common role test completed successfully"

