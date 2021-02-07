all: update  git astropi gnome chrome joplin_pc tools dropbox rawtherapee freecad bCNC scripts


scripts:
	cp resize_for_CN ~/.local/share/nemo/scripts

update:
	sudo apt update
	sudo apt upgrade

UGS:
	sudo apt install alacarte openjdk-8-jdk
	wget https://ugs.jfrog.io/ugs/UGS/nightly/ugs-platform-app-2.0-SNAPSHOT-linux.tar.gz
	tar zxvf ugs-platform-app-2.0-SNAPSHOT-linux.tar.gz
	mv ugsplatform-linux ~/
	echo "~/ugsplatform-linux/bin/ugsplatform --jdkhome /usr/lib/jvm/java-8-openjdk-amd64" > ~/UGS.sh
	chmod 777 ~/UGS.sh


UGS_pi:
	wget https://ugs.jfrog.io/ugs/UGS/nightly/ugs-platform-app-2.0-SNAPSHOT-pi.tar.gz

	tar zxvf ugs-platform-app-2.0-SNAPSHOT-pi.tar.gz
	sudo apt install alacarte openjdk-8-jdk
	mv ugsplatform-pi ~/
	echo "~/ugsplatform-pi/bin/ugsplatform --jdkhome /usr/lib/jvm/java-8-openjdk-armhf" > ~/UGS.sh
	chmod 777 ~/UGS.sh


bCNC:
	sudo apt install -y python3-pip python3 python3-tk alacarte
	pip3 install --upgrade bCNC
	ln -s ~/.local/bin/bCNC ~/
	echo Use alacarte to create an icon to ~/bCNC

astropi:
	cd .. && git clone https://github.com/avarakin/AstroPiMaker4.git
	$(MAKE) -C ../AstroPiMaker4 utils syncthing vnc groups

astro:
	cd ../AstroPiMaker4 && git pull
	$(MAKE) -C ../AstroPiMaker4 indi_kstars ccdciel_skychart phd groups astrometry sample_startup

gnome:
	sudo apt -y install gnome-tweaks gnome-shell-extension-system-monitor alacarte gnome-shell-extension-dash-to-panel

cinnamon:
	sudo add-apt-repository ppa:linuxmint-daily-build-team/daily-builds
	sudo apt install cinnamon nemo-python

tools:
	sudo apt -y install emacs keepassxc geeqie zfsutils-linux gparted lm-sensors hddtemp psensor
	sudo snap install code --classic 
	sudo snap install gitkraken
	sudo snap install arduino && sudo usermod -a -G dialout $(USER)
	sudo apt -y install paprefs pulseaudio-module-raop

dropbox:
	wget https://linux.dropbox.com/packages/ubuntu/dropbox_2020.03.04_amd64.deb && sudo dpkg -i dropbox_2020.03.04_amd64.deb

freecad:
	wget https://github.com/FreeCAD/FreeCAD/releases/download/0.18.4/FreeCAD_0.18-16146-Linux-Conda_Py3Qt5_glibc2.12-x86_64.AppImage
	chmod 777 FreeCAD_0.18-16146-Linux-Conda_Py3Qt5_glibc2.12-x86_64.AppImage
	mkdir -p ~/FreeCAD
	mv FreeCAD_0.18-16146-Linux-Conda_Py3Qt5_glibc2.12-x86_64.AppImage ~/FreeCAD/


# not available in repositories yet. Snap package is very old
#	sudo add-apt-repository ppa:freecad-maintainers/freecad-stable
#	sudo add-apt-repository ppa:freecad-maintainers/freecad-daily
#	sudo apt-get update
#	sudo apt-get install freecad-daily freecad


flatpack:
	sudo apt install flatpak
	sudo apt install gnome-software-plugin-flatpak
	sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


kill-tracker:
	systemctl --user mask tracker-store.service tracker-miner-fs.service tracker-miner-rss.service tracker-extract.service tracker-miner-apps.service tracker-writeback.service
	tracker reset --hard

rawtherapee:
	sudo add-apt-repository ppa:dhor/myway
	sudo apt -y install rawtherapee

git:
	git config --global user.email "avarakin@gmail.com"
	git config --global user.name "Alex Varakin"
	git config credential.helper 'cache --timeout=30000'

chrome:
	wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && sudo dpkg -i google-chrome-stable_current_amd64.deb

joplin_pc:
	wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash

WAKEUP=/lib/systemd/system/wakeup.service
wakeup:
	sudo sh -c "echo '[Unit]' > $(WAKEUP)"
	sudo sh -c "echo 'Description=Disable wakeup on USB' >> $(WAKEUP)"
	sudo sh -c "echo 'After=multi-user.target' >> $(WAKEUP)"
	sudo sh -c "echo '[Service]'>> $(WAKEUP)"
	sudo sh -c "echo 'Type=oneshot'>> $(WAKEUP)"
	sudo sh -c "echo 'RemainAfterExit=yes'>> $(WAKEUP)"
#	sudo sh -c "echo 'ExecStart=/bin/echo PTXH > /proc/acpi/wakeup'>> $(WAKEUP)"
	sudo sh -c "echo 'ExecStart=/bin/sh -c \047/bin/echo PTXH > /proc/acpi/wakeup\047'>> $(WAKEUP)"
	sudo sh -c "echo '[Install]'>> $(WAKEUP)"
	sudo sh -c "echo 'WantedBy=multi-user.target'>> $(WAKEUP)"
	sudo systemctl enable wakeup.service
	sudo systemctl start wakeup.service


flutter:
	sudo snap install flutter --classic
	flutter
	flutter channel dev
	flutter upgrade
	flutter config --enable-linux-desktop
	flutter devices
	flutter doctor


appimage:
	sudo add-apt-repository ppa:appimagelauncher-team/stable
	sudo apt update
	sudo apt install appimagelauncher

darktable:
	sudo add-apt-repository ppa:pmjdebruijn/darktable-release
	sudo apt update
	sudo apt install darktable
