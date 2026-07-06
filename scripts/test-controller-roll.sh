#!/usr/bin/env bash

set -euo pipefail

# If any command fails, print a clear error message before exiting.
trap 'echo "ERROR: Controller role test failed. Review the output above and the evidence files."; exit 1' ERR

cd /vagrant

#  https://docs.ansible.com/projects/ansible/latest/reference_appendices/config.html#avoiding-security-risks-with-ansible-cfg-in-the-current-directory
export ANSIBLE_CONFIG=/vagrant/ansible.cfg

mkdir -p /vagrant/evidence

echo "Validate 'test-controller-role.yml' syntax" 
ansible-playbook  ansible/tests/test-controller-role.yml --syntax-check

echo "Run 'test-controller-role.yml' check mode preview"
ansible-playbook ansible/tests/test-controller-role.yml --check --diff | tee /vagrant/evidence/test-controller-role-output.txt

echo "Running 'controller-role' tests"
ansible-playbook ansible/tests/test-controller-role.yml | tee /vagrant/evidence/test-controller-role-output.txt

echo "Controller role test completed successfully"