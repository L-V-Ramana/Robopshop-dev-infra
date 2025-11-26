#!/bin/bash
set -euo pipefail

SCRIPTS="/usr/local/openvpn_as/scripts"
USERNAME="openvpn"
PASSWORD="Openvpn@123"

# Wait until Access Server is fully ready
until /usr/local/openvpn_as/scripts/sacli Status >/dev/null 2>&1; do
  sleep 5
done

# Accept EULA
$SCRIPTS/sacli --key "eula_accepted" --value "true" ConfigPut

# Create user in LOCAL auth DB
$SCRIPTS/sacli --user "$USERNAME" --key "type" --value "user_connect" UserPropPut

# Set password
$SCRIPTS/sacli --user "$USERNAME" --new_pass "$PASSWORD" SetLocalPassword

# Make user admin
$SCRIPTS/sacli --user "$USERNAME" --key "prop_superuser" --value "true" UserPropPut

# VPN settings
$SCRIPTS/sacli --key 'vpn.daemon.0.listen.port' --value '1194' ConfigPut
$SCRIPTS/sacli --key 'vpn.daemon.0.listen.protocol' --value 'udp' ConfigPut

# DNS
$SCRIPTS/sacli --key 'vpn.client.dns.server_auto' --value 'true' ConfigPut
$SCRIPTS/sacli --key 'cs.prof.defaults.dns.0' --value '8.8.8.8' ConfigPut
$SCRIPTS/sacli --key 'cs.prof.defaults.dns.1' --value '1.1.1.1' ConfigPut

# Allow internet routing
$SCRIPTS/sacli --key 'vpn.client.routing.reroute_gw' --value 'true' ConfigPut

# Restrict server access
$SCRIPTS/sacli --key 'vpn.server.routing.gateway_access' --value 'true' ConfigPut

systemctl restart openvpnas

$SCRIPTS/sacli ConfigSync
$SCRIPTS/sacli start
