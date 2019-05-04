#!/usr/bin/env bash
set -e
set -u
set -o pipefail

cd "/home/$1/parity_data"

echo "$(date) Stopping parity"
systemctl stop poa-parity

echo "$(date) Downloading chains archive"
curl -sSfLO "https://s3.amazonaws.com/misc-temp-files/kovan-chains.tar.gz"

echo "$(date) Checking archive integrity"
echo "68a6185ad64a19709f2281bad561be94510a1fbc918bde2d291285f9d5c6b365 kovan-chains.tar.gz" | sha256sum -c

echo "$(date) Removing existing kovan chains data"
rm -rf chains/kovan

echo "$(date) Unpacking archive"
tar -zxf kovan-chains.tar.gz

echo "$(date) Removing list of known nodes"
rm chains/kovan/network/nodes.json

echo "$(date) Changing ownership to $1"
chown "$1:$1" -R chains/kovan

echo "$(date) Restarting services"
systemctl restart poa-parity
sleep 10
systemctl restart poa-netstats

echo "$(date) Done. Bye-bye"
