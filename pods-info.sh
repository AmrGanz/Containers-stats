#!/bin/bash
SOSPATH=$1
CONTAINERS=`cat $SOSPATH/sos_commands/crio/crictl_ps | grep  Running | awk '{print $1}' | grep -v CONTAINER`

for i in $CONTAINERS ; do
        CONT=`ls $SOSPATH/sos_commands/crio/ | grep $i | grep inspect`
        if [ -z "$CONT" ]
        then
                echo "POD: $i has no inspect file under $SOSPATH/sos_commands/crio/"
        else
                NAMESPACE=$(cat $SOSPATH/sos_commands/crio/$CONT |  jq -r '.status.labels."io.kubernetes.pod.namespace"')
                PODNAME=$(cat $SOSPATH/sos_commands/crio/$CONT |  jq -r '.status.labels."io.kubernetes.pod.name"')
                CONTNAME=$(cat $SOSPATH/sos_commands/crio/$CONT |  jq -r '.status.labels."io.kubernetes.container.name"')
                CONTPID=$(cat $SOSPATH/sos_commands/crio/$CONT |  jq -r .pid)
                CPU=$(cat $SOSPATH/sos_commands/process/ps_auxwww | awk '{print $2, $3}' | grep -w $CONTPID | awk '{print $2}')
                MEM=$(cat $SOSPATH/sos_commands/process/ps_auxwww | awk '{print $2, $4}' | grep -w $CONTPID | awk '{print $2}')
                echo "=============="
                echo "Project Name: $NAMESPACE"
                echo "Pod Name: $PODNAME"
                echo "Container name: $CONTNAME"
                echo "Container PID: $CONTPID"
                echo "CPU: $CPU %"
                echo "MEM: $MEM %"
        fi
done
