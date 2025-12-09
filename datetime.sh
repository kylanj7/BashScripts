#!/bin/bash

sudo timedatectl list-timezones

sudo timedatetl list-timezones | grep Los_Angeles

sudo timedatectl set-timezone America/Los_Angeles

sudo timedatectl set-ntp true

sudo timedatectl status

sudo nano /etc/systemd/timesyncd.conf
