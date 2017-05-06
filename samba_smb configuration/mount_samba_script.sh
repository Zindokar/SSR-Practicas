#!/bin/bash
mount -t cifs -o username=$1 //10.110.7.2/$2 /mnt/$3

