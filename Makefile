all: base astro

nox:  git
	sudo pacman -S --noconfirm --needed vim mc htop neofetch networkmanager ntp p7zip \
	rsync snapper sudo unrar unzip usbutils wget zsh zsh-syntax-highlighting zsh-autosuggestions 
	sudo systemctl enable ntpd.service
	sudo systemctl enable --now sshd
	#sudo systemctl disable dhcpcd.service
	#sudo systemctl stop dhcpcd.service
	#sudo systemctl enable NetworkManager.service

base: nox scripts mate
	yay -S --noconfirm --needed nomachine
	yay -S --noconfirm --needed octopi 
	yay -S --noconfirm --needed ttf-envy-code-r 
	yay -S --noconfirm --needed gooogle-chrome 
	yay -S --noconfirm --needed joplin-desktop 
	yay -S --noconfirm --needed visual-studio-code-bin 
	yay -S --noconfirm --needed snapper-gui-git 
	sudo pacman -S --noconfirm --needed terminator geeqie flameshot arduino tilda syncthing ttf-inconsolata remmina gparted emacs pulseaudio \
	terminus-font ttf-droid ttf-hack ttf-roboto 


desktop: 
	yay -S --noconfirm --needed  dropbox teams zoom vmware 
	sudo pacman -S --noconfirm --needed rawtherapee cura system-config-printer gimp 
	systemctl enable cups.service

astro:
	sudo pacman -S --noconfirm --needed kstars breeze-icons binutils patch  libraw libindi gpsd gcc
	-yay -S --nobatchinstall --noconfirm --needed libindi_3rdparty 
	-yay -S --nobatchinstall --noconfirm --needed sextractor-bin 
	-yay -S --nobatchinstall --noconfirm --needed astrometry.net 
	-yay -S --nobatchinstall --noconfirm --needed phd2 
	#-yay -S --nobatchinstall --noconfirm --needed ccdciel
	wget broiler.astrometry.net/~dstn/4100/index-4107.fits
	wget broiler.astrometry.net/~dstn/4100/index-4108.fits
	wget broiler.astrometry.net/~dstn/4100/index-4109.fits
	sudo mv index-410[789].fits /usr/share/astrometry/data
	cd ccdciel && makepkg && sudo pacman -U --noconfirm  ccdciel-0.9.76-1-x86_64.pkg.tar.zst

x:
	sudo pacman -S --noconfirm --needed mesa xorg xorg-server xorg-apps xorg-drivers xorg-xkill xorg-xinit
	sudo pacman -S lightdm-gtk-greeter  lightdm 
	sudo systemctl enable lightdm.service

mate: x
	sudo pacman -S --noconfirm --needed mate mate-extra

kde: x
	sudo pacman -S --noconfirm --needed plasma kde-gtk-config kmix 

gnome: x

	sudo pacman -S --noconfirm --needed gnome gnome-tweaks gnome-shell-extension-appindicator base-devel
	yay -S --noconfirm --needed gnome-shell-extension-arc-menu nome-shell-extension-dash-to-panel-git gnome-shell-extension-custom-hot-corners-extended

bspwm: x
	yay -S --noconfirm --needed bspwm sxhkd polybar compton rofi

vmware:
	yay -S --noconfirm --needed vmware
	sudo systemctl start vmware-networks
	sudo systemctl enable vmware-networks

powerlink:
	touch "$HOME/.cache/zshhistory"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
	echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

scripts:
	mkdir -p ~/.local/share/nemo/scripts
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



#configure tigervnc 
vnc :
	sudo pacman -S --noconfirm --needed tigervnc
	echo geometry=1920x1080 > ~/.vnc/config
	echo alwaysshared >> ~/.vnc/config
	sudo sh -c "echo :1=$$USER >>  /etc/tigervnc/vncserver.users"
	sudo systemctl enable vncserver@:1.service
	sudo systemctl start vncserver@:1.service
