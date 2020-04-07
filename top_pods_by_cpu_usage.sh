#!/bin/bash
echo "==================================="
echo "===============CPU================="
echo "==================================="
echo "Please enter the total number of top processes between 1 and 100"
read COUNT
while :; do
	if (( $COUNT <= 0 || $COUNT > 100 )); then
    		echo "in loop"
    		echo "Please enter the total number of top processes between 1 and 100"
    		read COUNT
	else
		break
	fi
done
PODS=$COUNT
TOTALCPU="0"
PID=(`sort -rnk3 sos_commands/process/ps_auxwww | awk '{print $2}'`)

for i in ${PID[*]}
do
        CRIO=`grep -s crio- -m1 proc/$i/mountinfo | cut -d "-" -f5 | cut -d"." -f1`
        if [ -n "${CRIO// }" ] && [ $COUNT -gt 0 ]
	then
	  echo "==================================="
          echo "ProcessID $i"
          POD=`grep -s "pod.name\"" sos_commands/runc/runc_state_$CRIO | awk '{print $2}' | sed 's/"//g' | sed 's/,//g' `
          echo "Pod Name: $POD"
          NAMESPACE=`grep -s "pod.namespace\"" sos_commands/runc/runc_state_$CRIO | awk '{print $2}' | sed 's/"//g' | sed 's/,//g'`
          echo "namespace: $NAMESPACE"
	  CPU=`grep $i sos_commands/process/ps_auxwww | awk '{print $3}'`
	  echo "CPU utilization: $CPU%"
	  TOTALCPU=`echo "$TOTALCPU + $CPU" | bc`
	  echo "==================================="
	  COUNT=$((COUNT-1))
        fi
done
echo "Total CPU consumption of top $PODS PODs is "$TOTALCPU"%"
