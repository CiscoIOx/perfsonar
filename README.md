DISCLAIMER: This build script is intended for demonstration purposes only and is
provided as-is with no warranty or support of any kind. Running the build script
may result in third party software components being downloaded and installed on
your system. It is your responsibility to ensure that you have all the necessary
rights and permissions to use any such third party software. Cisco Systems, Inc.,
makes no representations about and assumes no liability for any such third party
software, including with regard to intellectual property rights, licensing,
malware, security, quality, functionality, suitability, and performance.
All use of the build script and any third party software is at your own risk.

================================================================================

# Cisco IOx Perfsonar Application
This Cisco IOx Perfsonar application is based on the Internet2 docker perfsonar-testpoint image. An external Central Measurement component is required since local GUI and Measurement Database are not supported to provide the smallest resource requirements for the IOx Perfsonar application. This is an IOx reference application, highlighting how a standard docker image is repackaged into a Cisco IOx application.
Modifications to the build script can be made to custom taylor the features required by the customer.

# Cisco IOx Perfsonar Application Download Links
## IOX Application:
Application image: 

NOTE: Currently, the IOX application tarfile is not available. Only the build script has been released as described below.

https://devhub.cisco.com/artifactory/webapp/#/artifacts/browse/tree/General/iox-packages/apps/perfsonar/x86/

Content:
* README.md             : This README file

NOTE:
* perfsonar-testpoint.v4.0.2.3.c1.1.0.tar: IOX Application

is currently not provided in the DevHub repo. It must be built by the customer.
Refer to build script below for more information.

Login:
user: root
password: cisco


## IOX Application Build Script Reference:
Github repository:

https://github.com/CiscoIOx/perfsonar

### Package Contents

README.md               : This README file


CISCO_IOX directory:

Dockerfile.iox          : Cisco IOx Dockerfile to build Cisco Perfsonar Docker app  
iox_build.sh            : Cisco IOx Perfsonar Application build script  
ioxclient               : Cisco IOx packaging utility (linux_386)  
                 Refer to https://developer.cisco.com/docs/iox/#!iox-resource-downloads for other platform binaries. 
iox_start.sh            : Cisco IOx modified start-up script for Perfsonar  
iox_supervisord.conf    : Cisco IOx additional supervisord configurations   
output                  : Output directory with the generated Cisco IOx Perfsonar application tarfile  
package.yaml            : Cisco IOx Package definition file for the IOx Perfsonar application  
package_config.ini      : Cisco IOx Package Configuration file used by Cisco DNAC for Application variables
meshconfig-agent.conf   : Perfsonar boot-up configuration file that defines the Central Measurement/Configuration URL IP Address


NOTE: /etc/perfsonar/meshconfig-agent.conf file needs to be manually updated to set "configuration_url" to point to the customer's Central Measurement IP which has the Mesh Agent's configuration file.


For details on Cisco IOx Application Development, refer to:
https://developer.cisco.com/docs/iox/#introduction-to-iox/introduction-to-iox

# Build Environment Used
Docker 17.05 or higher required.   
Built using Ubuntu Trusty docker-ce : Docker version 18.06.1-ce, build e68fc7a  
Linux ODLcntrl 3.19.0-25-generic #26~14.04.1-Ubuntu SMP Fri Jul 24 21:16:20 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux


# Build steps to create Cisco IOx Application based on PerfSONAR github docker image

The latest PerfSONAR github docker github release for V4.0 as of 11/1/2017 was built and verified using this build script.

Refer to PerfSONAR github for the original perfsonar-testpoint-docker source:  
https://hub.docker.com/r/perfsonar/testpoint/

PerfSONAR Release 4.x from RPM:  
http://software.internet2.edu/rpms/el7/x86_64/main/RPMS/perfSONAR-repo-0.8-1.noarch.rpm

For more details on Perfsonar, refer to:  
https://www.perfsonar.net

