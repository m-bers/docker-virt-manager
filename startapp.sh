#!/bin/bash
# Run the broadwayd daemon and point nginx to it
/usr/local/bin/start

# Note: No X server or wayland support--only cli and gtk3
# ↓↓↓ PUT COMMANDS HERE ↓↓↓
dbus-launch gsettings set org.virt-manager.virt-manager.connections uris "$HOSTS"
dbus-launch gsettings set org.virt-manager.virt-manager.connections autoconnect "$HOSTS"
dbus-launch gsettings set org.virt-manager.virt-manager xmleditor-enabled true
tmux send-keys -t ttyd dbus-launch\ virt-manager\ --no-fork Enter
trap 'exit 0' SIGTERM
while true; do sleep 1; done