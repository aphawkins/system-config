#!/bin/bash -v

# HOME=/home/pi

# Update
sudo apt update -y
sudo apt autoremove -y
sudo apt full-upgrade -y

# Static IP
STATICIPFILE=/boot/cmdline.txt
STATICIP='ip=192.168.2.3'
sudo grep -qF -- "$STATICIP" "$STATICIPFILE" || echo "$STATICIP" >> "$STATICIPFILE"

# Aliases
ALIASFILE=/home/pi/.bash_aliases
touch $FILE
ALIAS='alias la="ls -a"'
sudo grep -qF -- "$ALIAS" "$ALIASFILE" || echo "$ALIAS" >> "$ALIASFILE"
ALIAS='alias ll="ls -la"'
sudo grep -qF -- "$ALIAS" "$ALIASFILE" || echo "$ALIAS" >> "$ALIASFILE"
ALIAS='alias l="ls -CF"'
sudo grep -qF -- "$ALIAS" "$ALIASFILE" || echo "$ALIAS" >> "$ALIASFILE"

# ssh key
#SSHPUBFILE=/home/pi/.ssh/id_rsa.pub
#if [ ! -f "$SSHPUBFILE" ]; then
#    ssh-keygen -C "andy@raspberrypi"
#fi
#cat $SSHPUBFILE

# NAS Mounts
sudo mkdir /mnt/media-dad
sudo mount -t cifs -o vers=1.0,username="guest",password="" '//192.168.2.2/sdb1(sdb1)/MEDIA-DAD/Dad' '/mnt/media-dad'
sudo mkdir /mnt/media-kids
sudo mount -t cifs -o vers=1.0,username="guest",password="" '//192.168.2.2/sda1(sda1)/MEDIA' '/mnt/media-kids'
ALIAS='alias mountmedia="sudo mount -t cifs -o vers=1.0,username=\"guest\",password=\"\" '//192.168.2.2/sdb1(sdb1)/MEDIA-DAD/Dad' '/mnt/media-dad' && sudo mount -t cifs -o vers=1.0,username=\"guest\",password=\"\" '//192.168.2.2/sda1(sda1)/MEDIA' '/mnt/media-kids'"'
sudo grep -qF -- "$ALIAS" "$ALIASFILE" || echo "$ALIAS" >> "$ALIASFILE"

# Persist the mounts ** DO NOT - BREAKS BOOT **
#FILE=/etc/fstab
#LINE="//192.168.2.2/sdb1(sdb1)/MEDIA-DAD/Dad /mnt/media-dad cifs,vers=1.0 guest 0 0"
#sudo grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"
#LINE="//192.168.2.2/sda1(sda1)/MEDIA /mnt/media-kids cifs,vers=1.0 guest 0 0"
#sudo grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

# git
git config --global user.name "Andy Hawkins"
git config --global user.email "aph828@gmail.com"
git config --global core.autocrlf input
git config --global fetch.prune true

# VSCode for Pi
# https://code.headmelted.com/
#wget -qO - https://packagecloud.io/headmelted/codebuilds/gpgkey | sudo apt-key add -
#sudo -s
#. <( wget -O - https://code.headmelted.com/installers/apt.sh )
#exit

# Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker pi
docker version
docker info

# Plex Docker
sudo mkdir -p /home/pi/.plex/config
docker run \
  --name=plex \
  --net=host \
  -e PUID=1000 \
  -e PGID=1000 \
  -e VERSION=docker \
  -e PLEX_CLAIM='' \
  -v "/home/pi/.plex/config":/config \
  -v "/mnt/media-dad":/media-dad \
  -v "/mnt/media-kids":/media-kids \
  --restart unless-stopped \
  linuxserver/plex

# Plex Install
# https://pimylifeup.com/raspberry-pi-plex-server/
# sudo apt-get install apt-transport-https
# curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
# echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
# sudo apt-get update
# sudo apt-get install plexmediaserver

# Deluge Docker
sudo mkdir -p "/home/pi/.deluge/config"
sudo chmod aog+rwx "/home/pi/.deluge/config"
sudo mkdir -p "/home/pi/.deluge/downloads"
sudo chmod aog+rwx "/home/pi/.deluge/downloads"
sudo mkdir -p "/home/pi/.deluge/completed"
sudo chmod aog+rwx "/home/pi/.deluge/completed"
docker run \
  -d \
  --name=deluge \
  --net=host \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e UMASK_SET=022 \
  -e DELUGE_LOGLEVEL=error \
  -v "/home/pi/.deluge/config":/config \
  -v "/home/pi/.deluge/downloads":/downloads \
  -v "/home/pi/.deluge/completed":/completed \
  --restart unless-stopped \
  linuxserver/deluge


# Transmission
sudo apt install transmission-daemon
sudo systemctl stop transmission-daemon
sudo mkdir -p /media/transmission/torrent-inprogress
sudo mkdir -p /media/transmission/torrent-complete
sudo chown -R pi:pi /media/transmission/torrent-inprogress
sudo chown -R pi:pi /media/transmission/torrent-complete
sudo nano /etc/transmission-daemon/settings.json
# "download-dir": "/media/transmission/torrent_complete",
# "incomplete-dir": "/media/transmission/torrent-inprogress",
# "incomplete-dir-enabled": true,
# "rpc-password": "Your_Password",
# "rpc-username": "Your_Username",
# "rpc-whitelist": "192.168.*.*",
sudo nano /etc/init.d/transmission-daemon
# USER=pi
sudo nano /etc/systemd/system/multi-user.target.wants/transmission-daemon.service
# user=pi
sudo systemctl daemon-reload
sudo chown -R pi:pi /etc/transmission-daemon
sudo mkdir -p /home/pi/.config/transmission-daemon/
sudo ln -s /etc/transmission-daemon/settings.json /home/pi/.config/transmission-daemon/
sudo chown -R pi:pi /home/pi/.config/transmission-daemon/
sudo systemctl start transmission-daemon
