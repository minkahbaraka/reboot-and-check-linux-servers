﻿# reboot-and-check-linux-servers
 
 Please note that for this script to work, the user running the script has to have ssh keys set up on the remote servers that the script runs against.

This is is a bash script that uses a little bit of awk to read in server names from a file (servers.cfg), and peforms a reboot on each server and check for services after the server is back online. The script is generic enough and explained enough (I hope) that it can be easily modified or repurposed.

The script itself has four (4) functions that work together. 

The first function (getenv) accepts input from the command line. The input is assigned to an evironment variable (defined as staging or prod). The getenv function passes the environment variable to the second function (setenv).

The second function (setenv), receives the environment variable and passes it to another function (passenv). The passenv function in turn passes the environment and a conditional list of servers to the final function (reboot-env).

The reboot-env function then performs actions against a list of servers passed in by environment and awk, which parses the server.cfg file.
