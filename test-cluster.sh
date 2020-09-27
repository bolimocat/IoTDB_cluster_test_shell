#!/bin/bash
source ./cluster_parameter.sh
echo "test cluster on node"
timestamp=`cat $home/timestamp`
	array_node=(`echo $nodeList|cut -d \: -f 1` `echo $nodeList|cut -d \: -f 2` `echo $nodeList|cut -d \: -f 3` `echo $nodeList|cut -d \: -f 4` `echo $nodeList|cut -d \: -f 5`)
	while read line
	do
		arrayTestType=(`echo $line|cut -d \: -f 1` `echo $line|cut -d \: -f 2`)
		if	test	${arrayTestType[0]}	= 'conf'
			then echo 'Test cluster conf' #暂时没有conf修改方面的设置
			echo ' --------------    Test Conf Start ----------------------'>$home/result/conf_out
			echo ' --------------    Test Conf End ----------------------'>$home/result/conf_out

		fi
		#进入ddl执行的分支
		if	test	${arrayTestType[0]}	= 'ddl'
			then echo 'Test cluster ddl'
			#从$home/$testCase/ddl_test/${arrayTestType[1]}中读取ddl的sqlstr，文件名是task中ddl:文件编号
			while read sqlStr
			do
		# start cluster 启动集群所有的节点
			source ./start-cluster.sh	
			echo ' --------------    Test DDL  [   '$sqlStr'   ]  Start  ----------------------'>>$home/result/ddl_${arrayTestType[1]}_out
				ssh $user@${array_node[$[$RANDOM%3]]} '/home/'$user'/'$cliPath'/sbin/start-cli.sh -u root -pw root -h  '${array_node[$[$RANDOM%3]]} '  -p 55560 -e "'$sqlStr'"  ' >>$home/result/ddl_${arrayTestType[1]}_out
				echo "------------ "$user@${array_node[$[$RANDOM%3]]} '/home/'$user'/'$cliPath'/sbin/start-cli.sh -u root -pw root -h  '${array_node[$[$RANDOM%3]]} '  -p 55560 -e "'$sqlStr'"  '
				#ssh $user@${array_node[$[$RANDOM%5]]} '/home/'$user'/'$cliPath'/sbin/start-cli.sh -u root -pw root -h  '${array_node[$[$RANDOM%5]]} '  -p 55560 -e "'$sqlStr'"  ' 
		                 
			echo ' --------------    Test DDL  [   '$sqlStr'   ]   End   ----------------------'>>$home/result/ddl_${arrayTestType[1]}_out
		# stop cluster
			sleep 5
			source ./stop-cluster.sh ddl_${arrayTestType[1]}
			done<$home/$testCase/ddl_test/${arrayTestType[1]}
			echo ' '>>$home/result/ddl_${arrayTestType[1]}_out
			echo ' '>>$home/result/ddl_${arrayTestType[1]}_out

		fi
		#进入dml执行的分支
		if	test	${arrayTestType[0]}	= 'dml'
			then echo 'Test cluster dml'
			while read sqlStr
			do
		# start cluster
			source ./start-cluster.sh

			echo ' --------------    Test DML   [  '$sqlStr'   ]   Start ----------------------'>>$home/result/dml_${arrayTestType[1]}_out
				#dml操作，原则上在每个节点上都可以操作，所以需要在每个节点上顺序执行一遍。
				for((i=0;i<clusterLength;i++));
				do
					ssh $user@${array_node[i]} '/home/'$user'/'$cliPath'/sbin/start-cli.sh -u root -pw root -h  '${array_node[i]} '  -p 55560 -e "'$sqlStr'"  ' >>$home/result/dml_${arrayTestType[1]}_out 
				done
			echo ' --------------    Test DDL    [   '$sqlStr'    ] End ----------------------'>>$home/result/dml_${arrayTestType[1]}_out
		# stop cluster
			sleep 5
			source ./stop-cluster.sh dml_${arrayTestType[1]}

			done<$home/$testCase/ddl_test/${arrayTestType[1]}
			echo ' '>>$home/result/dml_${arrayTestType[1]}_out
			echo ' '>>$home/result/dml_${arrayTestType[1]}_out


		fi
	done<$home/task