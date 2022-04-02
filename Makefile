DISK=/dev/sda
EFI=/dev/sda1
ROOT=/dev/sda2
USER=alex
NAME=zbox
TIMEZONE=America/New_York
KEYMAP=us
BTRFS_OPTS=defaults,noatime,compress=zstd,ssd,autodefrag


# Install software as regular user with sudo access
software: base astro vnc wap

# install base system using Arch installer. 
# Attention: It will wipe out the whole disk
install_base: speedup prepare_disk file_systems pacstrap

# Once base is installed, we need to chroot-arch and run the rest of the base install
in_chroot: config utils services grub



speedup:
	sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
	pacman -S --noconfirm reflector rsync grub
	cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
	reflector -a 48 -c `curl -4 ifconfig.co/country-iso` -f 5 -l 20 --sort rate --save /etc/pacman.d/mirrorlist


#This will wipe out the whole disk!
prepare_disk:
	pacman -Sy --noconfirm
	pacman -S --noconfirm gptfdisk btrfs-progs
	sgdisk -Z $(DISK)
	sgdisk -a 2048 -o $(DISK)
# 	create partitions
#	sgdisk -n 1::+1M --typecode=1:ef02 --change-name=1:'BIOSBOOT' $(DISK)
	sgdisk -n 1::+300M --typecode=1:ef00 --change-name=1:'EFIBOOT' $(DISK) 
	sgdisk -n 2::-0 --typecode=2:8300 --change-name=2:'ROOT' $(DISK) 




file_systems:
	mkfs.vfat -F32 -n "EFIBOOT" $(EFI)
	mkfs.btrfs $(ROOT) -f
	mount -t btrfs $(ROOT) /mnt/
	btrfs subvolume create /mnt/@
	btrfs subvolume create /mnt/@home
	btrfs subvolume create /mnt/@var_log
	btrfs subvolume create /mnt/@var_cache
	btrfs subvolume create /mnt/@var_tmp
	btrfs subvolume create /mnt/@snapshots
	umount /mnt
	mount $(ROOT) -t btrfs -o $(BTRFS_OPTS),subvol=@  /mnt
	mkdir -p /mnt/home
	mkdir -p /mnt/var
	mkdir -p /mnt/var/log
	mkdir -p /mnt/var/cache
	mkdir -p /mnt/var/tmp
	mkdir -p /mnt/.snapshots
	mount $(ROOT) -t btrfs -o $(BTRFS_OPTS),subvol=@home  /mnt/home
	mount $(ROOT) -t btrfs -o $(BTRFS_OPTS),subvol=@var_log  /mnt/var/log
	mount $(ROOT) -t btrfs -o $(BTRFS_OPTS),subvol=@var_cache  /mnt/var/cache
	mount $(ROOT) -t btrfs -o $(BTRFS_OPTS),subvol=@var_tmp  /mnt/var/tmp
	mount $(ROOT) -t btrfs -o $(BTRFS_OPTS),subvol=@snapshots  /mnt/.snapshots


pacstrap:
	pacstrap /mnt base base-devel linux linux-firmware vim networkmanager make zsh nano sudo archlinux-keyring wget libnewt grub git efibootmgr arch-install-scripts --noconfirm --needed
	echo "keyserver hkp://keyserver.ubuntu.com" >> /mnt/etc/pacman.d/gnupg/gpg.conf
	cp -R Makefile /mnt/root
	cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

#now you need to do 
#	arch-chroot /mnt 
#	cd /root
#and continue with rest of the steps

config:
	sed -i 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen
	locale-gen
	timedatectl --no-ask-password set-timezone $(TIMEZONE)
	timedatectl --no-ask-password set-ntp 1
	localectl --no-ask-password set-locale LANG="en_US.UTF-8" LC_TIME="en_US.UTF-8"
	localectl --no-ask-password set-keymap $(KEYMAP)
	sed -i 's/^# %wheel ALL=(ALL) NOPASSWD: ALL/%wheel ALL=(ALL) NOPASSWD: ALL/' /etc/sudoers
