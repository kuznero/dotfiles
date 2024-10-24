#!/usr/bin/env bash

mkdir -p ~/Host
vmhgfs-fuse .host:/ ~/Host -o subtype=vmhgfs-fuse

