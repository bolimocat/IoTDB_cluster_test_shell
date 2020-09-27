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
# cp logs from every node
#timestamp=`cat $home/timestamp`
	for((i=0;i<$clusterLength;i++));
	do
		ssh $user@${array_node[i]} 'mkdir -p /home/'$user'/'$nodeResult'/'$1'/'
		ssh $user@${array_node[i]} 'cp -rf /home/'$user'/'$serverPath'/logs  /home/'$user'/'$nodeResult'/'$1'/logs'
		ssh $user@${array_node[i]} 'rm -rf /home/'$user'/'$serverPath'/logs/* '
		sleep 1
		echo " save logs  $user@${array_node[i]}"		
	done

# delete data file
	for((i=0;i<$clusterLength;i++));
	do
		#ssh $user@${array_node[i]} 'mkdir -p /home/'$user'/'$nodeResult'/'$1'/data '
		ssh $user@${array_node[i]} 'cp -rf /home/'$user'/'$serverPath'/data    /home/'$user'/'$nodeResult'/'$1'/data '
		ssh $user@${array_node[i]} 'rm -rf /home/'$user'/'$serverPath'/data   '
		sleep 1
		echo " delete data  $user@${array_node[i]}"		
	done