For more details on Perfsonar Meshconfig, refer to:  
http://docs.perfsonar.net/multi_mesh_autoconfig.html

For more details on Cisco IOx Application development, refer to:  
https://developer.cisco.com/docs/iox/#!introduction-to-iox

## Build Environment Setup
NOTE: Apple MAC users, it is recommended not to use the "native" Mac O/S as the build environment due various missing and incompatible utilities. Please create an x86 Ubuntu VM using VMware Fusion and install docker within the VM.


1. Linux build machine that is docker compliant:
"https://docs.docker.com/install/#server"

2. Docker must be installed. Minimally Community Edition (CE) is required, minimum Docker 17.05:
"https://docs.docker.com/install/#server"

3. Run "ioxclient" packaging tool for the first time to setup at your home directory ".ioxclientcfg.yaml" IOX configuration profile file. 
Since Enterprise IOX does not require this profile, select the given defaults by using <ENTER> for each prompting.  

If using a build platform that is not compatible with the provided linux-386 64bit binary, go to: 

https://developer.cisco.com/docs/iox/#!iox-resource-downloads

to find the required binary that is compatible with the build system. 
Replace the existing "ioxclient" with the required downloaded binary and make sure it is executable.   

```
Sample output:

> cd perfsonar-testpoint/CISCO_IOX
> ./ioxclient
Config file not found :  /home/johntai/.ioxclientcfg.yaml
Creating one time configuration..
Your / your organization's name :
Your / your organization's URL :
Your IOx platform's IP address[127.0.0.1] :
Your IOx platform's port number[8443] :
Authorized user name[root] :
Password for root :
Local repository path on IOx platform[/software/downloads]:
URL Scheme (http/https) [https]:
API Prefix[/iox/api/v2/hosting/]:
Your IOx platform's SSH Port[2222]:
Your RSA key, for signing packages, in PEM format[]:
Your x.509 certificate in PEM format[]:
Activating Profile  default
Saving current configuration
NAME:
   ioxclient - Command line tool to assist in app development for Cisco IOx platforms

USAGE:
   ioxclient [global options] command [command options] [arguments...]

VERSION:
   1.7.5.0

AUTHOR:
  Cisco Systems - <iox-support@cisco.com>
...
<more output not shown>

```


## Build Steps:
1. Build Cisco IOx Application from the built PerfSonar Docker image based on perfsonar-testpoint V4.0.2.3
```
> cd perfsonar-testpoint/CISCO_IOX
> sudo ./iox_build.sh
```

2. The built Cisco IOx PerfSONAR Application image is located at 
"CISCO_IOX/output/perfsonar-testpoint.v4.0.2.3.c1.1.0.tar"


Cisco IOx application installation steps are described below.

NOTE: An alternative github build of the docker source code is provided in the below section "Alternative Cisco IOx Application build steps using the latest PerfSONAR github docker release"


# Installing Cisco IOx PerfSONAR Application
## cat9k IOX USB/HDD Storage Requirement

IOX app-hosting production mode requires either a cat9400 internal HDD or a cat9300/9500 back-panel Cisco certified USB3.0 flash. However if such storage devices are not available, for evaluation purposes only, the front-panel USB2.0 port can support IOX app-hosting in a limited capacity. App-hosting is not supported on bootflash for all cat9ks.

For 16.8 cat9300/9500, App-hosting only works on the external front-panel USB2.0 Flash Drive. 16.9 and future releases support the back-panel USB3.0 Flash Drive port. 

For 16.8 and 16.9, cat9400 has an internal harddisk that supports App-hosting and front-panel USB3.0 Flash Drive is "not" supported. Starting 16.10, 9400 supports the front-panel USB port as well as the internal SATA HDD.

The default "vfat" format of a standard USB flash is not recommended for app-hosting due to performance an incompatibility issues. ext2/ext4 is the most compatible format. 

To reformat the USB flash using IOS CLI commands do the following:

