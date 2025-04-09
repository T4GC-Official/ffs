# Host Management for Flake 

This document outlines how to access, create, delete and recycle Flake hosts. 

## Provisioning 

### Staging/Dev 

1. Create a new host through the cloud console. Give it the security group `newnodes`.
2. Make sure you add your SSH public key (typically in `~/.ssh/id_*.pub`) to this host or you will be unable to perform the remaining steps 
3. SSH in and enable SSH access on both 22 and the development port (see inbound rules of `newnodes`/`flake-development`)   
4. Test that SSH works on the development port 
5. Remove VM from the `newnodes` security group and add it to the `flake-development` security group

### Production 

TODO 

## Accessing 

TODO


