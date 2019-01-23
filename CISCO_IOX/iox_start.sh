#! /bin/sh
 
# DISCLAIMER: This build script is intended for demonstration purposes only and
# is provided as-is with no warranty or support of any kind. Running the build
# script may result in third party software components being downloaded and 
# installed on your system. It is your responsibility to ensure that you have 
# all the necessary rights and permissions to use any such third party software.
# Cisco Systems, Inc., makes no representation about and assumes no liability 
# for any such third party software, including with regard to intellectual 
# property rights, licensing, malware, security, quality, functionality, 
# suitability, and performance.
# All use of the build script and any third party software is at your own risk.

# Enable package_config.ini processing:
#   TRUE : (default) Allow package_config.ini to override Perfsonar config files
#          including Meshconfig Agent Configuration URL IP Address
#   FALSE: Disable using package_config.ini to override any Perfsonar config 
#          files settings
ENABLE_PACKAGE_CONFIG="TRUE"

# IOX does not support "-v / docker VOLUME" feature.
# Must remove stale pid files to avoid PerfSonar pearl scripts failures 
#rm /var/run/lsregistrationdaemon.pid
#rm /var/run/perfsonar-meshconfig-agent.pid

# Check if specific User provided PerfSonar service configuation files exist,
# and copy them to the required service config directories before invoking
# supervisord which starts perfsonar.

# IOx supported PerfSonar User Configuration Files 
MESHCONFIG_AGENT="meshconfig-agent.conf"
MESHCONFIG_AGENT_TASKS="meshconfig-agent-tasks.conf"
LSREGISTRATION="lsregistrationdaemon.conf"
PACKAGE_CONFIG="package_config.ini"
APP_MESHCONFIG="/etc/perfsonar/meshconfig-agent.conf"

# Check if Cisco DNAC has provided a package_config.ini file to be read.
# NOTE: if package_config.ini is packaged with the IOX app, it will always be
# provided to the app in the "/data" shared dir. 

# IOx Application specific Cisco DNAC data dir
IOX_DATADIR="/data"

# package_config.ini MESHCONFIG_AGENT update
if [ "$ENABLE_PACKAGE_CONFIG" = "TRUE" ] && 
   [ -f $IOX_DATADIR/$PACKAGE_CONFIG ]; then
    CM_IP=`awk '/MESHCONFIG_AGENT_CONFIGURATION_URL_IP_ADDRESS/{ print $3 }' $IOX_DATADIR/$PACKAGE_CONFIG`
    echo "Meshconfig Agent Configuration URL IP=" $CM_IP
    sed -i -e "s;http.*$;http://$CM_IP/IoxAgent.json;" $APP_MESHCONFIG
    echo "App/Cisco DNAC provided $PACKAGE_CONFIG applied to $APP_MESHCONFIG."
else
    echo "No App/Cisco DNAC provided PACKAGE_CONFIG File."
fi

# Check if Local Manager (LM) uploaded an application specific file.
# Local Manager IOx Application specific data dir
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
# Must be last step in startup script!
# Cisco IOx requires the start-up script to run "forever" since the Cisco IOx 
# application will terminate whenever the IOx start-up script terminates. 
# Typically, the last start-up script command execution runs forever,
# which supervisord adheres to.

/usr/bin/supervisord -c /etc/supervisord.conf
