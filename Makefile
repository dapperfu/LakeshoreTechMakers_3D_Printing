.PHONY: check
check:
	checkmake Makefile

.PHONY: Marlins
Marlins: Marlin-1.1.9 Marlin-2.0.0

2.0.0.tar.gz:
	wget https://github.com/MarlinFirmware/Marlin/archive/2.0.0.tar.gz

1.1.9.tar.gz:
	wget https://github.com/MarlinFirmware/Marlin/archive/1.1.9.tar.gz

Marlin-1.1.9: 1.1.9.tar.gz
	tar -xvf ${^}

Marlin-2.0.0: 2.0.0.tar.gz
	tar -xvf ${^}

venv: OctoPrint/setup.py
	virtualenv --python=`which python2` ${@}
	${@}/bin/pip install -U pip wheel setuptools
	${@}/bin/pip install  OctoPrint/
	${@}/bin/pip install platformio


#
OctoPrint/setup.py:
	git submodule update --init

.PHONY: all test clean
all:
test:
clean:
	git clean -xfd
