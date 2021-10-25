#!/bin/bash
# Run the broadwayd daemon and point nginx to it
/usr/local/bin/start

# Note: No X server or wayland support--only cli and gtk3
# ↓↓↓ PUT COMAMNDS HERE ↓↓↓
dbus-launch gsettings set org.gnome.desktop.interface gtk-theme 'Materia-dark'
dbus-launch gsettings set org.virt-manager.virt-manager.connections uris "$HOSTS"
dbus-launch gsettings set org.virt-manager.virt-manager.connections autoconnect "$HOSTS"
dbus-launch gsettings set org.virt-manager.virt-manager xmleditor-enabled true
tmux new-session -d -s "ttyd" "virt-manager --no-fork"
ttyd tmux a