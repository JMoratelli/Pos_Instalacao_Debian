#!/usr/bin/env bash

### Initial message
echo -e "\n       ############################################################"
echo -e "       #    Activating the contrib and non-free repository  /     #"
echo -e "       #     Install flatpak support and flathub repository       #"
echo -e "       ############################################################ \n"
echo "For more information, visit the project link:"
echo "https://github.com/phaleixo/after_install_debian_12"
echo "Adaptado por jmoratelli e desenvolvido por phaleixo. https://github.com/phaleixo"

### check if there is an internet connection.
if ping -q -c 3 -W 1 1.1.1.1 >/dev/null;
then
  	echo ""
	echo ""
	echo -e "\e[32;1mInternet connection OK.\e[m"
	echo "Continuing with the script..."
	echo ""
else
  	echo -e "\e[31;1mYou are not connected to the internet. Check your network or Wi-Fi connection before proceeding.\e[m"
	exit 1
fi

### Check for sudo privileges
sudo -v || (inform "sudo may not be installed or the user may not have sudo permissions." && exit 1)

### Activating the contrib and non-free repository
sudo apt-add-repository contrib -y
sudo apt-add-repository non-free -y
sudo apt update && sudo apt full-upgrade -y
sudo apt install curl ca-certificates -y
curl -s https://repo.waydro.id | sudo bash

### Install flatpak support and flathub repository
sudo apt install gnome-software-plugin-flatpak -y 
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo -e "repository activate"

sleep 2
clear 

### Install codecs, fonts and tweaks.
apps=(  
        exfat-fuse 
	ffmpeg 
	ffmpegthumbnailer 
	firmware-amd-graphics 
	firmware-linux-nonfree 
	font-manager 
	fonts-croscore 
	fonts-noto 
	fonts-noto-extra 
	fonts-ubuntu 
	gamemode 
	gir1.2-gtop-2.0 
	gnome-browser-connector 
	gnome-firmware 
	gnome-tweaks 
	gstreamer1.0-plugins-ugly 
	gstreamer1.0-vaapi 
	gufw 
	libavcodec-extra 
	ldap-utils 
	libasound2-plugins 
	micro 
	vdpauinfo
	python3-pip
	python3
	gnome-boxes
	p7zip-rar
	ntp
	network-manager-config-connectivity-debian
	ttf-mscorefonts-installer
	default-jre
	default-jdk -y
 	corectrl
  	waydroid
   	linphone
)

for app_name in "${apps[@]}"; do
  if ! dpkg -l | grep -q "$app_name"; then
    sudo apt install "$app_name" -y
  else
    echo "[installed] - $app_name"
  fi
done
### Adding/Confirming 32-bit architecture
sudo dpkg --add-architecture i386
echo -e "Installed tweaks and codecs"

sleep 2
clear

# Instalar aplicativos Flatpak
flatpak=(
	com.getpostman.Postman
	com.github.tchx84.Flatseal
	com.usebottles.bottles
	de.haeckerfelix.Fragments
	io.dbeaver.DBeaverCommunity
 	com.discordapp.Discord
  	com.valvesoftware.Steam
   	com.google.Chrome
    	net.davidotek.pupgui2
     	com.github.eneshecan.WhatsAppForLinux
)

for nome_do_flatpak in "${flatpak[@]}"; do
  if ! flatpak list | grep -q "$nome_do_flatpak"; then
    sudo flatpak install flathub --system "$nome_do_flatpak" -y
  fi
done

## Installing ONLYOFFICE Desktop Editors from repository

mkdir -p -m 700 ~/.gnupg
gpg --no-default-keyring --keyring gnupg-ring:/tmp/onlyoffice.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys CB2DE8E5
chmod 644 /tmp/onlyoffice.gpg
sudo chown root:root /tmp/onlyoffice.gpg
sudo mv /tmp/onlyoffice.gpg /usr/share/keyrings/onlyoffice.gpg

echo 'deb [signed-by=/usr/share/keyrings/onlyoffice.gpg] https://download.onlyoffice.com/repo/debian squeeze main' | sudo tee -a /etc/apt/sources.list.d/onlyoffice.list

sudo apt-get update

sudo apt-get install onlyoffice-desktopeditors

echo -e "Instaled apps"

sleep 2
clear

mkdir -p ~/.fonts

wget --version > /dev/null

if [[ $? -ne 0 ]]; then
        echo "wget not available , installing"
        sudo apt update && sudo apt install wget -y
fi

unzip >> /dev/null

if [[ $? -ne 0 ]]; then
        echo "unzip not available , installing"
        sudo apt update && sudo apt install unzip -y
fi


