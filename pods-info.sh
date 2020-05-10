#!/bin/bash
CONTAINERS=`cat sos_commands/crio/crictl_ps | awk '{print $1}' | grep -v CONTAINER`

for i in $CONTAINERS ; do
	CONT=`ls sos_commands/crio/ | grep $i | grep inspect`
	NAMESPACE=$(cat sos_commands/crio/$CONT |  jq -r '.status.labels."io.kubernetes.pod.namespace"')
	PODNAME=$(cat sos_commands/crio/$CONT |  jq -r '.status.labels."io.kubernetes.pod.name"')
	CONTNAME=$(cat sos_commands/crio/$CONT |  jq -r '.status.labels."io.kubernetes.container.name"')
	CONTPID=$(cat sos_commands/crio/$CONT |  jq -r .pid)
	CPU=$(cat sos_commands/process/ps_auxwww | awk '{print $2, $3}' | grep -w $CONTPID | awk '{print $2}')
	MEM=$(cat sos_commands/process/ps_auxwww | awk '{print $2, $4}' | grep -w $CONTPID | awk '{print $2}')
	echo "=============="
	echo "Project Name: $NAMESPACE"
	echo "Pod Name: $PODNAME"
	echo "Container name: $CONTNAME"
	echo "Container PID: $CONTPID"
	echo "CPU: $CPU %"
	echo "MEM: $MEM %"
done
