#!/bin/bash
source ./cluster_parameter.sh
echo "test cluster on node"
timestamp=`cat $home/timestamp`
	array_node=(`echo $nodeList|cut -d \: -f 1` `echo $nodeList|cut -d \: -f 2` `echo $nodeList|cut -d \: -f 3` `echo $nodeList|cut -d \: -f 4` `echo $nodeList|cut -d \: -f 5`)
	while read line
	do
		arrayTestType=(`echo $line|cut -d \: -f 1` `echo $line|cut -d \: -f 2`)
		if	test	${arrayTestType[0]}	= 'conf'
			then echo 'Test cluster conf' #��ʱû��conf�޸ķ��������
			echo ' --------------    Test Conf Start ----------------------'>$home/result/conf_out
			echo ' --------------    Test Conf End ----------------------'>$home/result/conf_out

		fi
		#����ddlִ�еķ�֧
		if	test	${arrayTestType[0]}	= 'ddl'
			then echo 'Test cluster ddl'
			#��$home/$testCase/ddl_test/${arrayTestType[1]}�ж�ȡddl��sqlstr���ļ�����task��ddl:�ļ����
			while read sqlStr
			do
		# start cluster ������Ⱥ���еĽڵ�
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
		#����dmlִ�еķ�֧
		if	test	${arrayTestType[0]}	= 'dml'
			then echo 'Test cluster dml'
			while read sqlStr
			do
		# start cluster
			source ./start-cluster.sh

			echo ' --------------    Test DML   [  '$sqlStr'   ]   Start ----------------------'>>$home/result/dml_${arrayTestType[1]}_out
				#dml������ԭ������ÿ���ڵ��϶����Բ�����������Ҫ��ÿ���ڵ���˳��ִ��һ�顣
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