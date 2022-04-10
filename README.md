[![](https://github.com/m-bers/docker-virt-manager/workflows/docker%20build/badge.svg)](https://github.com/m-bers/docker-virt-manager/actions/workflows/deploy.yml)[![](https://img.shields.io/docker/pulls/mber5/virt-manager)](https://hub.docker.com/r/mber5/virt-manager)
# Docker virt-manager
### GTK Broadway web UI for libvirt
![Docker virt-manager](docker-virt-manager.gif)

## What is it? 
virt-manager: https://virt-manager.org/  
broadway: https://developer.gnome.org/gtk3/stable/gtk-broadway.html


## Features:
* Uses GTK3 Broadway (HTML5) backend--no vnc, xrdp, etc needed!
* Password/SSH passphrase support via ttyd (thanks to [@obazda20](https://github.com/obazda20/docker-virt-manager) for the idea!) Just click the terminal icon at the bottom left to get to the password prompt after adding an ssh connection. 
<img width="114" alt="Screen Shot 2021-10-25 at 12 01 02 AM" src="https://user-images.githubusercontent.com/4750774/138649110-73c097cc-b054-424c-8fa0-d0c23540b499.png">

* Dark mode

## Requirements:
git, docker, docker-compose, at least one libvirt/kvm host

## Usage

### docker-compose

If docker and libvirt are on the same host
```yaml
services: 
  virt-manager:
    image: mber5/virt-manager:latest
    restart: always
    ports:
      - 8185:80
    environment:
    # Set DARK_MODE to true to enable dark mode
      DARK_MODE: false

    # Set HOSTS: "['qemu:///session']" to connect to a user session
      HOSTS: "['qemu:///system']"

    # If on an Ubuntu host (or any host with the libvirt AppArmor policy,
    # you will need to use an ssh connection to localhost
    # or use qemu:///system and uncomment the below line

    # privileged: true

    volumes:
      - "/var/run/libvirt/libvirt-sock:/var/run/libvirt/libvirt-sock"
      - "/var/lib/libvirt/images:/var/lib/libvirt/images"
    devices:
      - "/dev/kvm:/dev/kvm"
```
If docker and libvirt are on different hosts
```yaml
services: 
  virt-manager:
    image: mber5/virt-manager:latest
    restart: always
    ports:
      - 8185:80
    environment:
    # Set DARK_MODE to true to enable dark mode
      DARK_MODE: false

      # Substitute comma separated qemu connect strings, e.g.: 
      # HOSTS: "['qemu+ssh://user@host1/system', 'qemu+ssh://user@host2/system']"
      HOSTS: "[]"
    # volumes:
      # If not using password auth, substitute location of ssh private key, e.g.:
      # - /home/user/.ssh/id_rsa:/root/.ssh/id_rsa:ro
```

### SSH Keys and SSH agent forwarding

There are few options how to deal with ssh. 

#### Mount ssh key as a volume

You may use straight-forward approach and mount ssh private key to the container. This approach is described above and
you may simply to add the following volume to the `docker-compose.yml`

```yaml
services: 
  virt-manager:
    image: mber5/virt-manager:latest
    restart: always
    ports:
      - 8185:80
    environment:
      DARK_MODE: false
      HOSTS: "[]"
    volumes:
      - "/home/user/.ssh/id_rsa:/root/.ssh/id_rsa:ro"
```

Where `/home/user/.ssh/id_rsa` is a path to your private key on the host machine. You will be asked for passphrase all
the time and this is annoying.

#### Use ssh-agent and mount SSH_AUTH_SOCK

**For Linux host machines.**

Check that `ssh-agent` is running, add `ssh` key to the agent, check that `ssh` connections use `ssh-agent`. You may
[read this article](https://www.cyberciti.biz/faq/how-to-use-ssh-agent-for-authentication-on-linux-unix/)
explaining these commands.

Check that `$SSH_AUTH_SOCK` env variable exists.

```bash
$ echo $SSH_AUTH_SOCK
/tmp/ssh-5n3we7jOrV/agent.582768
```

After that, add to the `docker-compose.yml` following sections

```yaml
services: 
  virt-manager:
    image: mber5/virt-manager:latest
    restart: always
    ports:
      - 8185:80
    environment:
      DARK_MODE: false
      HOSTS: "[]"
      SSH_AUTH_SOCK: "/tmp/ssh_auth.sock"
    volumes:
      - "${SSH_AUTH_SOCK}:/tmp/ssh_auth.sock"
```

Now in your container you have `/tmp/ssh_auth.sock` socket to the `ssh-agent` on your host machine and all ssh
connections inside your container will use your `ssh-agent` on the host machine.

**For OS X host machines (for Windows must work too).**

Starting from Docker Desktop 2.2.0 (Jan 2020) a
[new feature was added](https://github.com/docker/for-mac/issues/410), so you don't need to use an ugly hacks with
socat, etc.

All you need is to use special path `/run/host-services/ssh-auth.sock` that Docker recognizes and create special
socket for `ssh-agent` on the host machine.

Your `docker-compose.yml` must look like this:

```yaml
services:
  virt-manager:
    image: mber5/virt-manager:latest
    restart: always
    ports:
      - 8185:80
    environment:
      DARK_MODE: false
      HOSTS: "[]"
      SSH_AUTH_SOCK: "/tmp/ssh_auth.sock"
    volumes:
      - "/run/host-services/ssh-auth.sock:/tmp/ssh-auth.sock"
```

### Building from Dockerfile
```bash
    git clone https://github.com/m-bers/docker-virt-manager.git
    cd docker-virt-manager
    docker build -t docker-virt-manager . && docker-compose up -d
```
Go to http://localhost:8185 in your browser
