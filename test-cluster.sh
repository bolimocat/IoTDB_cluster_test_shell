#!/bin/bash
source ./cluster_parameter.sh
echo "test cluster on every node"
	array_node=(`echo $nodeList|cut -d \: -f 1` `echo $nodeList|cut -d \: -f 2` `echo $nodeList|cut -d \: -f 3` `echo $nodeList|cut -d \: -f 4` `echo $nodeList|cut -d \: -f 5`) 	
	for((i=0;i<$clusterLength;i++ ));
	do
		ssh $user@${array_node[i]} '/home/'$user'/'$cliPath'/sbin/start-cli.sh -u root -pw root -h '${array_node[i]}' -p '$nodePort' -e "show storage group"   '
		echo "$user@${array_node[i]} "
	done
