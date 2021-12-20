all: update clock git chrome utils joplin_pc rawtherapee freecad scripts 


arch-kde:
	sudo pacman -S plasma kde-gtk-config kmix 

arch-gnome:

	sudo pacman -S gnome gnome-tweaks gnome-shell-extension-appindicator base-devel
	yay -S gnome-shell-extension-arc-menu nome-shell-extension-dash-to-panel-git gnome-shell-extension-custom-hot-corners-extended

arch-bspwm:
	yay -S bspwm sxhkd polybar compton rofi

arch-vmware:
	yay -S vmware
	sudo systemctl start vmware-networks
	sudo systemctl enable vmware-networks


arch: scripts
	sudo pacman -Syu
	yay -S octopi ttf-envy-code-r google-chrome joplin-desktop dropbox teams zoom visual-studio-code-bin
	sudo pacman -S vim freecad kstars stellarium mc terminator geeqie flameshot emacs arduino code tilda rawtherapee syncthing ttf-inconsolata remmina


powerlink:
	touch "$HOME/.cache/zshhistory"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
	echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc


clock:
	timedatectl set-local-rtc 1 --adjust-system-clock


hass: hass-debian coral-driver coral-test scripts chrome joplin_pc

utils:
	sudo apt install remmina mc synaptic vim terminator emacs geeqie gparted lm-sensors hddtemp psensor flameshot openssh-server tilda -y


arduino:
	cd /opt && sudo wget https://downloads.arduino.cc/arduino-1.8.16-linux64.tar.xz && sudo tar -xvf ./arduino-1.8.16-linux64.tar.xz && cd arduino-1.8.16/ && sudo ./install.sh
	sudo rm  /opt/arduino-1.8.16-linux64.tar.xz

scripts:
	cp resize_for_CN ~/.local/share/nemo/scripts

update:
	sudo apt update
	sudo apt upgrade -y

UGS:
	sudo apt install alacarte openjdk-8-jdk
	wget https://ugs.jfrog.io/ui/native/UGS/v2.0.7/ugs-platform-app-linux.tar.gz
	tar zxvf ugs-platform-app-linux.tar.gz
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
	sudo apt install -y python3-pip python3 python3-tk
	pip3 install --upgrade bCNC
	ln -s ~/.local/bin/bCNC ~/
	echo Use alacarte to create an icon to ~/bCNC

astropi:
	cd .. && git clone https://github.com/avarakin/AstroPiMaker4.git
	$(MAKE) -C ../AstroPiMaker4 utils syncthing vnc groups

astro:
	cd ../AstroPiMaker4 && git pull
	$(MAKE) -C ../AstroPiMaker4 indi kstars ccdciel skychart phd groups astrometry sample_startup

gnome:
	sudo apt -y install gnome-tweaks gnome-shell-extension-system-monitor alacarte gnome-shell-extension-dash-to-panel

cinnamon:
	sudo add-apt-repository ppa:linuxmint-daily-build-team/daily-builds
	sudo apt install cinnamon nemo-python

tools:
	sudo apt -y install emacs geeqie  gparted lm-sensors hddtemp psensor
	sudo snap install arduino && sudo usermod -a -G dialout $(USER)
	sudo apt -y install paprefs pulseaudio-module-raop

dropbox:
	wget https://linux.dropbox.com/packages/ubuntu/dropbox_2020.03.04_amd64.deb && sudo dpkg -i dropbox_2020.03.04_amd64.deb

freecad: 
	sudo add-apt-repository ppa:freecad-maintainers/freecad-daily
	sudo add-apt-repository ppa:freecad-maintainers/freecad-stable
	sudo apt-get update
	sudo apt install freecad freecad-daily -y

zerotier:
	curl -s https://install.zerotier.com | sudo bash
	sudo zerotier-cli join a09acf0233a897d8

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
	sudo sh -c "echo 'ExecStart=/bin/sh -c \047/bin/echo XHC0 > /proc/acpi/wakeup\047'>> $(WAKEUP)"
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
	sudo apt -y install appimagelauncher

darktable:
	sudo add-apt-repository ppa:pmjdebruijn/darktable-release
	sudo apt update
	sudo apt -y install darktable

hass-debian:
	sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y
	sudo apt-get install -y software-properties-common apparmor-utils apt-transport-https ca-certificates curl dbus jq network-manager
	sudo systemctl disable ModemManager
	sudo systemctl stop ModemManager
	curl -fsSL get.docker.com | sudo sh
	curl -sL "https://raw.githubusercontent.com/Kanga-Who/home-assistant/master/supervised-installer.sh" | sudo bash -s

coral-driver:
	echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | sudo tee /etc/apt/sources.list.d/coral-edgetpu.list
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
	sudo apt-get update
	sudo apt-get install gasket-dkms libedgetpu1-std
	sudo sh -c "echo 'SUBSYSTEM==\"apex\", MODE=\"0660\", GROUP=\"apex\"' >> /etc/udev/rules.d/65-apex.rules"
	sudo groupadd apex
	sudo adduser $USER apex

coral-test:
	sudo apt-get install python3-pycoral
	mkdir coral && cd coral && git clone https://github.com/google-coral/pycoral.git && cd pycoral && bash examples/install_requirements.sh classify_image.py && python3 examples/classify_image.py --model test_data/mobilenet_v2_1.0_224_inat_bird_quant_edgetpu.tflite --labels test_data/inat_bird_labels.txt --input test_data/parrot.jpg
