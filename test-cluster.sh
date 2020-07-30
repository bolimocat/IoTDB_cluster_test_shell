#!/bin/bash
source ./cluster_parameter.sh
echo "test cluster on node"
timestamp=`cat $home/timestamp`
	array_node=(`echo $nodeList|cut -d \: -f 1` `echo $nodeList|cut -d \: -f 2` `echo $nodeList|cut -d \: -f 3` `echo $nodeList|cut -d \: -f 4` `echo $nodeList|cut -d \: -f 5`)
	while read line
	do
		arrayTestType=(`echo $line|cut -d \: -f 1` `echo $line|cut -d \: -f 2`)
		if	test	${arrayTestType[0]}	= 'conf'
			then echo 'Test cluster conf'
			echo ' --------------    Test Conf Start ----------------------'>$home/result/conf_out
			echo ' --------------    Test Conf End ----------------------'>$home/result/conf_out

		fi

		if	test	${arrayTestType[0]}	= 'ddl'
			then echo 'Test cluster ddl'
			while read sqlStr
			do
			echo ' --------------    Test DDL  [   '$sqlStr'   ]  Start  ----------------------'>>$home/result/ddl_${arrayTestType[1]}_out
				ssh $user@${array_node[$[$RANDOM%5]]} '/home/'$user'/'$cliPath'/sbin/start-cli.sh -u root -pw root -h  '${array_node[$[$RANDOM%5]]} '  -p 55560 -e "'$sqlStr'"  ' >>$home/result/ddl_${arrayTestType[1]}_out                 
			echo ' --------------    Test DDL  [   '$sqlStr'   ]   End   ----------------------'>>$home/result/ddl_${arrayTestType[1]}_out
	
			done<$home/$testCase/ddl_test/${arrayTestType[1]}
			echo ' '>>$home/result/ddl_${arrayTestType[1]}_out
			echo ' '>>$home/result/ddl_${arrayTestType[1]}_out

		fi

		if	test	${arrayTestType[0]}	= 'dml'
			then echo 'Test cluster dml'
			while read sqlStr
			do
			echo ' --------------    Test DML   [  '$sqlStr'   ]   Start ----------------------'>>$home/result/dml_${arrayTestType[1]}_out
				for((i=0;i<clusterLength;i++));
				do
					ssh $user@${array_node[i]} '/home/'$user'/'$cliPath'/sbin/start-cli.sh -u root -pw root -h  '${array_node[i]} '  -p 55560 -e "'$sqlStr'"  ' >>$home/result/dml_${arrayTestType[1]}_out 
				done
			echo ' --------------    Test DDL    [   '$sqlStr'    ] End ----------------------'>>$home/result/dml_${arrayTestType[1]}_out
			done<$home/$testCase/ddl_test/${arrayTestType[1]}
			echo ' '>>$home/result/dml_${arrayTestType[1]}_out
			echo ' '>>$home/result/dml_${arrayTestType[1]}_out


		fi
	done<$home/task
