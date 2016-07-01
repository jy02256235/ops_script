#!/bin/bash
host_ip=($(sed -n 18,25p /etc/ansible/hosts));
#context="sed -i '21iUser_Alias ADMINS = snmp, zabbix_agented' /etc/sudoers"
for connect in ${host_ip[@]} 
do
	ssh root@${connect} "sed -i '21iUser_Alias ADMINS = snmp, zabbix_agented, redis_user, memcached_user' /etc/sudoers" 
#	ssh root@${connect} "sed -i 109i'ADMINS   ALL=(ALL)      ALL' /etc/sudoers" 
done

