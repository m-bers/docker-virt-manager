# Docker virt-manager

### What is it? 
virt-manager: https://virt-manager.org/  
broadway: https://developer.gnome.org/gtk3/stable/gtk-broadway.html

### Features:
Uses GTK3 Broadway (HTML5) backend--no vnc, xrdp, etc needed!

### Requirements:
git, docker

### Usage: 

    git clone https://github.com/m-bers/docker-virt-manager.git
    cd docker-virt-manager
    docker build -t docker-virt-manager . && docker-compose up -d
    
Go to http://localhost:8085 in your browser

### Notes:
In the `docker-compose.yml`, supply your own ssh key (already deployed to libvirt hosts) as a `volume` and libvirt connection strings as an `environment variable`, e.g.

    environment:
      AUTOCONNECT: "['qemu+ssh://user@host1/system', 'qemu+ssh://user@host2/system']"

### To do:
Publish to Docker Hub  
Make a base image for broadway 
Customizable options for virt-manager via gsettings and environment variables  
