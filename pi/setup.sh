#!/bin/bash -v

# HOME=/home/pi

# Update
sudo apt update -y
sudo apt autoremove -y
sudo apt full-upgrade -y

# Apt
sudo apt install chromium-browser -y
sudo apt install curl -y
sudo apt install git -y
sudo apt install gparted -y
sudo apt install neofetch -y
sudo apt install net-tools -y
sudo apt install samba -y
sudo apt install vlc -y

# Static IP
STATICIPFILE=/boot/cmdline.txt
STATICIP='ip=192.168.1.100'
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
#    ssh-keygen -C "aph828@gmail.com"
#fi
#cat $SSHPUBFILE

# NAS Mounts
# sudo mkdir /mnt/media-dad
# sudo mount -t cifs -o vers=1.0,username="guest",password="" '//192.168.2.2/sdb1(sdb1)/MEDIA-DAD/Dad' '/mnt/media-dad'
# sudo mkdir /mnt/media-kids
# sudo mount -t cifs -o vers=1.0,username="guest",password="" '//192.168.2.2/sda1(sda1)/MEDIA' '/mnt/media-kids'
# ALIAS='alias mountmedia="sudo mount -t cifs -o vers=1.0,username=\"guest\",password=\"\" '//192.168.2.2/sdb1(sdb1)/MEDIA-DAD/Dad' '/mnt/media-dad' && sudo mount -t cifs -o vers=1.0,username=\"guest\",password=\"\" '//192.168.2.2/sda1(sda1)/MEDIA' '/mnt/media-kids'"'
# sudo grep -qF -- "$ALIAS" "$ALIASFILE" || echo "$ALIAS" >> "$ALIASFILE"

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
docker run \
  -d \
  --name=plex \
  --net=host \
  -e PUID=1000 \
  -e PGID=1000 \
  -e VERSION=docker \
  -e PLEX_CLAIM='' \
  -v "/media/andy/EXT0/.plex/config":/config \
  -v "/media/andy/EXT1/MEDIA-DAD":/media-dad \
  -v "/media/andy/EXT0/MEDIA":/media \
  --restart unless-stopped \
  linuxserver/plex

# Deluge Docker
sudo chmod aog+rwx "/home/andy/.deluge"
sudo mkdir -p "/home/andy/.deluge/downloads"
sudo chmod aog+rwx "/home/andy/.deluge/downloads"
sudo mkdir -p "/home/andy/.deluge/completed"
sudo chmod aog+rwx "/home/andy/.deluge/completed"
docker run \
  -d \
  --name=deluge \
  --net=host \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e UMASK_SET=022 \
  -e DELUGE_LOGLEVEL=error \
  -v "/media/andy/EXT0/.deluge/config":/config \
  -v "/home/andy/.deluge/downloads":/downloads \
  -v "/home/andy/.deluge/completed":/completed \
  --restart unless-stopped \
  linuxserver/deluge

# SAMBA share
# sudo nano /etc/samba/smb.conf

# [media-dad]
# comment = Dad media shared folder
# path = /media/andy/EXT1/MEDIA-DAD/Dad
# browseable = yes
# read only = no
# create mask = 0777
# directory mask = 0777
# public = yes
# guest ok = yes
# force user = andy
# force group = andy

# [media]
# comment = Media shared folder
# path = /media/andy/EXT0/MEDIA
# browseable = yes
# read only = no
# create mask = 0777
# directory mask = 0777
# public = yes
# guest ok = yes
# force user = andy
# force group = andy

# sudo smbpasswd -a andy
# sudo service smbd restart
# sudo ufw allow samba
