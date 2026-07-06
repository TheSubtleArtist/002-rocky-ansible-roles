# 002-rocky-ansible-roles

Refactor the Project 001 baseline into a reusable Ansible role structure with separate common, controller, and managed-node configuration logic.

## Repository Structure

```text
002-rocky-ansible-roles/
├── ansible/
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
│   ├── inventory-002.ini
│   ├── site.yml
│   ├── validate-002.yml
├── evidence/
│   └── validation-002-output.txt  
├── scripts/
│   ├── bootstrap-ansible-controller.sh
│   ├── deploy-private-key.sh
│   ├── deploy-public-key.sh
│   └── validation.sh
├── README.md
├── vagrant/.ssh
│   ├── ansible_lab
│   └── ansible_lab.pub
├── .gitignore
├── ansible.cfg
├── README.md
└── Vagrantfile
```

## Naming Conventions

Node names use a role-project-node pattern. For example, `controller-201` identifies the Project 002 controller node and the first node in the controller role. `managed-201` identifies the Project 002 managed node, and the first managed node.

## Build and Validation Workflow

### 1. Validate the Vagrantfile

Run this command from the repository root before creating or modifying virtual machines.

```powershell
vagrant validate
```

Expected result:

```text
Vagrantfile validated successfully.
```

This confirms that the Vagrant configuration is syntactically valid before any VM changes are made.

### 2. Start the Nodes

```powershell
vagrant up ansible-controller
```

This should create and start the controller VM only.

| VM Name            | Role                 | Private IP    | Resources           |
| ------------------ | -------------------- | ------------- | ------------------- |
| controller-201 | Ansible control node | 192.168.56.10 | 2 CPU / 2048 MB RAM |
| managed-201 | Managed Node | 192.168.56.11 | 1 CPU / 1024 MB RAM |

During this step, Vagrant should also generate the local lab SSH key pair if it does not already exist:

```text
vagrant/.ssh/ansible_lab
vagrant/.ssh/ansible_lab.pub
```

The controller provisioning process should install Ansible and place the generated private key where the `vagrant` user can use it:

```text
/home/vagrant/.ssh/ansible_lab
```

### 3. Confirm Node Status

Verify the current VM state.

```powershell
vagrant status
```

Expected result after starting only the controller:

```text
controller-201    running
manged-201        running
```

### 4. Access the Ansible controller

Connect to the controller VM.

```powershell
vagrant ssh controller-201vag
```

Successful login confirms that the controller VM is reachable through Vagrant-managed SSH.

### 5. Validate Ansible controller bootstrap

From inside the controller VM, confirm that Ansible is installed.

```bash
ansible --version
```

Successful output confirms that the controller bootstrap script completed and Ansible is available to the `vagrant` user.

### 6. Validate controller private key deployment

From inside the controller VM, confirm that the generated lab private key exists and has restrictive permissions.

```bash
ls -l /home/vagrant/.ssh/ansible_lab
```

Expected result should show permissions similar to:

```text
-rw-------. 1 vagrant vagrant ... /home/vagrant/.ssh/ansible_lab
```

This confirms that the controller has the private key required to connect to the managed node.

### 7. Confirm full lab status

Verify that both systems are running.

```powershell
vagrant status
```

Expected result:

```text
managed-201               running (virtualbox)
controller-201            running (virtualbox)
```

This confirms that both virtual machines exist and are active.

### 8. Validate private network connectivity

From inside the controller VM, test connectivity to the managed node.

```bash
ping -c 4 192.168.56.11
```

Expected result:

```text
4 packets transmitted, 4 received, 0% packet loss
```

This confirms that the private host-only network between the controller and managed node is working.

### 9. Validate Ansible inventory

From inside the controller VM, confirm that Ansible can read the inventory file.

```bash
ansible-inventory -i /vagrant/ansible/inventory-002.ini --list
```

Successful output confirms that the inventory file is valid and that Ansible can parse the managed node definition.

### 10. Test Ansible communication with the managed node

Run an Ansible ping test against the managed node.

```bash
ansible managed -i /vagrant/ansible/inventory-002.ini -m ping
```

Expected result:

```text
managed-201 | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
```

This confirms that the Ansible controller can reach and manage the target node over SSH using the generated lab key pair.

### 11. Test the Common Role

After the VMs are running, test the `common` Ansible role from the Ansible controller.

SSH into the controller:

```bash
vagrant ssh controller-201

/vagrant/scripts/test-common-roll.sh

```

`test-common-roll.sh` performs a repeatable development test of the common role. It uses the project-level ansible.cfg, runs a syntax check, performs a check-mode preview, executes the role, and captures output in the evidence/ directory.

Expected Results:

```text
failed=0
unreachable=0
```