```
conf t>
no iox

Switch#format usbflash0: ext2
Format operation may take a while. Continue? [confirm]
Format operation will destroy all data in "usbflash0:".  Continue? [confirm]
warning: can not unmount /mnt/usb0, try lazy umount

 Format of usbflash0: complete


```


IOx does not auto sense the insertion or removal of the front USB Flash.   
One of the below steps needs to be done after the insertion of a new USB Flash:
1) switch "reload"
Or
2) 
```
conf t>
   no iox

   !!! You may have to wait up to a minute to issue "iox" below
   iox 
end
```

NOTE: Though any USB Flash Drive can correctly operate using the cat9k front-panel USB port, the fastest USB3.0 Flash Drive is recommended since the install and start times for an IOx App directly correlate to the fast performance of the flash drive used.

## Application Installation Steps:

IOx Perfsonar application eth0 interface can either be connected to the Management interface (eg: cat9k GigabitEthernet0/0) or front panel data-ports (eg: GigabitEthernet1/0/1).
Follow the required setup instructions based upon which external interface is chosen.

1. Load Cisco switch/router Polaris 16.11.1 or later image.
2. Apply Switch/Router configurations:
   - Enable IOX and NTP services
     IOS must be configured to provide NTP server sync for "all" Cisco IOx endpoints.


```
// Configurations for NTP servers accessible from the Front Panel Data Ports

conf t>
!!! IOS NTP Setup : points to PerfSonar NTP servers
ntp server owamp.chic.net.internet2.edu prefer
ntp server owamp.hous.net.internet2.edu
ntp server owamp.losa.net.internet2.edu
ntp server owamp.newy.net.internet2.edu
ntp server chronos.es.net
ntp server saturn.es.net

!!! Remote DNS Server config
ip name-server 8.8.8.8



// If Management Interface provides network access to the NTP Servers, the IOS vrf CLIs to setup NTP need to be configured:

conf t>
ntp server vrf Mgmt-vrf owamp.chic.net.internet2.edu prefer 
ntp server vrf Mgmt-vrf owamp.hous.net.internet2.edu 
ntp server vrf Mgmt-vrf owamp.losa.net.internet2.edu 
ntp server vrf Mgmt-vrf owamp.newy.net.internet2.edu 
ntp server vrf Mgmt-vrf chronos.es.net 
ntp server vrf Mgmt-vrf saturn.es.net

!!! Remote DNS Server config
ip name-server vrf Mgmt-vrf 8.8.8.8


end

// Verify NTP Servers are associated:

CAT9K#show ntp associations
 
  address         ref clock       st   when   poll reach  delay  offset   disp
+~10.81.254.202   .GPS.            1     34   1024   377 70.913  -2.662  1.027
+~10.64.58.51     .GPS.            1     87   1024   377 235.90  -2.839  1.078
*~72.163.32.44    .GPS.            1    860   1024   367 41.612  -2.666  1.091

```
   - Enable IOX infrastructure services

```
conf t>
!!! Enable IOx
iox

end

```

You must wait until the IOX infra is ready by checking using the "show app-hosting list" until 
the below output is seen.


```
CAT9K#sh app-hosting list
No App found

```

   - Management Interface configurations (Use "only" if Management port is used for the PerfSonar data port)

Configs requires Management Interface and PerfSonar Interface to be on the same subnet.
```
For the example configs, shared subent is 172.26.200.0/24:
Mgmt-if IP:   172.26.200.131	(Public IP)
Perfsonar IP: 172.26.200.134	(Public IP)
Gateway IP:   172.26.200.1	(Public or Private IP)
DNS IP:       172.19.198.82
```

```
conf t>
!!! Management Interface
interface GigabitEthernet0/0
 vrf forwarding Mgmt-vrf
 ip address 172.26.200.131 255.255.255.0
 speed 1000
 negotiation auto

!
!!! IOx PerfSONAR App configs
app-hosting appid perfsonar
 app-vnic management guest-interface 0
  guest-ipaddress 172.26.200.134 netmask 255.255.255.0
 app-default-gateway 172.26.200.1 guest-interface 0
 name-server0 172.19.198.82

end

```


   - Front Data Panel data-port interface configurations (Use "only" if front data-port is used for the PerfSonar data port)

