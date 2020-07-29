#!/bin/bash
source ./cluster_parameter.sh
echo "Start all node ."
echo "$user"
#create temp file start
	array_node=(`echo $nodeList|cut -d \: -f 1` `echo $nodeList|cut -d \: -f 2` `echo $nodeList|cut -d \: -f 3` `echo $nodeList|cut -d \: -f 4` `echo $nodeList|cut -d \: -f 5`) 	
	for((i=0;i<5;i++));
	do
		echo "${array_node[$i]}">>./nodeList
	done
#create temp file end

#start node
	for((i=0;i<$clusterLength;i++));
	do
		ssh $user@${array_node[i]} 'echo "nohup /home/'$user'/'$serverPath'/sbin/start-node.sh > /dev/null 2>&1 & "|bash '
		sleep 5
		if	test $? -eq 0
		then echo "${array_node[i]} node start up is correct !"
		else
		echo "${array_node[i]} node start up is fail !"
		exit 1
		fi
	done
	
#start node end
	rm -rf ./nodeList
