#!/bin/bash
#Keyfile creation wizard
sudo dd if=/dev/urandom of=/root/keyfile bs=1024 count=4
sudo chmod 0400 /root/keyfile
sudo cryptsetup luksAddKey /dev/sdX /root/keyfile
sudo nano /etc/crypttab #sdX_crypt /dev/sdX /root/keyfile luks
sdX_crypt /dev/disk/by-uuid/247ad289-dbe5-4419-9965-e3cd30f0b080 /root/keyfile luks
sudo nano /etc/fstab
/dev/mapper/sdX_crypt /media/sdX ext3 defaults 0 2
sudo mount -a

#detect luks partitions
#for i in * ; do cryptsetup luksDump $i 2>/dev/null|grep UUID; done
