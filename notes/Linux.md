# Dump

pour voir tous les disques monté sur ubuntu :<br>
`sudo fdisk -l`

show accessible mounted drives :<br>
`df -h`

show accessible drives and their mount points :<br>
`lsblk`

mount device with its own name :
- `udisks --mount /dev/sda1`
- `/usr/bin/udisks --mount /dev/sda1`

bash zoom :
- IN : ctrl + shift + =
- OUT : ctrl + -
- NEUTRAL : ctrl + shift + à

folder / file disk usage :<br>
`du -sh <path>`

find files :<br>
`find <path/to/folder> -iname <stuff_to_find>`<br>
`find ./ -iname "*.ipynb"`

apply command to output of find :<br>
`find ./notes -type d -exec chmod 755 {} \;`

Inflate .tar.gz file :<br>
`tar -xvzf <file_path.tar.gz> -C <destination_folder_path>`

# Packages to install on Debian

- git
- openssh server
- curl
- docker (cf. `code/bash/docker_install_script.sh`)
- htop
- tailscale
- ntp

## Bugfix ssh session hanging after shutdown/reboot

https://serverfault.com/a/958773
docker
```bash
sudo cp /usr/share/doc/openssh-client/examples/ssh-session-cleanup.service /etc/systemd/system/
sudo systemctl enable ssh-session-cleanup.service
```

## Setup Remote Desktop Viewer on Linux

https://stackoverflow.com/questions/78074498/how-to-configure-xrdp-to-work-with-gnome-on-ubuntu

### On the linux machine (Debian) to log into

- install the required packages :
    - `sudo apt update`
    - `sudo apt install xrdp gnome-session`
- Allow xrdp to modify local SSL certicates :
`sudo adduser xrdp ssl-cert`
- Add the file `~/.xsession` with the following content :
    ```
    gnome-session
    ```
- Add the file `~/.xsessionrc` with the following content :
    ```
    export XAUTHORITY=${HOME}/.Xauthority
    export XDG_CONFIG_DIRS=/etc/xdg/xdg-ubuntu:/etc/xdg
    export GNOME_SHELL_SESSION_MODE=ubuntu
    ```
- Optionally, to get the vertical menu on the side, add to `~/.xsessionrc` :<br>
`export XDG_CURRENT_DESKTOP=ubuntu:GNOME`

to wake up screen remotely (only works when already logged in):<br>
`loginctl unlock-session <session_id>`

the session id is the one with the line "Service=gdm-password" when running the command :<br>
`loginctl list-sessions --no-legend | while read id rest; do echo; loginctl show-session $id; done`

### On the windows machine to log in with

- Open `Remote Desktop Connection`
- Add in the IP of the linux machine
- Click `Connect`
- Input credentials
