#!/bin/bash

# Uncomment # to include chinese for locale generation
sudo sed -i 's/^# *\(zh_\)/\1/' /etc/locale.gen

sudo locale-gen
