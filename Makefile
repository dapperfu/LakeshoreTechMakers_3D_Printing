.PHONY: check
check:
	checkmake Makefile
	
# Build Marlin 1.1.9 and 2.0.0 firmwares.
.PHONY: firmwares
firmwares: marlin119 marlin200 klipper
	
# Aliases
.PHONY: klipper_bin
klipper_bin: klipper/out/klipper.elf.hex

.PHONY: marlin119
marlin119: Marlin-1.1.9/.pioenvs/sanguino_atmega1284p/firmware.hex venv
.PHONY: marlin200
marlin200: Marlin-2.0.0/.pioenvs/sanguino_atmega1284p/firmware.hex venv
	
# Build 
klipper/out/klipper.elf.hex: klipper/Makefile
	cp klipper-config klipper/.config
	cd klipper/ && make -j8

Marlin-1.1.9/.pioenvs/sanguino_atmega1284p/firmware.hex: Marlin-1.1.9
	venv/bin/platformio run --project-dir ${^} --environment sanguino_atmega1284p
Marlin-2.0.0/.pioenvs/sanguino_atmega1284p/firmware.hex: Marlin-2.0.0
	venv/bin/platformio run --project-dir ${^} --environment sanguino_atmega1284p
	
.PHONY: marlins
marlins: Marlin-1.1.9 Marlin-2.0.0

# Download Marlin releases.
2.0.0.tar.gz:
	wget https://github.com/MarlinFirmware/Marlin/archive/2.0.0.tar.gz
1.1.9.tar.gz:
	wget https://github.com/MarlinFirmware/Marlin/archive/1.1.9.tar.gz

# Extract Marlin releases & apply CR-10 configurations.
Marlin-1.1.9: 1.1.9.tar.gz
	tar -xvf ${^}
	cp ${@}/Marlin/example_configurations/Creality/CR-10/*.h ${@}/Marlin/
Marlin-2.0.0: 2.0.0.tar.gz
	tar -xvf ${^}
	cp ${@}/config/examples/Creality/CR-10/*.h ${@}/Marlin/

# Setup Virtual Environment
venv: OctoPrint/setup.py
	virtualenv --python=`which python2` ${@}
	${@}/bin/pip install -U pip wheel setuptools
	${@}/bin/pip install  OctoPrint/
	${@}/bin/pip install platformio

# Get submodules.
OctoPrint/setup.py:
	git submodule update --init
klipper/Makefile:
	git submodule update --init
	

# minphony from check.
.PHONY: all test clean
all:
test:
clean:
	git clean -xfd
	cd klipper && git clean -xfd
