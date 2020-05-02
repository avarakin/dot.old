#all: git astropi chrome joplin_pc
       
all:  tools dropbox rawtherapee freecad

astropi:
#	cd .. && git clone https://github.com/avarakin/AstroPiMaker4.git
	$(MAKE) -C ../AstroPiMaker4 utils gnome-desktop syncthing

tools:
	sudo apt -y install emacs keepassxc geeqie freecad zfsutils-linux gnome-shell-extension-suspend-button gnome-shell-extension-system-monitor alacarte gparted
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

#	sudo add-apt-repository ppa:freecad-maintainers/freecad-stable
#	sudo add-apt-repository ppa:freecad-maintainers/freecad-daily
#	sudo apt-get update
#	sudo apt-get install freecad-daily freecad


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
	sudo sh -c "echo 'Type=simple'>> $(WAKEUP)"
	sudo sh -c "echo 'ExecStart=echo EHC1>/proc/acpi/wakeup;echo EHC2> /proc/acpi/wakeup;echo XHC>/proc/acpi/wakeup'>> $(WAKEUP)"
	sudo sh -c "echo '[Install]'>> $(WAKEUP)"
	sudo sh -c "echo 'WantedBy=multi-user.target'>> $(WAKEUP)"
	sudo systemctl enable wakeup.service
	sudo systemctl start wakeup.service



