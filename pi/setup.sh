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
sudo apt install pinta -y
sudo apt install samba -y
sudo apt install vlc -y

# Static IP
STATICIPFILE=/boot/cmdline.txt
STATICIP='ip=192.168.1.100'
sudo grep -qF -- "$STATICIP" "$STATICIPFILE" || echo "$STATICIP" >> "$STATICIPFILE"

# Aliases
# ALIASFILE=/home/pi/.bash_aliases
# touch $FILE
# ALIAS='alias la="ls -a"'
# sudo grep -qF -- "$ALIAS" "$ALIASFILE" || echo "$ALIAS" >> "$ALIASFILE"
# ALIAS='alias ll="ls -la"'
# sudo grep -qF -- "$ALIAS" "$ALIASFILE" || echo "$ALIAS" >> "$ALIASFILE"
# ALIAS='alias l="ls -CF"'
# sudo grep -qF -- "$ALIAS" "$ALIASFILE" || echo "$ALIAS" >> "$ALIASFILE"

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

# Deluge Docker
# sudo mkdir -p "/home/andy/.deluge"
# sudo chmod aog+rwx "/home/andy/.deluge"
# sudo mkdir -p "/home/andy/.deluge/downloads"
# sudo chmod aog+rwx "/home/andy/.deluge/downloads"
# sudo mkdir -p "/home/andy/.deluge/completed"
# sudo chmod aog+rwx "/home/andy/.deluge/completed"

# Sonarr Docker
# sudo mkdir -p "/home/andy/.sonarr"
# sudo chmod aog+rwx "/home/andy/.sonarr"
# sudo mkdir -p "/home/andy/.sonarr/tv"
# sudo chmod aog+rwx "/home/andy/.sonarr/tv"

# Mounts
sudo mkdir -p "/mnt/nas"
sudo chmod aog+rwx "/mnt/nas"

# SAMBA share
# sudo nano /etc/samba/smb.conf

# [Dad]
# comment = Dads folder
# path = /mnt/nas/Dad
# browseable = yes
# read only = no
# create mask = 0777
# directory mask = 0777
# public = yes
# guest ok = yes
# force user = andy
# force group = andy

# [Kids]
# comment = Kids folder
# path = /mnt/nas/Kids
# browseable = yes
# read only = no
# create mask = 0777
# directory mask = 0777
# public = yes
# guest ok = yes
# force user = andy
# force group = andy

# [Pictures]
# comment = Pictures folder
# path = /mnt/nas/Pictures
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
