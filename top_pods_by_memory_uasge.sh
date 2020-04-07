#!/bin/bash
echo "==================================="
echo "==============MEMORY==============="
echo "==================================="
echo "Please enter the total number of top processes you require: between 1 and 100"
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

PID=(`sort -rnk6 sos_commands/process/ps_auxwww | awk '{print $2}'`)
TOTALMEM=0
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
	  echo "Memory utilization: `grep $i sos_commands/process/ps_auxwww | awk '{print $4}'`%"
	  RSS=$(echo "scale=4; $(( `grep $i sos_commands/process/ps_auxwww | awk '{print $6}'` ))/1048576 " | bc -l)
	  echo "RSS: $RSS GB"
	  TOTALMEM=`echo "$TOTALMEM + $RSS" | bc`
	  echo "==================================="
	  COUNT=$((COUNT-1))
        fi
done
echo "Total MEM consumption of $PODS is $TOTALMEM GB"
