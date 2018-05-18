#!/bin/bash

# Minetest initd looper script
# Calls the minetest server in a loop as long as $MINETEST_LOOPFILE exists.

source ./conf.sh

# pseudo-do-while-loop
# https://stackoverflow.com/questions/16489809/emulating-a-do-while-loop-in-bash
while 
	# start process as background first to get its pid, then wait for it to exit.
    $MINETEST_CMDLINE >/dev/null 2>/dev/null &
    echo $! > $MINETEST_PIDFILE
    wait $!
    # When process ended, delete PID file
    echo "[looper] Minetest Server $MINETEST_SERVICENAME exited with $?"
    rm $MINETEST_PIDFILE
    
    [ -e $MINETEST_LOOPFILE ]
do
	# wait 1sec before restarting the server
	# (executed everytime after first run)
	echo "[looper] Minetest Server $MINETEST_SERVICENAME is being restarted..."
    sleep 1
done
echo "[looper] Exiting."
