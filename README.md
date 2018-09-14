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

# Cisco IOx Perfsonar LXC Application
This Cisco IOx Perfsonar application is an LXC app based on the Internet2 docker perfsonar-testpoint image. It is an IOx reference application, highlighting how a standard docker image is repackaged into a Cisco IOx application.

# Cisco IOx Perfsonar LXC Application Download Links
## IOX LXC Application:
Application image:

https://devhub.cisco.com/artifactory/webapp/#/artifacts/browse/tree/General/iox-packages/apps/perfsonar/x86/

Content:
* README.md             : This README file

NOTE:
* perfsonar-testpoint.v4.0.c1.0.0.tar: IOX LXC Application

is currently not provided in the DevHub repo. It must be built by the customer.
Refer to build script below for more information.

Login:
user: root
password: cisco


## IOX LXC Application Build Script Reference:
Github repository:

https://github.com/CiscoIOx/perfsonar

### Package Contents

README.md               : This README file


CISCO_IOX directory:

Dockerfile.iox_lxc      : Cisco IOx Dockerfile to build Cisco Perfsonar Docker app  
iox_build.sh            : Cisco IOx Perfsonar Application build script  
ioxclient               : Cisco IOx packaging utility (linux_386).  
         Refer to https://developer.cisco.com/docs/iox/#downloads for other platform binaries. 
iox_start.sh            : Cisco IOx modified start-up script for Perfsonar  
iox_supervisord.conf    : Cisco IOx additional supervisord configurations   
output                  : Output directory with the generated Cisco IOx Perfsonar application tarfile  
package.yaml            : Cisco IOx Package definition file for the IOx Perfsonar application  


For details on Cisco IOx Application Development, refer to:
https://developer.cisco.com/docs/iox/#introduction-to-iox/introduction-to-iox


# Build steps to create Cisco IOx LXC Application based on PerfSONAR github docker image

The latest PerfSONAR github docker github release as of 11/1/2017 was built and verified using this build script.

Refer to PerfSONAR github for the original perfsonar-testpoint-docker source:  
https://hub.docker.com/r/perfsonar/testpoint/

PerfSONAR Release 4.x from RPM:  
http://software.internet2.edu/rpms/el7/x86_64/main/RPMS/perfSONAR-repo-0.8-1.noarch.rpm

For more details on Perfsonar, refer to:  
https://www.perfsonar.net

For imore details on Perfsonar MeshConfig, refer to:  
http://docs.perfsonar.net/multi_mesh_autoconfig.html

For more details on Cisco IOx Application development, refer to:  
https://developer.cisco.com/docs/iox/#introduction-to-iox/introduction-to-iox

## Build Environment Setup
NOTE: Apple MAC users, it is recommended not to use the "native" Mac O/S as the build environment due various missing and incompatible utilities. Please create an x86 Ubuntu VM using VMware Fusion and install docker within the VM.


1. Linux build machine that is docker compliant:
"https://docs.docker.com/install/#server"

2. Docker must be installed. Minimally Community Edition (CE) is required:
"https://docs.docker.com/install/#server"

3. Run "ioxclient" packaging tool for the first time to setup at your home directory ".ioxclientcfg.yaml" IOX 
configuration profile file. 
Since Enterprise IOX does not require this profile, select the given defaults by using <ENTER> for each prompting.  

If using a build platform that is not compatible with the provided linux-386 32bit binary, go to  

https://developer.cisco.com/docs/iox/#downloads   

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
   1.5.0.0

AUTHOR:
  Cisco Systems - <iox-support@cisco.com>
...
<more output not shown>

```


## Build Steps:
1. Build Cisco IOx LXC Application from the built PerfSonar Docker image
```
> cd perfsonar-testpoint/CISCO_IOX
> sudo ./iox_build.sh
```

2. The built Cisco IOx PerfSONAR LXC Application image is located at 
"CISCO_IOX/output/perfsonar-testpoint.v4.0.c1.0.0.tar"


Cisco IOx application installation steps are described below.


# Alternative Cisco IOx LXC Application build steps using the latest PerfSONAR github docker release
These steps assume the files CISCO_IOX/Dockerfile.iox_lxc modifies are still compatible.

## Build Steps:
1. Clone latest PerfSONAR github docker release
```
> git clone https://github.com/perfsonar/perfsonar-testpoint-docker.git
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

4. Build Cisco IOx LXC Application from the built PerfSonar Docker image
```
> cd CISCO_IOX
> sudo ./iox_build.sh
```

5. Cisco IOx PerfSONAR LXC Application image is located at "CISCO_IOX/output/perfsonar-testpoint.v4.0.c1.0.0.tar"


# Installing Cisco IOx PerfSONAR Application
## cat9k USB 3.0 Flash Drive Front Panel Requirement

