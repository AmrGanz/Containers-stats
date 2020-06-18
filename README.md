# pods-info.sh

**This script will list all of the containers that were "running" on the node and show some info about them:**
- Container Name
- Container PID
- POD Name
- Namespace
- Container's CPU utilization
- Container's MEM utilization

# Steps:

1- Download a sosreport

2- Extract it

3- Switch to the extracted sosreport's directory

4- Copy script to sosreport directory

6- make script executable

5- Run the script


Note:
- These scripts are used with an OpenShift nodes, as they run multiple containers.
- This is still a work in progress and I will keep enhancing it
