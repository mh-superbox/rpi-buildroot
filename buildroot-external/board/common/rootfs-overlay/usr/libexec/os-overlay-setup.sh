#! /bin/sh

set -e

mkdir -p /mnt/overlay/etc
mkdir -p /mnt/overlay/home
mkdir -p /mnt/overlay/root
mkdir -p /mnt/overlay/etc/systemd/network
mkdir -p /mnt/overlay/var/lib/docker

if [ ! -f /mnt/overlay/etc/hostname ]; then
  cp -fp /etc/hostname /mnt/overlay/etc/hostname
fi

if [ ! -f /mnt/overlay/etc/hosts ]; then
  cp -fp /etc/hosts /mnt/overlay/etc/hosts
fi

if [ ! -f /mnt/overlay/etc/systemd/network/20-wired.network ]; then
  cp -fp /etc/systemd/network/20-wired.network /mnt/overlay/etc/systemd/network/20-wired.network
fi

if [ ! -f /mnt/overlay/etc/systemd/network/25-wireless.network ]; then
  cp -fp /etc/systemd/network/25-wireless.network /mnt/overlay/etc/systemd/network/25-wireless.network
fi

if [ ! -f /mnt/overlay/etc/systemd/timesyncd.conf ]; then
  cp -fp /etc/systemd/timesyncd.conf /mnt/overlay/etc/systemd/timesyncd.conf
fi

if [ ! -f /mnt/overlay/home ]; then
  cp -rfp /home/* /mnt/overlay/home
fi