Before app-hosting can be enabled on cat9k, a USB3.0 Flash Drive must be installed in the cat9k front-panel USB port. App-hosting only works on the external USB Flash Drive for 16.8 release and will "not" install on bootflash. 16.9 will support the back-panel USB3.0 Flash Drive port. 

cat9400 has an internal harddisk that supports App-hosting and front-panel USB3.0 Flash Drive is "not" supported for 16.8 and 16.9. Starting 16.10, 9400 supports the front-panel USB port as well as the internal SATA HDD.

The default "vfat" format of a standard USB flash is not recommended for app-hosting. ext2/ext4 is the most compatible format. 

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

IOx Perfsonar application eth0 i/f can either be connected to the Management i/f (eg: cat9k GigabitEthernet0/0) or front panel data-ports (eg: GigabitEthernet1/0/1).
Follow the required setup instructions based upon which external interface is chosen.

1. Load Cisco switch/router Polaris 16.8.1 or later image.
2. Switch/Router configurations:
   - Enable IOX and NTP services
IOS must provide NTP server sync for "all" IOx endpoints.


```
// Configurations for NTP servers connected to Front Panel Data Ports

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



// If Management I/F is connected to the NTP Servers, the IOS vrf CLIs to setup NTP need to be configured:

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

   - Management I/F configurations (Use "only" if Management port is used for the PerfSonar data port)

Configs requires Management I/F and PerfSonar I/F to be on the same subnet.
```
For the example configs, shared subent is 172.26.200.0/24:
Mgmt-if IP:   172.26.200.131	(Public IP)
Perfsonar IP: 172.26.200.134	(Public IP)
Gateway IP:   172.26.200.1	(Public or Private IP)
DNS IP:       172.19.198.82
```

```
conf t>
!!! Management I/F
interface GigabitEthernet0/0
 vrf forwarding Mgmt-vrf
 ip address 172.26.200.131 255.255.255.0
 speed 1000
 negotiation auto

!
!!! IOx PerfSONAR App configs
app-hosting appid perflxc
 vnic management guest-interface 0 guest-ipaddress 172.26.200.134 netmask 255.255.255.0 gateway 172.26.200.1 name-server 172.19.198.82 default
 
end

```


   - Front Data Panel data-port I/F configurations (Use "only" if front data-port is used for the PerfSonar data port)

Configs requires data-port I/F and PerfSonar I/F to be on the different, routable "public" subnets.
PerfSonar eth0 connects to a Virtual Port Group (VPG) subnet which is routed to a front panel data-port.
For 16.8, only L3 routable front-panel data port mode is supported for container connections via VPG. No L2 switching features are supported for the VPG in 16.8. 

```
For the example configs:
Data-Port IP: 201.201.201.1 	(Public or Private IP)
VPG IP:     : 30.30.30.1    	(Public IP)
Perfsonar IP: 30.30.30.10   	(Public IP)
Gateway IP:   201.201.201.10    (Public or Private IP)
DNS IP:       172.19.198.82
```

```
conf t>
!!! Data Port I/F must be L3 mode
!
!!! Must enable ip routing for L3 Data Ports 
ip routing
!
interface GigabitEthernet1/0/1
 no switchport
 ip address 201.201.201.1 255.255.255.0
 speed 1000

!
!!! Virtual Port Group (VPG) configs
interface VirtualPortGroup0
 ip address 30.30.30.1 255.255.255.0

!
!!! IOx PerfSONAR App configs
app-hosting appid perflxc
 vnic gateway1 virtualportgroup 0 guest-interface 0 guest-ipaddress 30.30.30.10 netmask 255.255.255.0 gateway 30.30.30.1 name-server 172.19.198.82 default
   
end

```

3. CPP policer "must" be disabled for best RX through-put. Default policer limits Container RX to 100 pps.

```
conf t>
policy-map system-cpp-policy
 class system-cpp-police-sys-data
 no police rate 100 pps
end


// show CPP Policer Drops and to check if policer is enabled

CAT9K#show platform hardware fed switch active qos queue stats internal cpu policer

                         CPU Queue Statistics
============================================================================================
                                              (default) (set)     Queue        Queue
QId PlcIdx  Queue Name                Enabled   Rate     Rate      Drop(Bytes)  Drop(Frames)
--------------------------------------------------------------------------------------------
0    11     DOT1X Auth                  Yes     1000      1000     0            0
1    1      L2 Control                  Yes     2000      400      0            0
2    14     Forus traffic               Yes     4000      1000     0            0
3    0      ICMP GEN                    Yes     600       200      0            0
...
23   10     Crypto Control              No      100       200      0            0    <<< "No" indicates policer is disabled.
...


