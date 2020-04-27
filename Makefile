all: update  git astropi gnome chrome joplin_pc tools dropbox rawtherapee freecad bCNC

update:
	sudo apt update
	sudo apt upgrade

bCNC:
	sudo apt install -y python3-pip python3
	pip3 install --upgrade bCNC
	ln -s ~/.local/bin/bCNC ~/
	echo Use alacarte to create an icon to ~/bCNC

astropi:
	cd .. && git clone https://github.com/avarakin/AstroPiMaker4.git
	$(MAKE) -C ../AstroPiMaker4 utils syncthing

astro:
	$(MAKE) -C ../AstroPiMaker4 indi_kstars ccdciel_skychart phd groups astrometry sample_startup

gnome:
	sudo apt -y install gnome-tweaks gnome-shell-extension-system-monitor alacarte gnome-shell-extension-dash-to-panel

tools:
	sudo apt -y install emacs gnucash keepassxc geeqie freecad zfsutils-linux
	sudo snap install code --classic
	sudo snap install gitkraken
	sudo snap install arduino

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
