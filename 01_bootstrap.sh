#!/bin/sh
VENV=venv
virtualenv --python=`which python2` ${VENV}

wget https://github.com/MarlinFirmware/Marlin/archive/2.0.0.tar.gz
wget https://github.com/MarlinFirmware/Marlin/archive/1.1.9.tar.gz

ls *.gz | xargs -n1 -P2 tar -xzf
