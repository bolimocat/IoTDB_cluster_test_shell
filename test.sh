#!/bin/bash
source ./cluster_parameter.sh
echo "-- $serverpath"
source ./start-cluster.sh
echo " ---- "
sleep 10
source ./stop-cluster.sh
