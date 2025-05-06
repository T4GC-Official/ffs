# Host Management for Flake

This document outlines how to provision, access, delete, and recycle hosts in the Flake infrastructure.

---

## Provisioning

### Staging / Development

1. Create a new virtual machine (VM) through the cloud provider's console.
2. Assign the VM to the `newnodes` security group.
3. Add your SSH public key (typically found in `~/.ssh/id_*.pub`) to the instance during creation, or manually after the VM is up by logging in via the cloud console and placing the key in `~/.ssh/authorized_keys`.
4. SSH into the VM and ensure port **61189** is open for SSH access (check inbound rules of `flake-development`).
5. Test SSH connectivity on port **61189**.
6. Create a `frappe` user that will be used for setting up the Frappe Bench, and grant it temporary `sudo` privileges.
7. Once the setup is complete, revoke `sudo` privileges from the `frappe` user.
8. Make sure SSH access for the `frappe` user is explicitly disabled to prevent direct remote login.
9. Once verified, remove the VM from the `newnodes` security group and assign it to the `flake-development` security group.

### Production

1. When promoting a VM to production, update its security group to `flake-prod`.
2. To perform code updates (e.g., pulling or pushing changes to GitHub), temporarily assign the VM to the `flake-development` security group, which has the required inbound rules.
3. After updates, revert the VM back to the `flake-prod` security group.

---

## Accessing

### SSH Access (Staging and Production)

- All Flake hosts, including staging and production, use **port 61189** for SSH access.
- To connect to a server:

  ```bash
  ssh -p 61189 root@<IP-Address>
