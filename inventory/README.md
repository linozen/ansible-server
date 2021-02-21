# Ansible Inventory

A unified plaintext store (`inventory.txt`) of all of our hosts that are managed
with Ansible. Supposed to be integrated into the relevant Ansible repos as a git
submodule.

## How it works
It is simple. The bash script `create-inventory.sh` reads the lines from
inventory.txt and constructs a well-defined Ansible inventory file for all our
hosts from it. This is handy because it allows for a more streamlined adding,
removing and changing of hosts and the groups that they are in.

### Adding a host
`inventory.txt` has the following structure. To add a new host, simply add a new
line starting with `-` followed by a space, then the hostname and then the
applicable groups in square brackets. 

To illustrate, `create-inventory.sh` would take the input below

``` text
# some comment
- example.fsfe.org [group1, group2, group3, group4]
- example2.fsfe.org [group1, group5]
```

and transform it into

``` ini
[group1]
example.fsfe.org
example2.fsfe.org

[group2]
example.fsfe.org

[group3]
example.fsfe.org

[group4]
example.fsfe.org

[group5]
example2.fsfe.org
```

### Removing or changing a host
The script regenarates the `hosts` file on each run. So, removing or changing a
host is trivial.

## Possible future improvements
- [x] Make script more robust to, for example, allow for comments in
      `inventory.txt`
- [ ] Create CLI to remove, update and add hosts and groups
      
## Resources
- Anisble Docs on working with inventories
  (https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html)
- Ansible Docs on working with _dynamic_ inventories
  (https://docs.ansible.com/ansible/latest/user_guide/intro_dynamic_inventory.html)
  - the above links to repo containing a number of dynamic inventory generation
    scripts including one for ProxMox
    (https://github.com/ansible-collections/community.general/blob/main/scripts/inventory/proxmox.py)
