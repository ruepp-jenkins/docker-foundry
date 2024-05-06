#!/bin/bash

# initialize trap to forceful stop the bot
trap terminator SIGHUP SIGINT SIGQUIT SIGTERM
function terminator() {
  echo
  echo "Stopping Syncovery $child..."
  kill -TERM "$child" 2>/dev/null
  stop
  echo "Exiting."
}

function stop() {
  kill $child
}

function start() {
  echo "OS Date: $(date)"
  echo "Steam APP ID: ${STEAM_GAMESERVERID}"
  echo "Steam additional update args: ${STEAM_ADDITIONAL_UPDATE_ARGS}"
  echo "Steam launch command: ${GAMESERVER_CMD}"
  echo "Steam serverfiles path: ${GAMESERVER_FILES}"

  if [ ! -f ${GAMESERVER_FILES}/App.cfg ]; then
    echo "Configuration file missing, creating default file."
    echo "Adjust this file to your needs and start the container again"
    cp /docker/App.cfg ${GAMESERVER_FILES}
    exit 1
  fi

  echo "Starting wine environment"
  Xvfb :0 -screen 0 640x480x24:32 &

  echo "Launching gameserver"
  DISPLAY=:0.0 wine ${GAMESERVER_FILES}/FoundryDedicatedServer.exe -log > ${GAMESERVER_FILES}/server.log
}

start
tail -f ${GAMESERVER_FILES}/server.log &

child=$!
wait "$child"
