#!/bin/bash

# Service name, used for log messages
export MINETEST_SERVICENAME="minetest"

# The directory these scripts are executed from should be
# the repository directory.

# Minetest commandline
export MINETEST_CMDLINE="../minetest/bin/minetestserver --worldname world --config ../server.conf"

# File to write the PID of the server to
# This will be read by the initd.sh to shut down the server when necessary
export MINETEST_PIDFILE="./minetest.pid"

# When this file exists, the server will restart when it shuts down
# This file must be located in the world directory and
# match the minetest 'initd_loop_file' configuration option,
# because it is created by the initd mod after the server has successfully started up
export MINETEST_LOOPFILE="../minetest/worlds/world/minetest.loop"


