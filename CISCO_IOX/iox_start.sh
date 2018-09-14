#! /bin/sh
#
# DISCLAIMER: This build script is intended for demonstration purposes only and is provided as-is with
# no warranty or support of any kind. Running the build script may result in third party software components
# being downloaded and installed on your system. It is your responsibility to ensure that you have all the
# necessary rights and permissions to use any such third party software. Cisco Systems, Inc., makes no representation
# about and assumes no liability for any such third party software, including with regard to intellectual property
# rights, licensing, malware, security, quality, functionality, suitability, and performance.
# All use of the build script and any third party software is at your own risk.

# IOX does not support "-v / docker VOLUME" feature.
# Must remove stale pid files which prevent PerfSonar pearl scripts from failing
#rm /var/run/lsregistrationdaemon.pid
#rm /var/run/perfsonar-meshconfig-agent.pid

# Check if specific User provided PerfSonar service configuation files exist,
# and copy them to the required service config directories before
# invoke perfsonar.

# IOx supported PerfSonar User Configuration Files 
MESHCONFIG_AGENT="meshconfig-agent.conf"
MESHCONFIG_AGENT_TASKS="meshconfig-agent-tasks.conf"
LSREGISTRATION="lsregistrationdaemon.conf"

# IOx Application specific data dir
IOX_DATADIR="/data/appdata"


# MESHCONFIG_AGENT check
if [ -f $IOX_DATADIR/$MESHCONFIG_AGENT ]; then
    cp $IOX_DATADIR/$MESHCONFIG_AGENT /etc/perfsonar/
    chown perfsonar:perfsonar /etc/perfsonar/$MESHCONFIG_AGENT 
    echo "User provided $MESHCONFIG_AGENT applied."
else
    echo "No User provided $MESHCONFIG_AGENT ."
fi

# MESHCONFIG_AGENT_TASKS check
if [ -f $IOX_DATADIR/$MESHCONFIG_AGENT_TASKS ]; then
    cp $IOX_DATADIR/$MESHCONFIG_AGENT_TASKS /etc/perfsonar/
    chown perfsonar:perfsonar /etc/perfsonar/$MESHCONFIG_AGENT_TASKS 
echo "User provided $MESHCONFIG_AGENT_TASKS applied."
else
    echo "No User provided $MESHCONFIG_AGENT_TASKS ."
fi

# LSREGISTRATION check
if [ -f $IOX_DATADIR/$LSREGISTRATION ]; then
    cp $IOX_DATADIR/$LSREGISTRATION /etc/perfsonar/
    chown perfsonar:perfsonar /etc/perfsonar/$LSREGISTRATION
    echo "User provided $LSREGISTRATION applied."
else
    echo "No User provided $LSREGISTRATION ."
fi

# Add any PerfSonar specific static routing configurations here to auto create routes
# when the IOx application is started.
# Gateway is the VPG IP address that eth0 is connected to.
#
# Example:
# route add -net 10.7.7.0 netmask 255.255.255.0 gw 11.0.0.1


# Invoke docker based supervisord init script.
# Cisco IOx requires the start-up script to run "forever" since the
# Cisco IOx application will terminate whenever the IOx start-up script terminates. 
# Typically, the last start-up script command execution runs forever,
# which supervisord adheres to.

/usr/bin/supervisord -c /etc/supervisord.conf
