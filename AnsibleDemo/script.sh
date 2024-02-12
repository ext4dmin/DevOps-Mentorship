#!/bin/bash
sudo mkdir /mnt/demoprojm2024-fs
if [ ! -d "/etc/smbcredentials" ]; then
sudo mkdir /etc/smbcredentials
fi
if [ ! -f "/etc/smbcredentials/demoprojm2024sa.cred" ]; then
    sudo bash -c 'echo "username=demoprojm2024sa" >> /etc/smbcredentials/demoprojm2024sa.cred'
    sudo bash -c 'echo "password='$1'" >> /etc/smbcredentials/demoprojm2024sa.cred'
fi
sudo chmod 600 /etc/smbcredentials/demoprojm2024sa.cred

sudo bash -c 'echo "//demoprojm2024sa.file.core.windows.net/demoprojm2024-fs /mnt/demoprojm2024-fs cifs nofail,credentials=/etc/smbcredentials/demoprojm2024sa.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30" >> /etc/fstab'
sudo mount -t cifs //demoprojm2024sa.file.core.windows.net/demoprojm2024-fs /mnt/demoprojm2024-fs -o credentials=/etc/smbcredentials/demoprojm2024sa.cred,dir_mode=0777,file_mode=0777,serverino,nosharesock,actimeo=30

sudo mv -f /var/www/html /var/www/html-bak
sudo ln -s -f /mnt/demoprojm2024-fs/html/ /var/www/
