#!/bin/bash

chown $USER:$GROUP $PLUGIN_DIR -R
echo "Verfügabre Plugins in ${PLUGIN_DIR}"
ls -lha $PLUGIN_DIR

exec gosu $USER:$GROUP java -Xms${MEM_LIMIT} -Xmx${MEM_LIMIT} -XX:+UseG1GC -jar spigot-${MC_VERSION}.jar nogui --world-dir ${WORLD_DIR} --plugins ${PLUGIN_DIR} --bukkit-settings ${WORLD_DIR}/bukkit.yml --commands-settings ${WORLD_DIR}/commands.yml --config ${WORLD_DIR}/server.properties --spigot-settings ${WORLD_DIR}/spigot.yml

