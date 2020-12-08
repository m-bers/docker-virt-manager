#!/bin/bash
set -e
nginx -g 'daemon off;' &
nohup /usr/bin/broadwayd :5 &> /var/log/broadway.log &
dbus-launch gsettings set org.virt-manager.virt-manager.connections uris "$AUTOCONNECT"
dbus-launch gsettings set org.virt-manager.virt-manager.connections autoconnect "$AUTOCONNECT"
virt-manager --no-fork