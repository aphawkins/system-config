#!/bin/bash

# Update
sudo apt update -y
sudo apt autoremove -y
sudo apt full-upgrade -y

# Static IP
STATICIPFILE=/boot/cmdline.txt
STATICIP='ip=192.168.2.3'
sudo grep -qF -- "$STATICIP" "$STATICIPFILE" || echo "$STATICIP" >> "$STATICIPFILE"

# Aliases
FILE=/home/pi/.bash_aliases
touch $FILE
ALIAS='alias la="ls -a"'
sudo grep -qF -- "$ALIAS" "$FILE" || echo "$ALIAS" >> "$FILE"
ALIAS='alias ll="ls -la"'
sudo grep -qF -- "$ALIAS" "$FILE" || echo "$ALIAS" >> "$FILE"
ALIAS='alias l="ls -CF"'
sudo grep -qF -- "$ALIAS" "$FILE" || echo "$ALIAS" >> "$FILE"

# ssh key
SSHPUBFILE=/home/pi/.ssh/id_rsa.pub
if [ ! -f "$SSHPUBFILE" ]; then
    ssh-keygen -C "andy@raspberrypi"
fi
cat $SSHPUBFILE

# VSCode
sudo -s
. <( wget -O - https://code.headmelted.com/installers/apt.sh )
exit

# Plex
# https://pimylifeup.com/raspberry-pi-plex-server/
sudo apt-get install apt-transport-https
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list
sudo apt-get update
sudo apt-get install plexmediaserver

# NAS Mounts
sudo mkdir /mnt/archer
sudo mount -t cifs -o vers=1.0 "//192.168.2.2/sdb1(sdb1)/MEDIA-DAD/Dad" /mnt/media-dad
sudo mkdir /mnt/media
sudo mount -t cifs -o vers=1.0 "//192.168.2.2/sda1(sda1)/MEDIA" /mnt/media-kids