#Add parallel downloading
	sed -i 's/^#ParallelDownloads/ParallelDownloads/' /etc/pacman.conf
#Enable multilib
	sed -i "/\[multilib\]/,/Include/"'s/^#//' /etc/pacman.conf
	pacman -Sy --noconfirm
	-groupadd libvirt
	-useradd -m -G wheel,libvirt -s /bin/zsh $(USER) 
	cp -R /root/Makefile /home/$(USER)/
	chown -R $(USER): /home/$(USER)
	passwd $(USER)
	echo $(NAME) > /etc/hostname
#Uncomment per your hardware:
	pacman -S --noconfirm intel-ucode
#	pacman -S --noconfirm amd-ucode
#   pacman -S nvidia --noconfirm --needed && nvidia-xconfig
#pacman -S xf86-video-amdgpu --noconfirm --needed
	pacman -S libva-intel-driver libvdpau-va-gl lib32-vulkan-intel vulkan-intel libva-intel-driver libva-utils lib32-mesa --needed --noconfirm


utils:
	pacman -S --noconfirm --needed vim mc htop neofetch networkmanager ntp p7zip \
	rsync snapper sudo unrar openssh unzip usbutils wget zsh zsh-syntax-highlighting zsh-autosuggestions \
	net-tools inetutils archlinux-keyring

services:
	systemctl enable ntpd.service
	systemctl enable sshd
	systemctl enable NetworkManager.service
	systemctl enable systemd-resolved


grub:
	mkdir -p /boot/efi
	-mount /dev/sda1 /boot/efi
	grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
	grub-mkconfig -o /boot/grub/grub.cfg
	genfstab -U / >> /etc/fstab


##########################
# Rest of the install
##########################
yay:
	git clone "https://aur.archlinux.org/yay.git" && cd ~/yay && makepkg -si --noconfirm


base: scripts mate
	sudo pacman -S --noconfirm --needed terminator geeqie flameshot arduino tilda syncthing ttf-inconsolata remmina gparted emacs pulseaudio \
	terminus-font ttf-droid ttf-hack ttf-roboto 
	#yay -S --noconfirm --needed nomachine
	sudo systemctl enable --now syncthing@$(USER).service
	#needed for Arduino ESP32
	pip3 install pyserial
	sudo usermod -a -G uucp $(USER)
	-yay -S --noconfirm --needed octopi 
	-yay -S --noconfirm --needed ttf-envy-code-r 
	-yay -S --noconfirm --needed gooogle-chrome 
	-yay -S --noconfirm --needed joplin-appimage 
	-yay -S --noconfirm --needed visual-studio-code-bin 
	-yay -S --noconfirm --needed snapper-gui-git 


desktop: 
	-yay -S --noconfirm --needed  dropbox 
	-yay -S --noconfirm --needed  teams 
	-yay -S --noconfirm --needed  zoom 
	-yay -S --noconfirm --needed  vmware 
	sudo pacman -S --noconfirm --needed rawtherapee cura system-config-printer gimp 
	systemctl enable cups.service

astro: indi phd kstars astrometry ccdciel

kstars:
	sudo pacman -S --noconfirm --needed kstars breeze-icons

indi:
	sudo pacman -S --noconfirm --needed binutils patch libraw libindi gpsd gcc
	-yay -S --nobatchinstall --noconfirm --needed libindi_3rdparty libindi-asi 

phd:
	-yay -S --nobatchinstall --noconfirm --needed phd2 

