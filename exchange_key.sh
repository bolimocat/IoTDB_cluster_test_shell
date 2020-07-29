#!/bin/bash
source ./cluster_parameter.sh
echo "exchange key for cluster file transport"
#create temp file start
	array_node=(`echo $nodeList|cut -d \: -f 1` `echo $nodeList|cut -d \: -f 2` `echo $nodeList|cut -d \: -f 3` `echo $nodeList|cut -d \: -f 4` `echo $nodeList|cut -d \: -f 5`) 	
	for((i=0;i<5;i++));
	do
		echo "${array_node[$i]}">>./nodeList
	done
#create temp file end
	#echo "$line"
		ssh-keygen -t rsa -P '' -f /home/$user/.ssh/id_rsa
		if	test	$?	-eq	0
			then echo "$user generate public key is correct."
		else
			echo "$user generate public key is incorrect."
			exit 1
		fi
	while read line
	do
		echo "ssh-copy the id for  user $line"
		ssh-copy-id -i /home/$user/.ssh/id_rsa.pub $user@$line	
	done<./nodeList



#delete temp file
	rm -rf ./nodeList