Configs are based on L2 switching from a front-panel data-port interface to the PerfSonar interface.
Only the Perfsonar App requires a routable "public" address which the perfonsar peers can reach.
PerfSonar eth0 connects to the cat9k's AppGigabitEthernet port which is trunked to a front-panel data-port vlan.

```
For the example configs:
Data-Port VLAN: 10 		
Perfsonar IP: 30.30.30.10   	(Public IP)
App-vlan:     10
Gateway IP:   30.30.30.1        (external gateway's IP)
AppGigabitEthernet port mode: trunk
DNS IP:       172.19.198.82
```

```
conf t>
!!! Data Port Interface Access Vlan 10
interface GigabitEthernet1/0/1
 switchport access vlan 10
 switchport mode access

!
!!! AppGigabitEthernet Port Trunk Mode
!!! NOTE: AppGigabitEthernet port number will vary depending upon cat9k model
interface AppGigabitEthernet3/0/41
 switchport mode trunk

!
!!! IOx PerfSONAR App AppGigabitEthernet configs
app-hosting appid perfsonar
    app-vnic AppGigabitEthernet vlan-access
      vlan 10 guest-interface 0
        guest-ipaddress 30.30.30.10 netmask 255.255.255.0
    app-default-gateway 30.30.30.1 guest-interface 0
    name-server0 172.19.198.82
   
end

```


3. Install and Start App via IOS exec commands which "must" be followed in the given order:
   -  app-hosting install appid perfsonar package flash:perfsonar-testpoint.v4.0.2.3.c1.1.0.tar

   -  app-hosting activate appid perfsonar

   -  app-hosting start appid perfsonar

      NOTE: the above commands might take several minutes to complete depending upon various factors:

      - Speed of the USB Flash Disk

      - Switch/Router activity load

      - Boot-up time of the application

4. Check Application Status

   - show app-hosting list
     * This command shows the application operational state.

5. Check Application Resources

   - show app-hosting detail appid <APPID-NAME>
     * This command shows the resources allocated to the given appid.
       The PerfSONAR resources such as system memory, vcpus, cpu resources, etc are shown below.


_Example:_

```
AppHosting#app-hosting install appid perfsonar package flash:perfsonar-testpoint.v4.0.2.3.c1.1.0.tar
perfsonar installed successfully
Current state is: DEPLOYED
  
AppHosting#app-hosting activate appid perfsonar
perfsonar activated successfully
Current state is: ACTIVATED
  
AppHosting#app-hosting start appid perfsonar
perfsonar started successfully
Current state is: RUNNING


AppHosting#show app-hosting list
App id                           State
------------------------------------------------------
perfsonar                        RUNNING


AppHosting#show app-hosting detail appid perfsonar
App id                 : perfsonar
Owner                  : iox
State                  : RUNNING
Application
  Type                 : docker
  Name                 : perfsonar
  Version              : 1.1.0
  Description          : Cisco IOx PerfSONAR Application
  Path                 : usbflash1:perfsonar-testpoint.v4.1.c1.1.0-docker.tar
Activated profile name : custom

Resource reservation
  Memory               : 2048 MB
  Disk                 : 1 MB
  CPU                  : 4000 units

Attached devices
  Type              Name               Alias
  ---------------------------------------------
  serial/shell     iox_console_shell   serial0
  serial/aux       iox_console_aux     serial1
  serial/syslog    iox_syslog          serial2
  serial/trace     iox_trace           serial3

Network interfaces
   ---------------------------------------
eth0:
   MAC address         : 52:54:dd:1c:b4:96
   IPv4 address        : 172.25.101.163

```


6. To Connect to IOx PerfSonar console: (login/password: root/cisco)
```
> app-hosting connect appid perfsonar console
```

