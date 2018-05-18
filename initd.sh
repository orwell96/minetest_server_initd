#!/bin/bash
# Minetest server initd script
# To be run from a init.d service unit setuidgid'ed as the user the server should run as
# This script will make sure that the minetest server restarts when it crashes, but exits when either the service is stopped or /shutdown (from initd minetest mod) is invoked

# from https://stackoverflow.com/questions/3349105/how-to-set-current-working-directory-to-the-directory-of-the-script
cd "${0%/*}"
source ./conf.sh

case "$1" in
  start)
	#just start the looper
	echo -n "Starting Minetest server: $MINETEST_SERVICENAME..."
	if [ -e $MINETEST_PIDFILE ] ; then
		echo "Failed: server already running!"
	else
		./looper.sh &
		echo "Done"
	fi
	;;
  stop)
	echo -n "Stopping Minetest server: $MINETEST_SERVICENAME..."
	if [ -e $MINETEST_PIDFILE ] ; then
		rm $MINETEST_LOOPFILE
		pid=$(cat "$MINETEST_PIDFILE")
		if [ -e /proc/$pid -a /proc/$pid/exe ]; then
			kill $pid
			echo "Done"
		else
			echo "Warning! Server wasn't running but PID file existed!"
			rm $MINETEST_PIDFILE
		fi
	else
		echo "Failed, server not running!"
	fi
	;;
  reload|restart|force-reload)
  	$0 stop
	sleep 1
	$0 start
	;;
  status)
	if [ -e $MINETEST_PIDFILE ] ; then
		pid=$(cat "$MINETEST_PIDFILE")
		if [ -e /proc/$pid -a /proc/$pid/exe ]; then
			echo "OK, server is running!"
			exit 0
		else
			echo "Failed, server not running (pid file exists anyway!)"
			rm $MINETEST_PIDFILE
			rm $MINETEST_LOOPFILE
			exit 1
		fi
	else
		echo "Failed, server not running!"
		rm $MINETEST_LOOPFILE
		exit 1
	fi
	;;
  *)
	N=/etc/init.d/$NAME
	echo "Usage: $N {start|stop|restart|force-reload|reload|status}" >&2
	exit 1
	;;
esac
