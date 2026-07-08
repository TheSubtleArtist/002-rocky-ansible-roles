#!/usr/bin/env bash

echo "Running site.yml syntax check"

# --syntax-check parses the playbook and confirms the YAML and Ansible playbook structure are valid.
#
# This does not connect to hosts and does not apply configuration.
# It catches errors such as bad indentation, invalid playbook structure,
# misspelled Ansible keywords, or malformed YAML before any system changes occur.

ansible-playbook ansible/site.yml --syntax-check

echo "Running site.yml check mode preview"

# --check runs the playbook in dry-run mode.
#
# Ansible connects to the target hosts and reports what it expects would change,
# but it does not intentionally apply those changes.
#
# This is useful for reviewing intended changes before executing the playbook.
# It is not a substitute for a real execution test because some modules cannot
# fully predict changes in check mode.

ansible-playbook ansible/site.yml --check

echo "Running site.yml check mode preview with diff output"

# --diff shows before-and-after differences for modules that support diff output.
#
# This is most useful when Ansible manages files, templates, or configuration
# content. It is less useful for package installation because package changes
# usually do not produce a readable file-style diff.
#
# When combined with --check, --diff helps preview what content would change
# before the playbook is actually executed.

ansible-playbook ansible/site.yml --check --diff