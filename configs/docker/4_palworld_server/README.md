### Install server on Linux

1. add 40G drive to vbox image
2. bridged network access
3. install debian
    - increase swap to 5G
    - no safe padding on main partition
<!-- 4. remove safe padding on partitions (`tune2fs /dev/XXX -m 0`) -->
4. install git, docker (`docker_install_script.sh`), curl, htop
4. install Tailscale and connect to VPN
5. connect to git with ssh key
6. clone this repo in `/srv`
6. setup cron to reset server daily
    1. disable anacron: `sudo systemctl stop anacron.timer`
    2. copy `restart_server.sh` to `/etc/cron.daily`
    3. give to root and rename to `restart_palworld_server`
6. copy the save folder to the SaveGames folder
7. modify ./data/Config/LinuxServer/GameUserSettings.ini "DedicatedServerName" line to match the name of the save folder

### Update Palworld version

run `restart_server.sh`
