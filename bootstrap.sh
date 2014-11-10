#!/bin/bash
#configures hostname + ipaddress onboot from ovf properties 

VMTOOLSD='/usr/sbin/vmtoolsd'
CENTERID=`$VMTOOLSD --cmd "info-get guestinfo.ovfenv" | grep "centerid" | awk -F'"' '{ print $4 }'`
IP=`$VMTOOLSD --cmd "info-get guestinfo.ovfenv" | grep "ip" | grep "ip" | awk -F'"' '{ print $4 }'`
NETMASK=`$VMTOOLSD --cmd "info-get guestinfo.ovfenv" | grep "netmask" | grep "netmask" | awk -F'"' '{ print $4 }'`
GATEWAY=`$VMTOOLSD --cmd "info-get guestinfo.ovfenv" | grep "gateway" | grep "gateway" | awk -F'"' '{ print $4 }'`

NETWORK_TEMPLATE=./network.template
IF_TEMPLATE=./ifcfg-eth0.template
ISSUE_TEMPLATE=./issue.template

NETWORK_FILE=/etc/sysconfig/network
IF_ETH0=/etc/sysconfig/network-scripts/ifcfg-eth0
ISSUE_FILE=/etc/issue

DOMAIN="example.com"
ENV=prd
HOSTID=0001
CUSTOM_HOSTNAME="v${CENTERID}lx${HOSTID}.inf.${ENV}.${DOMAIN}"

function set_hostname {
	sed -e "s/%HOSTNAME%/$CUSTOM_HOSTNAME/g" $NETWORK_TEMPLATE > $NETWORK_FILE
}

function set_network {
	sed -e "s/%IP%/IPADDR=${IP}/" $IF_TEMPLATE \
	    -e "s/%NETMASK%/NETMASK=${NETMASK}/" \
	    -e "s/%GATEWAY%/GATEWAY=${GATEWAY}/" > $IF_ETH0
}

set_issue() {
    awk -v \
        r="$(ip -o addr | awk '/inet [1-9]+/ { print $2 " " $4 }')" \
        '{ gsub(/%INTERFACES%/,r) }1' \
        $ISSUE_TEMPLATE > $ISSUE_FILE
}

set_hostname
set_network
set_issue
