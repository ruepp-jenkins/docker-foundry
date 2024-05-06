#!/bin/bash
export serverpid=0

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
  kill $serverpid
}

function start() {
  echo "OS Date: $(date)"
  echo "Steam APP ID: ${STEAM_GAMESERVERID}"
  echo "Steam additional update args: ${STEAM_ADDITIONAL_UPDATE_ARGS}"
  echo "Steam launch command: ${GAMESERVER_CMD}"
  echo "Steam serverfiles path: ${GAMESERVER_FILES}"

  if [ ! -f ${GAMESERVER_FILES}/App.cfg ]; then
    echo "Configuration file missing, creating default file."
    echo "Adjust this file to your needs and start the container again. See:"
    echo "https://dedicated.foundry-game.com/"
    cp /docker/App.cfg ${GAMESERVER_FILES}
    exit 1
  fi

  echo "Install/update gaming files"
  /usr/games/steamcmd +force_install_dir "${GAMESERVER_FILES}" +login anonymous +@sSteamCmdForcePlatformType windows +app_update ${STEAM_GAMESERVERID} ${GAMESERVER_CMD} validate +quit

  echo "Launching gameserver"
  xvfb-run wine ${GAMESERVER_FILES}/FoundryDedicatedServer.exe -log > ${GAMESERVER_FILES}/server.log &
  serverpid=$!
}

start
tail -f ${GAMESERVER_FILES}/server.log &

child=$!
wait "$child"
