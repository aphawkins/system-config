#!/bin/bash

sudo apt update -y
sudo apt autoremove -y
sudo apt upgrade -y

# Plex
# https://pimylifeup.com/raspberry-pi-plex-server/
sudo apt-get install apt-transport-https
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
sudo apt-get update
sudo apt-get install plexmediaserver


# NAS Mounts
sudo mkdir /mnt/archer
sudo mount -t cifs -o vers=1.0 "//192.168.2.2/sdb1(sdb1)/MEDIA-DAD/Dad" /mnt/archer
sudo mkdir /mnt/media
sudo mount -t cifs -o vers=1.0 "//192.168.2.2/sda1(sda1)/MEDIA" /mnt/media