#! /bin/bash 
#
# DISCLAIMER: This build script is intended for demonstration purposes only and is provided as-is with
# no warranty or support of any kind. Running the build script may result in third party software components
# being downloaded and installed on your system. It is your responsibility to ensure that you have all the
# necessary rights and permissions to use any such third party software. Cisco Systems, Inc., makes no representation
# about and assumes no liability for any such third party software, including with regard to intellectual property
# rights, licensing, malware, security, quality, functionality, suitability, and performance.
# All use of the build script and any third party software is at your own risk.

# Create a clean build "output" directory
if [ ! -d output ]; then
	mkdir -p output
else
	rm -f output/*
fi

# Build the Cisco IOx version of perfsonar docker
sudo docker build -f Dockerfile.iox_lxc -t perfsonar-testpoint.v4.0.iox .

# Copy IOx PerfSonar package.yaml to build "output" directory
cp package.yaml output

# Use ioxclient tool to "package" IOx application tarfile based on "docker" image "perfsonar-testpoint.v4.0.iox".
# Extend rootfs diskspace using "headroom" option in MB.
# Create Cisco IOx application tarfile specified by "name".
#
# Help:
# ioxclient -h
# ioxclient package -h
#
# "ioxclient" is a linux x386 32-bit executable that is conveniently provided in this build.
# To get the latest ioxclient tool, refer to https://developer.cisco.com/docs/iox/#downloads/downloads
#
# For more details on Cisco IOx Application development, refer to:
# https://developer.cisco.com/site/iox/docs/#sdk-introduction

sudo ./ioxclient docker package --headroom 1500  --name perfsonar-testpoint.v4.0.c1.0.0.tar perfsonar-testpoint.v4.0.iox output
