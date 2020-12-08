#!/bin/bash
set -e
nginx -g 'daemon off;' &
su user --command "export GDK_BACKEND=broadway"
su user --command "export BROADWAY_DISPLAY=:5"
su user --command "nohup /usr/bin/broadwayd :5 &> /var/log/broadway.log &"
su user --command 'dbus-launch gsettings set org.virt-manager.virt-manager.connections uris "$AUTOCONNECT"'
su user --command 'dbus-launch gsettings set org.virt-manager.virt-manager.connections autoconnect "$AUTOCONNECT"'
su user --command 'virt-manager --no-fork'