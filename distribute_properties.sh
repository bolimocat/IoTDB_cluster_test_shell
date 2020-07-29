#!/bin/bash
echo "distribute properties for every node."
source ./cluster_parameter.sh
#create temp file start
	array_node=(`echo $nodeList|cut -d \: -f 1` `echo $nodeList|cut -d \: -f 2` `echo $nodeList|cut -d \: -f 3` `echo $nodeList|cut -d \: -f 4` `echo $nodeList|cut -d \: -f 5`) 	
	for((i=0;i<5;i++));
	do
		echo "${array_node[$i]}">>./nodeList
	done
#create temp file end

#get the properties folder
	array_profolder=(`echo $wareHouse|cut -d \: -f 1` `echo $wareHouse|cut -d \: -f 2` `echo $wareHouse|cut -d \: -f 3` `echo $wareHouse|cut -d \: -f 4` `echo $wareHouse|cut -d \: -f 5`) 
#get the properties folder end
#scp file to node
i=0
	while read line
	do
		scp -r ./${array_profolder[$i]}/* $user@$line:$serverPath/conf
		let "i=i+1"
	done<./nodeList
#scp file to node end
	rm -rf ./nodeList
