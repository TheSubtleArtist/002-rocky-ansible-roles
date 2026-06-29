# 002-rocky-ansible-roles

Refactor the Project 001 baseline into a reusable Ansible role structure with separate common, controller, and managed-node configuration logic.


## Repository Structure

```text
002-rocky-ansible-roles/
├── README.md
├── .gitignore
├── Vagrantfile
├── ansible/
│   ├── inventory-002.ini
│   ├── site.yml
│   ├── validate-002.yml
│   └── roles/
│       ├── common/
│       │   ├── defaults/
│       │   │   └── main.yml
│       │   └── tasks/
│       │       └── main.yml
│       ├── controller/
│       │   ├── defaults/
│       │   │   └── main.yml
│       │   └── tasks/
│       │       └── main.yml
│       └── managed_node/
│           ├── defaults/
│           │   └── main.yml
│           └── tasks/
│               └── main.yml
├── scripts/
│   ├── bootstrap-ansible-controller.sh
│   ├── deploy-private-key.sh
│   ├── deploy-public-key.sh
│   └── validation.sh
└── evidence/
    └── validation-002-output.txt
```

## Naming Conventions

### Machine Names

Node names use a role-project-node pattern. For example, `controller-201` identifies the Project 002 controller node and the first node in the controller role. `managed-201` identifies the Project 002 managed node, and the first managed node.