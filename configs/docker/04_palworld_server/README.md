### Install server on Linux

1. Add 40G drive to vbox image
2. Bridged network access
3. Install Debian
    - Increase swap to 5G
    - No safe padding on main partition
    - Include ssh server
<!-- 4. remove safe padding on partitions (`tune2fs /dev/XXX -m 0`) -->
4. Install git, docker (`code/bash/docker_install_script.sh`), curl, htop, Tailscale
4. Connect to Tailscale VPN
5. Connect to git with ssh key
6. Clone this repo in `/srv`
6. Setup cron to reset server daily
    1. Disable anacron: `sudo systemctl stop anacron.timer`
    2. Copy `restart_server.sh` to `/etc/cron.daily`
    3. Give to root and rename to `restart_palworld_server`
6. Copy the save folder to the SaveGames folder
7. Modify ./data/Config/LinuxServer/GameUserSettings.ini "DedicatedServerName" line to match the name of the save folder

### Update Palworld version

Run `restart_server.sh`
