# DEMO_ZTP
please see offical doc first
https://docs.cumulusnetworks.com/display/DOCS/Zero+Touch+Provisioning+-+ZTP

This ZTP file will works well on dhcp ztp.


## tips

create group before create user

new user will not have bash completion , pleas create a .bashrc file

## DHCP part 
DHCP server can do a lot 
assig IP ,hostname 
point the ztp script link 
onie link 
shen@ubuntu:/etc/dhcp$ tree
.
├── ddns-keys [error opening dir]
├── debug
├── dhclient.conf
├── dhclient-enter-hooks.d
│   ├── debug -> ../debug
│   └── resolvconf
├── dhclient-exit-hooks.d
│   ├── debug -> ../debug
│   ├── rfc3442-classless-routes
│   └── timesyncd
├── dhcp_client
├── dhcpd.conf
├── dhcpd.hosts
└── dhcpd.pools


