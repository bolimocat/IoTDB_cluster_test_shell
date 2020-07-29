#!/bin/bash
source ./cluster_parameter.sh
echo "Stop all node"
array_node=(`echo $nodeList|cut -d \: -f 1` `echo $nodeList|cut -d \: -f 2` `echo $nodeList|cut -d \: -f 3` `echo $nodeList|cut -d \: -f 4` `echo $nodeList|cut -d \: -f 5`) 	

	for((i=0;i<$clusterLength;i++));
	do
		ssh $user@${array_node[i]} 'pidstr=`jps -l|grep cluster`;pid=`echo "$pidstr" | tr -cd "[0-9]"`;kill -9 $pid '
		sleep 2
		echo " stop  $user@${array_node[i]}"		
	done
