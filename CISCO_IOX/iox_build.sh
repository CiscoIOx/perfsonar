#! /bin/bash 
#
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
#
# For IOX Application Development details, refer to:
# https://developer.cisco.com/docs/iox/#!introduction-to-iox

### ENVIRONMENT VARIABLES
# Perfsonar Version Tag to pull from 
# https://hub.docker.com/r/perfsonar/testpoint/tags/
APP_VERSION=4.0.2.3

# Cisco Revision History
# 1.1.0: 12/2018 Updates:
#        * New build script to handle Docker and IOX packaging changes below
#        * Support for perfsonar docker tags
#        * Support for perfsonar meshconfig-agent.conf pre-installed in the 
#          perfsonar app that requires 
#          "configuration_url" IP update.
#        * Support for Cisco DNAC/Fog Director package.yaml attributes 
#          requiring descriptor-schema-version 2.9
#        * Support for Cisco DNAC/Fog Director Application package_config.ini 
#          configuration variables 
#        * Latest ioxclient 1.7.5.0 required for the latest schema support 
#          included
# 1.0.0: 2/2018: Initial Release
CISCO_REVISION=1.1.0

# Image Names
IOX_DOCKER_IMAGE=perfsonar-testpoint.v$APP_VERSION.iox
IOX_APP=perfsonar-testpoint.v$APP_VERSION.c$CISCO_REVISION.tar

### IOX APP BUILD STEPS
# Create a clean build "output" directory
if [ ! -d output ]; then
	mkdir -p output
else
	rm -f output/*
fi

# Build the Cisco IOx version of perfsonar docker
echo "***" docker build --build-arg TAG=$APP_VERSION -f Dockerfile.iox -t $IOX_DOCKER_IMAGE .
sudo docker build --build-arg TAG=$APP_VERSION -f Dockerfile.iox -t $IOX_DOCKER_IMAGE .

# Copy IOx package.yaml and package_config.ini to build "output" directory
cp package.yaml output
cp package_config.ini output

# Use ioxclient tool to "package" IOx application tarfile based on "docker" 
# image IOX_DOCKER_IMAGE.
# Extend rootfs diskspace using "headroom" option in MB.
# Create Cisco IOx application tarfile specified by "name".
#
# Help:
# ioxclient -h
# ioxclient package -h
#
# "ioxclient" is a linux x86 64-bit executable that is conveniently provided 
# in this build.
# To get the latest ioxclient tool, refer to:
# https://developer.cisco.com/docs/iox/#downloads/downloads
#
# For more details on Cisco IOx Application development, refer to:
# https://developer.cisco.com/docs/iox/#!introduction-to-iox

sudo ./ioxclient docker package --name $IOX_APP $IOX_DOCKER_IMAGE output
