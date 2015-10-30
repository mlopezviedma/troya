#!/bin/bash

IF=$(ifconfig | grep -v "^ " | grep -v "^$" | cut -d: -f1 | grep "^e")
echo "Interface=$IF" >> /etc/netctl/wired
netctl stop-all
netctl start wired
