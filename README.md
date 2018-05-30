# DEMO_ZTP
please see offical doc first
https://docs.cumulusnetworks.com/display/DOCS/Zero+Touch+Provisioning+-+ZTP

This ZTP file will works well on dhcp ztp.


## tips

create group before create user

new user will not have bash completion , pleas create a .bashrc file

## DHCP part 
DHCP server can do a lot of work 
assign IP ,hostname 
point the ztp script link ,onie link
 
"./dhcp_gen list" to generate dhcpd.hosts file for isc-dhcp-server

