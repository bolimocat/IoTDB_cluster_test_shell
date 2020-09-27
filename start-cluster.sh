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
echo `date +%Y%m%d%H%M%S` >$home/timestamp
timestamp=`cat $home/timestamp`
# create result on every_node 
	#for((i=0;i<$clusterLength;i++));
	#do
		#ssh $user@${array_node[i]} 'mkdir -p /home/'$user'/'$nodeResult'/'$timestamp' '
		sleep 1
		#if	test $? -eq 0
		#then echo "${array_node[i]} node create result is correct !"
		#else
		#echo "${array_node[i]} node create result is fail !"
		#exit 1
		#fi
	#done
# create result on every_node end
	

	rm -rf ./nodeList
