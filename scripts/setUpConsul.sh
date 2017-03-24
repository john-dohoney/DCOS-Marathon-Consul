#!/usr/bin/env sh

##
# external inputs with reasonable defaults
#
DATACENTER=${DATACENTER:-consul-dc}
LOG_LEVEL=${LOG_LEVEL:-INFO}
NETWORK_INTERFACE=${NETWORK_INTERFACE:-eth0}
# only used during server mode, recommended for HA clusters
BOOTSTRAP_EXPECT=${BOOTSTRAP_EXPECT:-1}
JOIN_ADDR=${JOIN_ADDR:-}
NETWORK_BIND_ADDR=$(ifconfig "$NETWORK_INTERFACE"| awk '/inet addr/{print substr($2,6)}')
# either use the default network address or externally provided
BIND_ADDR=${BIND_ADDR:-$NETWORK_BIND_ADDR}
HOSTNAME=$(hostname)

if [ "$1" = "" ]; then
  echo "[ERROR] Mode argument missing, need 'server' or 'agent'"
  exit 1
fi

# must be server or agent
MODE="$1"

# needs a FQDN or reachable IP address (can be empty for first node)
JOIN_ADDR="$2"

# setup consul server config
SERVER_CONFIG=$(cat <<EOS
{
  "server": true,
  "node_name": "$HOSTNAME",
  "datacenter": "$DATACENTER",
  "data_dir": "/opt/consul/server",
  "log_level": "$LOG_LEVEL",
  "bind_addr": "$BIND_ADDR",
  "client_addr": "0.0.0.0",
  "ui": true,
  "disable_update_check": true,
  "bootstrap_expect": $BOOTSTRAP_EXPECT
EOS
)

# if $JOIN_ADDR is not empty, then add to config
if [ "$JOIN_ADDR" != "" ]; then
  SERVER_CONFIG=$SERVER_CONFIG$',\n  "start_join": '"[\"$JOIN_ADDR\"]"
fi

SERVER_CONFIG=$SERVER_CONFIG$'\n}'

# setup consul agent config
AGENT_CONFIG=$(cat <<EOA
{
  "node_name": "$HOSTNAME",
  "datacenter": "$DATACENTER",
  "data_dir": "/opt/consul/agent",
  "log_level": "$LOG_LEVEL",
  "bind_addr": "$BIND_ADDR",
  "disable_update_check": true,
  "start_join": ["$JOIN_ADDR"]
}
EOA
)

if [ "$MODE" = "server" ]; then
  echo "$SERVER_CONFIG" > /opt/consul/server/conf.d/00consul-server.json
  /bin/consul agent -config-dir=/opt/consul/server/conf.d
elif [ "$MODE" = "agent" ]; then
  echo "$AGENT_CONFIG" > /opt/consul/agent/conf.d/00consul-agent.json
  /bin/consul agent -config-dir=/opt/consul/agent/conf.d
else
  echo "[ERROR] Invalid Mode, need 'server' or 'agent', found $MODE"
  exit 1
fi
