#!/bin/bash
echo "OS Date: $(date)"
echo "Steam APP ID: ${STEAM_GAMESERVERID}"
echo "Steam additional update args: ${STEAM_ADDITIONAL_UPDATE_ARGS}"
echo "Steam launch command: ${GAMESERVER_CMD}"
echo "Foundry save folder: ${FOUNDRY_SAVE}"

if [ ! -f /server/app.cfg ]; then
  echo "Configuration file missing, creating default file."
  echo "Adjust this file to your needs and start the container again. See:"
  echo "https://dedicated.foundry-game.com/"
  cp /docker/default_app.cfg /server/app.cfg
  exit 1
fi

echo "Install/update gaming files"
/usr/games/steamcmd +force_install_dir "/server" +login anonymous +@sSteamCmdForcePlatformType windows +app_update ${STEAM_GAMESERVERID} ${GAMESERVER_CMD} validate +quit

echo "Launching gameserver"
xvfb-run wine start /d "Z:\\server" "Z:\\server\\${GAMESERVER_CMD}" | tee /server/docker.log