NOTE: to exit Perfsonar's console mode, use "^c^c^c".

Output Example:_

```
CAT9K#app-hosting connect appid perfsonar console
Connected to appliance. Exit using ^c^c^c

CentOS Linux 7 (Core)
Kernel 4.4.86 on an x86_64

CAT9K_1_RP_0 login: root
Password: cisco
Last login: Tue Oct 31 23:29:44 on ttyS0
[root@CAT9K_1_RP_0 ~]#

```


7. To Delete a Running App, the following sequence order must be followed:
   - app-hosting stop appid <MY-APP>      
     * App in "shutdown" state, but cpu/memory/disk resources still allocated and rootfs files and changes remain persistent
   - app-hosting deactivate appid <MY-APP>    
     * App removed with cpu/memory/disk resources all released, but rootfs files and changes remain persistent
   - app-hosting uninstall appid <MY-APP>     
     * App completely removed from IOx and all rootfs files and changes are lost




# PerfSONAR Agent Specific Configuration Files

There are PerfSonar Agent-specific configuration files that can be automatically uploaded into the IOx PerfSonar during application boot-up either via Cisco DNAC or Cisco Local Manager (LM). A user can provide a preconfigured agent customized configuration file that is used during the IOx "start" operation when the PerfSonar agent is booting up.

Available application specific configuration methods:
1. App package_config.ini Update "before" building the app
2. App-hosting File Uploading
3. Local Manager File Uploading
4. Manually edit the packaged meshconfig-agent.conf template.


Methods 1 and 2 only support configuring meshconfig-agent.conf.
If other configuration files need to be updated, use Methods 3 or 4.

## Config Option 1: App package_config.ini Update
package_config.ini is used by Cisco DNAC to allow an administrator to override the provided app's settings. If Cisco DNAC is not available, then the below manual technique can be used.

This method only supports meshconfig-agent.conf changes.

Before running iox_build.sh, do:
1. Edit the provided CISCO_IOX/package_config.ini file line:  

   MESHCONFIG_AGENT_CONFIGURATION_URL_IP_ADDRESS = 172.27.115.131   

Change the default IP address "172.27.115.131" to the required Meshconfig Agent Configuration URL IP Address.

2. start the IOx build script "iox_build.sh"

## Config Option 2: App-hosting File Uploading
This method only allows the packaged meshconfig-agent.conf to be updated by a user provided package_config.ini which is performed by an app-hosting exec cli.

An application's package_config.ini file is distributed in two ways:
1. A package_config.ini file is separately provided with the IOx Application tarfile.
2. package_config.ini file is packaged into the the IOx Application tarfile.  
For the prepackaged package_config.ini file, the file is extracted by untaring the App's tarfile:

* tar -xvf perfsonar-testpoint.v4.0.2.3.c1.1.0.tar 


Steps:
1. Edit the app's package_config.ini entries to the platform specific settings.
2. Upload the modified package_config.ini to the target platform using the same IOS file copy method used to upload the application tarfile.
3. Start the application using the following sequence:
   -  app-hosting install appid perfsonar package flash:perfsonar-testpoint.v4.0.2.3.c1.1.0.tar

   -  app-hosting activate appid perfsonar

   -  app-hosting settings appid perfsonar file flash:perfsonar-config.ini   
      NOTE: "settings" needs to be done "after" activate step and "before" start.

   -  app-hosting start appid perfsonar

## Config Option 3: LM (Local Manager) File Uploading
The following PerfSonar Agent-specific config files are supported using LM File Uploading:

* meshconfig-agent.conf	  
  - already provided in current version of IOX Perfsonar app in /etc/perfsonar/meshconfig-agent.conf which will be overwritten if user provided.
* meshconfig-agent-tasks.conf
* lsregistrationdaemon.conf

These files are uploaded before starting the PerfSonar application.
If the PerfSonar application is already started, the uploaded files will not take effect until the Perfsonar app is restarted (stop then start).