astrometry:
	-yay -S --nobatchinstall --noconfirm --needed sextractor-bin 
	-yay -S --nobatchinstall --noconfirm --needed astrometry.net
	#looks like astrometry is installed in the wrong place, so creating a symlink to the right place
	-sudo ln -s /usr/lib/python/site-packages/astrometry /usr/lib/python3.10/site-packages
	wget broiler.astrometry.net/~dstn/4100/index-4107.fits
	wget broiler.astrometry.net/~dstn/4100/index-4108.fits
	wget broiler.astrometry.net/~dstn/4100/index-4109.fits
	sudo mv index-410[789].fits /usr/share/astrometry/data


.PHONY: ccdciel
ccdciel:
	yay -S --nobatchinstall --noconfirm --needed libpasastro
	cd ccdciel && makepkg  --noconfirm --needed  -sric && rm -f  *.xz *.zst


x:
	sudo pacman -S --noconfirm --needed mesa xorg xorg-server xorg-apps xorg-drivers xorg-xkill xorg-xinit
	sudo pacman -S --noconfirm --needed lightdm-gtk-greeter  lightdm 
	sudo systemctl enable lightdm.service

mate: x
	sudo pacman -S --noconfirm --needed mate mate-extra

kde: x
	sudo pacman -S --noconfirm --needed plasma kde-gtk-config kmix 

gnome: x
	sudo pacman -S --noconfirm --needed gnome gnome-tweaks gnome-shell-extension-appindicator base-devel
	yay -S --noconfirm --needed gnome-shell-extension-arc-menu gnome-shell-extension-dash-to-panel-git gnome-shell-extension-custom-hot-corners-extended

bspwm: x
	yay -S --noconfirm --needed bspwm sxhkd polybar compton rofi

vmware:
	yay -S --noconfirm --needed vmware
	sudo systemctl start vmware-networks
	sudo systemctl enable vmware-networks

powerlink:
	touch "$(HOME)/.cache/zshhistory"
	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
	echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >> ~/.zshrc

scripts:
	mkdir -p ~/.local/share/nemo/scripts
	cp resize_for_CN ~/.local/share/nemo/scripts
	mkdir -p ~/.local/share/kservices5/ServiceMenus
	cp  resize_for_cn.desktop ~/.local/share/kservices5/ServiceMenus/ 

git:
	git config --global user.email "avarakin@gmail.com"
	git config --global user.name "Alex Varakin"
	git config credential.helper 'cache --timeout=30000'


#configure tigervnc 
vnc :
	sudo pacman -S --noconfirm --needed tigervnc
	vncpasswd
	echo geometry=1920x1080 > ~/.vnc/config
	echo alwaysshared >> ~/.vnc/config
	sudo sh -c "echo :1=$(USER) >>  /etc/tigervnc/vncserver.users"
	sudo systemctl enable vncserver@:1.service
	sudo systemctl start vncserver@:1.service


wap :
	yay -S --noconfirm --needed create_ap-git
	sudo sed -i.bak 's/SSID=MyAccessPoint/SSID=zbox/'  /etc/create_ap.conf
	sudo sed -i.bak 's/PASSPHRASE=12345678/PASSPHRASE=password/'  /etc/create_ap.conf
	sudo sed -i.bak 's/INTERNET_IFACE=eth0/INTERNET_IFACE=enp2s0/'  /etc/create_ap.conf
	sudo sed -i.bak 's/NO_VIRT=0/NO_VIRT=1/'  /etc/create_ap.conf
	sudo sed -i.bak 's/WIFI_IFACE=wlan0/WIFI_IFACE=wlp3s0/'  /etc/create_ap.conf
	sudo systemctl enable create_ap
	sudo systemctl start create_ap
	sleep 5
	sudo systemctl status create_ap


astrodmx:
	wget https://www.astrodmx-capture.org.uk/sites/downloads/astrodmx/current/x86-64/astrodmx-capture_1.4.2.1_x86-64-manual.tar.gz
	tar zxvf astrodmx-capture_1.4.2.1_x86-64-manual.tar.gz

astap:
	wget https://versaweb.dl.sourceforge.net/project/astap-program/linux_installer/astap_amd64.tar.gz