```


4. Install and Start App via IOS exec commands which "must" be followed in the given order:
   -  app-hosting install appid perflxc package flash:perfsonar-testpoint.v4.0.c1.0.0.tar

   -  app-hosting activate appid perflxc

   -  app-hosting start appid perflxc

      NOTE: the above commands might take several minutes to complete depending upon various factors:

      - Speed of the USB Flash Disk

      - Switch/Router activity load

      - Boot-up time of the application

5. Check Application Status

   - show app-hosting list
     * This command shows the application operational state.

6. Check Application Resources

   - show app-hosting detail appid \<APPID-NAME\>
     * This command shows the resources allocated to the given appid.
       The PerfSONAR LXC resources such as system memory, vcpus, cpu resources, etc are shown below.


_Example:_

```
AppHosting#app-hosting install appid perflxc package flash:perfsonar-testpoint.v4.0.c1.0.0.tar
perflxc installed successfully
Current state is: DEPLOYED
  
AppHosting#app-hosting activate appid perflxc
perflxc activated successfully
Current state is: ACTIVATED
  
AppHosting#app-hosting start appid perflxc
perflxc started successfully
Current state is: RUNNING


AppHosting#show app-hosting list
App id                           State
------------------------------------------------------
perflxc                          RUNNING


AppHosting#show app-hosting detail appid perflxc
State                  : RUNNING
Author                 : Cisco
Application
  Type                 : lxc
  App id               : perflxc
  Name                 : perfsonar-lxc
  Version              : 1.0.0
Activated profile name : custom
  Description          : PerfSONAR 4.0 Cisco IOx LXC
Resource reservation
  Memory               : 2048 MB
  Disk                 : 10 MB
  CPU                  : 7400 units
  VCPU                 : 2
Attached devices
  Type              Name        Alias
  ---------------------------------------------
  Serial/shell
  Serial/aux
  Serial/Syslog                 serial2
  Serial/Trace                  serial3

Network interfaces
   ---------------------------------------
eth0:
   MAC address         : 52:54:dd:be:a5:7f
   IPv4 address        : 172.19.198.83


```


7. To Connect to IOx PerfSonar console: (login/password: root/cisco)
```
> app-hosting connect appid perflxc console
```

NOTE: to exit Perfsonar's console mode, use "^c^c^c".

Output Example:_

```
CAT9K#app-hosting connect appid perflxc console
Connected to appliance. Exit using ^c^c^c

CentOS Linux 7 (Core)
Kernel 4.4.86 on an x86_64

CAT9K_1_RP_0 login: root
Password: cisco
Last login: Tue Oct 31 23:29:44 on ttyS0
[root@CAT9K_1_RP_0 ~]#

```


8. To Delete a Running App, the following sequence order must be followed:
   - app-hosting stop appid <MY-APP>      
     * App in "shutdown" state, but cpu/memory/disk resources still allocated and rootfs files and changes remain persistent
   - app-hosting deactivate appid <MY-APP>    
     * App removed with cpu/memory/disk resources all released, but rootfs files and changes remain persistent
   - app-hosting uninstall appid <MY-APP>     
     * App completely removed from IOx and all rootfs files and changes are lost




# Agent Specific PerfSONAR configuration files via File Uploading

There are PerfSonar Agent-specific configuration files that can be automatically uploaded into the IOx PerfSonar LXC during application boot-up either manually or via Cisco Local Manager (LM). A user can provide a preconfigured agent customized configuration file that is used during the IOx LXC "start" operation when the PerfSonar agent is booting up.

The following PerfSonar Agent-specific config files are supported using File Uploading:

* meshconfig-agent.conf
* meshconfig-agent-tasks.conf
* lsregistrationdaemon.conf

These files are uploaded before starting the PerfSonar application.
If the PerfSonar application is already started, the uploaded files will not take effect until the Perfsonar app is restarted (stop then start).

# Manual Technique of File Uploading
NOTE: This manual technique requires access to the switch/router System Shell. Contact your System Admin for details.


Copy the Agent specific config file to the below LXC App destination. "perflxc" name will change based upon the given "appid" name used.

LM uploading directory (substitute "APPID-NAME" with the appid "name" used):  /mnt/sd3/iox/repo-lxc/lxc-data/"APPID-NAME"/appdata/

If USB SSD is used, use "/mnt/usb0" instead of the bootflash "/mnt/sd3" mount point above.

_Example:_

// enter System Shell (Contact System Admin for details):
```
> cp /bootflash/meshconfig-agent.conf.FIX /mnt/usb0/iox/repo-lxc/lxc-data/perflxc/appdata/meshconfig-agent.conf
```

// IOS start app
```
> app-hosting start appid perflxc
```


# WebUI Local Manager (LM) Technique of File Uploading
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