## WebUI Local Manager (LM) Technique of File Uploading
Enable IOS HTTP services which are required for LM support:

```
conf t>
!!! example user login with required level 15 access
username cisco privilege 15 password 0 cisco  
!
ip http server
ip http authentication local
ip http secure-server
end
```

Administrator login must have level "15" access as shown above in the example configuration.   
"http" requires "ip http server" to be configured.   
"https" requires "ip http secure-server" to be configured.   


Cisco WebUI supports Local Manager (LM) File Uploading. This is done by:

1. From browser "https://SWITCH-IP" which is typically the Management-IP (eg: https://172.19.198.82/)   
   EFT image use "https://SWITCH-IP/iox/login"
   Approve the "invalid" security certificate.
2. Login using the supported switch "username"/password
3. Click "Configuration->IOx"
4. Login using the same supported switch "username"/password
5. Click "Applications" tab, select Application box and "Manage" button
6. Click "App-DataDir" and select "Upload" button to specify File Uploading to given Application
7. Click "Choose File" and select file to upload and "OK" to start the file uploading
8. Start the IOx application via "app-hosting start appid APP-NAME".  
   Uploaded configuration files are only read when PerfSonar during "start" bootup.
   If app is already started, you must "stop" then "start" for the config files to take effect.

## Config Option 4: Manual Editting
NOTE: A basic /etc/perfsonar/meshconfig-agent.conf file is already provided which needs to be manually updated to set "configuration_url" to point to the customer's Central Measurement IP. This is done by:
1. Login to a running perfsonar app via "app-hosting connect appid perfsonar console", login: root password: cisco
2. Edit file via   
"vi /etc/perfsonar/meshconfig-agent.conf"    
and updating "configuration_url" to point to the customer's Central Measurement IP.
3. Edit IOx Startup script file via   
"vi /etc/init.d/iox_start.sh"    
and change the Env-Var below to FALSE to disable package_config.ini processing   
   
ENABLE_PACKAGE_CONFIG="FALSE"

4. Edit other required perfonsar configuration files.
5. Exit app via three Ctrl-C's.
6. Restart the app by "app-hosting stop appid perfsonar" and "app-hosting start appid perfsonar".

The new configured meshconfig-agent.conf will attempt to download a meshconfig-agent-tasks.conf from the Central Measurement IP.



# Alternative Cisco IOx Application build steps using the latest PerfSONAR github docker release
These steps assume the files CISCO_IOX/Dockerfile.iox modifies are still compatible.  

NOTE: This git based build step is for reference only. The IOX Dockerfile.iox only works for Perfsonar v4.0 and does not work with any later versions starting from V4.1 and up.
If a github build is required using V4.1+, since bwctl has been removed with these newer release, comment out the below RUN cmd in Dockerfile.iox:  

   
RUN sed -i -e "s/\#allow_unsync/allow_unsync/" /etc/bwctl-server/bwctl-server.conf

  
This change will allow the IOX App to be built, however, perfsonar functionality has "not" been verified.

## Build Steps:
1. Clone latest PerfSONAR github docker release
```
> git clone https://github.com/perfsonar/perfsonar-testpoint-docker.git
> git checkout tags/4.0.2.3
```

2. Copy "CISCO_IOX" directory contents into the PerfSONAR directory
```
> cp -r /<CISCO_IOX_PERFSONAR_DIR>/CISCO_IOX /<HOME-DIR>/perfsonar-testpoint-docker/
```

3. In "/perfsonar-testpoint-docker" directory, build unmodified PerfSONAR github docker image
```
> cd /<HOME-DIR>/perfsonar-testpoint-docker/
> sudo make build 
```

4. Build Cisco IOx Application from the built PerfSonar Docker image
```
> cd CISCO_IOX
> sudo ./iox_build.sh
```

5. Cisco IOx PerfSONAR Application image is located at "CISCO_IOX/output/perfsonar-testpoint.v4.0.2.3.c1.1.0.tar"

