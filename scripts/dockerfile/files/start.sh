#!/bin/bash
echo "OS Date: $(date)"
echo "Steam APP ID: ${STEAM_GAMESERVERID}"
echo "Steam additional update args: ${STEAM_ADDITIONAL_UPDATE_ARGS}"
echo "Steam launch command: ${GAMESERVER_CMD}"
echo "Steam serverfiles path: ${GAMESERVER_FILES}"
echo "Foundry save folder: ${FOUNDRY_SAVE}"

if [ ! -f ${GAMESERVER_FILES}/App.cfg ]; then
  echo "Configuration file missing, creating default file."
  echo "Adjust this file to your needs and start the container again. See:"
  echo "https://dedicated.foundry-game.com/"
  cp /docker/App.cfg ${GAMESERVER_FILES}
  exit 1
fi

echo "Install/update gaming files"
/usr/games/steamcmd +force_install_dir "${GAMESERVER_FILES}" +login anonymous +@sSteamCmdForcePlatformType windows +app_update ${STEAM_GAMESERVERID} ${GAMESERVER_CMD} validate +quit

echo "Mounting save folder to S:"
mkdir -p "/home/steam/.wine/dosdevices/"
ln -s "${FOUNDRY_SAVE}" "/home/steam/.wine/dosdevices/s:"

echo "Launching gameserver"
xvfb-run wine ${GAMESERVER_FILES}/${GAMESERVER_CMD} | tee ${GAMESERVER_FILES}/docker.log
