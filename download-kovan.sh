#!/usr/bin/env bash
set -e
set -u
set -o pipefail

if [ $# -eq 0 ]; then
    echo "Usage: bash download-kovan.sh <role>"
    echo "   where <role> is 'bootnode' or 'validator'"
    exit 1
fi

cd "/home/$1/parity_data"

echo "$(date) Waiting 60s for playbook to complete"
sleep 60

echo "$(date) Stopping parity"
systemctl stop poa-parity

if [ -f "kovan-chains.tar.gz" ]; then
    echo "Chain archive already exist, skipping download"
else
    echo "$(date) Downloading chains archive"
    curl -sSfLO "https://s3.amazonaws.com/misc-temp-files/kovan-chains.tar.gz"

    echo "$(date) Checking archive integrity"
    echo "7d060c2a539188029b98cde1a5b1d70c73b767c510bc40907ab01bf1230e1fca kovan-chains.tar.gz" | sha256sum -c
fi

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

echo "$(date) Waiting 60s to check that parity service did not crash"
sleep 60
ETIME="$(ps -p $(pidof parity) -o etimes | head -n2 | tail -n1)"
if [ "$ETIME" -gt 30 ]; then
    echo "$(date) Service seems to be up and running. Removing chains archive"
    rm kovan-chains.tar.gz
else
    echo "$(date) Service is not running"
fi
