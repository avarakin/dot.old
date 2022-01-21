all: base astro

nox:  git
	sudo pacman -S vim mc emacs htop linux linux-firmware linux-headers neofetch networkmanager ntp p7zip pulseaudio \
	rsync snapper sudo unrar unzip usbutils wget zsh zsh-syntax-highlighting zsh-autosuggestions alsa-plugins alsa-utils
	sudo systemctl enable ntpd.service
	sudo systemctl disable dhcpcd.service
	sudo systemctl stop dhcpcd.service
	sudo systemctl enable NetworkManager.service

base: nox scripts mate
	yay -S octopi ttf-envy-code-r google-chrome joplin-desktop visual-studio-code-bin snapper-gui-git 
	sudo pacman -S terminator geeqie flameshot arduino tilda syncthing ttf-inconsolata remmina gparted  \
	terminus-font ttf-droid ttf-hack ttf-roboto 


desktop: 
	yay -S dropbox teams zoom vmware 
	sudo pacman -S rawtherapee cura system-config-printer gimp 
	systemctl enable cups.service

astro:
	sudo pacman -S --needed kstars breeze-icons yaourt binutils patch  libraw libindi gpsd gcc
	yay -S libindi_3rdparty sextractor-bin astrometry.net phd2 ccdciel
	wget broiler.astrometry.net/~dstn/4100/index-4107.fits
	wget broiler.astrometry.net/~dstn/4100/index-4108.fits
	wget broiler.astrometry.net/~dstn/4100/index-4109.fits
	sudo mv index-410[789].fits /usr/share/astrometry/data

x:
	sudo pacman -S mesa xorg xorg-server xorg-apps xorg-drivers xorg-xkill xorg-xinit sddm
	sudo systemctl enable sddm.service

mate: x
	sudo pacman -S mate mate-extras

kde: x
	sudo pacman -S plasma kde-gtk-config kmix 

gnome: x

	sudo pacman -S gnome gnome-tweaks gnome-shell-extension-appindicator base-devel
	yay -S gnome-shell-extension-arc-menu nome-shell-extension-dash-to-panel-git gnome-shell-extension-custom-hot-corners-extended

bspwm: x
	yay -S bspwm sxhkd polybar compton rofi

vmware:
	yay -S vmware
	sudo systemctl start vmware-networks
	sudo systemctl enable vmware-networks

powerlink:
	touch "$HOME/.cache/zshhistory"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
	echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

scripts:
	cp resize_for_CN ~/.local/share/nemo/scripts

git:
	git config --global user.email "avarakin@gmail.com"
	git config --global user.name "Alex Varakin"
	git config credential.helper 'cache --timeout=30000'


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


