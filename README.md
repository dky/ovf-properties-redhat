OVF-redhat/centos bootstrap
---------------------------

##Glue script to extract OVF values from vsphere and populate:

- /etc/sysconfig/network
- /etc/sysconfig/network-scripts
- /etc/issue

We needed to deploy about 40 appliances to various locations and needed this to delegate 
deployment + configuration to other administrators without having them log into a shell.

##Usage:

Add /etc/bootstrap.sh to /etc/rc.local

##ToDo:

Test further, possibly role in puppet agent register.
