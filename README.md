# Usage:
- This script is inted to be used with sosreports generated from OpenShift nodes that are using CRIO as contianer runtime.
- This script will list all of the containers that were "running" on the node and show some info about them:**
  - Container Name
  - Container PID
  - POD Name
  - Namespace
  - Container's CPU utilization
  - Container's MEM utilization

# Steps:

1- Download the sosreport
~~~
# ls -l
-rw-r--r--.  1 amr amr 32702552 Jul 15 11:32 sosreport-htxrtkg.tar.xz
~~~
2- Extract it
~~~
# tar xf sosreport.tar.xz

# ls -l
drwx------. 14 amr amr     4096 Jul  2 09:22 sosreport-htxrtkg
-rw-r--r--.  1 amr amr 32702552 Jul 15 11:32 sosreport-htxrtkg.tar.xz
~~~
3- Download the script and make it executable
~~~
# git clone https://github.com/AmrGanz/Containers-stats.git
# chmod +x ./Containers-stats/pods-info.sh
~~~
4- Run the script while pointing at the sosreport's directory
~~~
# Containers-stats/pods-info.sh /path/to/sosreport/sosreport-htxrtkg
~~~

# Example output:
~~~
==============
Project Name: openshift-machine-config-operator
Pod Name: machine-config-daemon-g6c8w
Container name: oauth-proxy
Container PID: 1269188
CPU: 0.2 %
MEM: 0.0 %
==============
Project Name: openshift-monitoring
Pod Name: node-exporter-cx5k4
Container name: kube-rbac-proxy
Container PID: 1269172
CPU: 0.1 %
MEM: 0.0 %
==============
Project Name: openshift-monitoring
Pod Name: node-exporter-cx5k4
Container name: node-exporter
Container PID: 1268586
CPU: 1.8 %
MEM: 0.0 %
==============
~~~
- If a pod has no "inspect" file under "sos_commands/crio/" directory, it will show you this error message:
~~~
POD: b2ec4ea27e115 has no inspect file under sosreport-htxrtkg/sos_commands/crio/
POD: 859d8f73558d8 has no inspect file under sosreport-htxrtkg/sos_commands/crio/
~~~

Note:
- These scripts are used with an OpenShift nodes, as they run multiple containers.
- This is still a work in progress and I will keep enhancing it
