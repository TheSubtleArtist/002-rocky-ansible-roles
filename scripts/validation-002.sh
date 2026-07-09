#!/usr/bin/env bash

set -euo pipefail

# If any command fails, print a clear error message before exiting.
trap 'echo "ERROR: Validation-002 failed. Review the output above and the evidence files."; exit 1' ERR

#  https://docs.ansible.com/projects/ansible/latest/reference_appendices/config.html#avoiding-security-risks-with-ansible-cfg-in-the-current-directory
export ANSIBLE_CONFIG=/vagrant/ansible.cfg

mkdir -p /vagrant/evidence

echo "Running validate-002.yml syntax check"

# --syntax-check parses the playbook and confirms the YAML and Ansible playbook structure are valid.
#
# This does not connect to hosts and does not apply configuration.
# It catches errors such as bad indentation, invalid playbook structure,
# misspelled Ansible keywords, or malformed YAML before any system changes occur.

ansible-playbook /vagrant/ansible/validate-002.yml --syntax-check

echo "Running validate-002.yml check mode preview"

# --check runs the playbook in dry-run mode.
#
# Ansible connects to the target hosts and reports what it expects would change,
# but it does not intentionally apply those changes.
#
# This is useful for reviewing intended changes before executing the playbook.
# It is not a substitute for a real execution test because some modules cannot
# fully predict changes in check mode.

ansible-playbook /vagrant/ansible/validate-002.yml --check

echo "Running validate-002.yml check mode preview with diff output"

# --diff shows before-and-after differences for modules that support diff output.
#
# This is most useful when Ansible manages files, templates, or configuration
# content. It is less useful for package installation because package changes
# usually do not produce a readable file-style diff.
#
# When combined with --check, --diff helps preview what content would change
# before the playbook is actually executed.

ansible-playbook /vagrant/ansible/validate-002.yml --check --diff