wget -O fonts.zip "https://github.com/mozilla/Fira/archive/refs/tags/4.202.zip"

wget -O firacode.zip "https://github.com/tonsky/FiraCode/releases/download/1.204/FiraCode_1.204.zip"

wget -O FontsForDesign.zip "https://github.com/JMoratelli/Pos_Instalacao_Debian/blob/main/Fonts%20for%20design.zip"


if [[ $? -ne 0 ]]; then
        echo "Downloading failed , exiting"
        exit 1
fi

unzip fonts.zip -d ~/.fonts
unzip firacode.zip -d ~/.fonts
unzip FontsForDesign.zip -d ~/.fonts

clear
echo "purging fonts cache "
fc-cache -v -f

sleep 2
clear

echo "Done"
sleep 2
clear
echo "Setting default fonts "

gsettings set org.gnome.desktop.interface document-font-name 'Fira Sans Regular 11'
gsettings set org.gnome.desktop.interface font-name 'Fira Sans Regular 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code Regular 11'
gsettings set org.gnome.nautilus.desktop font 'Fira Sans Regular 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font "Fira Sans SemiBold 12"
clear

rm -rf fonts.zip
rm -rf firacode.zip
rm -rf FontsForDesign.zip

echo -e "Fonts installed"

sleep 2
clear

apps_remove=(
    fcitx*
    mozc*
    xiterm+thai*
    mlterm*
    xterm*
    hdate*
    kasumi*
    gnome-games*
    im*
    goldendict*
    hdate*
    uim*
    thunderbird*  
)

### uninstall and clean
for app_name_remove in "${apps_remove[@]}"; do
    sudo apt remove --purge "$app_name_remove" -y
done

sudo apt install gnome-console -y &&  sudo apt remove gnome-terminal -y 
sudo apt autoremove && sudo apt autoclean

echo -e "removed unnecessary apps"

sleep 2
clear


### Install Extensions

array=( 
https://extensions.gnome.org/extension/8/places-status-indicator/
https://extensions.gnome.org/extension/615/appindicator-support/
https://extensions.gnome.org/extension/5500/auto-activities/
https://extensions.gnome.org/extension/5446/quick-settings-tweaker/
https://extensions.gnome.org/extension/307/dash-to-dock/
https://extensions.gnome.org/extension/5219/tophat/
https://extensions.gnome.org/extension/3733/tiling-assistant/
)

for i in "${array[@]}"
do
    EXTENSION_ID=$(curl -s $i | grep -oP 'data-uuid="\K[^"]+')
    VERSION_TAG=$(curl -Lfs "https://extensions.gnome.org/extension-query/?search=$EXTENSION_ID" | jq '.extensions[0] | .shell_version_map | map(.pk) | max')
    wget -O ${EXTENSION_ID}.zip "https://extensions.gnome.org/download-extension/${EXTENSION_ID}.shell-extension.zip?version_tag=$VERSION_TAG"
    gnome-extensions install --force ${EXTENSION_ID}.zip
    if ! gnome-extensions list | grep --quiet ${EXTENSION_ID}; then
        busctl --user call org.gnome.Shell.Extensions /org/gnome/Shell/Extensions org.gnome.Shell.Extensions InstallRemoteExtension s ${EXTENSION_ID}
    fi
    gnome-extensions enable ${EXTENSION_ID}
    rm ${EXTENSION_ID}.zip
done

echo -e "Extensions instaled"

sleep 2
clear

### Check video driver
video_driver_info=$(lspci -k | grep amdgpu)
video_card_info=$(lspci | grep VGA)

if [[ "$video_driver_info" == *"Kernel driver in use: amdgpu"* ]]; then
    # Amdgpu driver is already active
    inform "Video card: '$video_card_info'\n----------------------------------------------------------------" "success"
    inform "The amdgpu driver is already active. No action required." "success"
elif [[ "$video_driver_info" == *"Kernel driver in use: radeon"* ]]; then
    # Switch from radeon to amdgpu
    inform "Video card: '$video_card_info'\n----------------------------------------------------------------" "success"
    inform "Switching driver from radeon to amdgpu..."
    sed_command='s/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 radeon.cik_support=0 amdgpu.cik_support=1 radeon.si_support=0 amdgpu.si_support=1"/'

    if sudo sed -i "$sed_command" /etc/default/grub && sudo update-grub; then
        inform "Driver configuration updated successfully. Restart the system to apply the changes." "success"
    else
        inform "Error updating GRUB or changing the driver. Please restart the system manually after fixing the issue." "error"
    fi
else
    # No AMDGPU or Radeon driver detected
    inform "Video card: '$video_card_info'" "error"
    inform "Unable to detect the AMDGPU or Radeon video driver on the system." "error"
fi




