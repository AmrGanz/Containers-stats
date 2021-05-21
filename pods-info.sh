#!/bin/bash
file=pods_status_`date +"%d-%m-%Y_%H-%M"`
echo -e "ProjName ContName ContID PodName PodID CPU(%) MEM(%) MEM(GB)\n" > /tmp/$file

CONTAINERS=`cat $1/sos_commands/crio/crictl_ps | awk '{print $1}' | grep -v CONTAINER`

for i in $CONTAINERS ; do
        CONT=`ls $1/sos_commands/crio/ | grep $i | grep inspect`
        if [ -z "$CONT" ]; then
                continue
        else
                NAMESPACE=$(cat $1/sos_commands/crio/$CONT |  jq -r '.status.labels."io.kubernetes.pod.namespace"')
                PODNAME=$(cat $1/sos_commands/crio/$CONT |  jq -r '.status.labels."io.kubernetes.pod.name"')
                PODID=$(cat $1/sos_commands/crio/$CONT |  jq -r '.sandboxId' | cut -c "1-13")
                CONTID=$(cat $1/sos_commands/crio/$CONT |  jq -r '.status.id' | cut -c "1-13")
                CONTNAME=$(cat $1/sos_commands/crio/$CONT |  jq -r '.status.labels."io.kubernetes.container.name"')
                CONTPID=$(cat $1/sos_commands/crio/$CONT |  jq -r .pid)
                CPU=$(cat $1/sos_commands/process/ps_auxwww | awk '{print $2, $3}' | grep -w $CONTPID | awk '{print $2}')
                MEM1=$(cat $1/sos_commands/process/ps_auxwww | awk '{print $2, $4}' | grep -w ^$CONTPID | awk '{print $2}')
                MEM2=$(echo "scale=2; $(cat $1/sos_commands/process/ps_auxwww | awk '{print $2, $6}' | grep -w ^$CONTPID | awk '{print $2}') / 1048576" | bc -l)
                echo -e "$NAMESPACE $CONTNAME $CONTID $PODNAME $PODID $CPU $MEM1 $MEM2\n" >> /tmp/$file
        fi
done


cat /tmp/$file | column -t -s " "
