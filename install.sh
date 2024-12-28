#!/usr/bin/env bash

#check if OS is NixOS else quit install
if [ -n "$(grep -i nixos < /etc/os-release)" ]; then
  echo "Verified this is NixOS."
  echo "-----"
else
  echo "This is not NixOS or the distribution information is not available."
  exit
fi

#check if git i installed else quit install
if command -v git &> /dev/null; then
  echo "Git is installed, continuing with installation."
  echo "-----"
else
  echo "Git is not installed. Please install Git and try again."
  echo "Example: nix-shell -p git"
  exit
fi

echo "Ensure In Home Directory"
cd || exit

#download the nix flake repo
git clone https://gitlab.com/NicklasBL97/workstation-flake.git
cd workstation-flake || exit
mkdir hosts/workstation
cp hosts/default/*.nix hosts/workstation
git config --global user.name "installer"
git config --global user.email "installer@gmail.com"
git add .

#TODO make host in flake file "workstation"
#sed -i "/^\s*host[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\workstation/" ./flake.nix

#TODO fix ariables.nix file
#sed -i "/^\s*keyboardLayout[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$keyboardLayout\"/" ./hosts/$hostName/variables.nix

#TODO set username in flake file
#installusername=$(echo $USER)
#sed -i "/^\s*username[[:space:]]*=[[:space:]]*\"/s/\"\(.*\)\"/\"$installusername\"/" ./flake.nix

echo "Generating The Hardware Configuration"
sudo nixos-generate-config --show-hardware-config > ./hosts/workstation/hardware.nix

echo "Setting Required Nix Settings Then Going To Install"
NIX_CONFIG="experimental-features = nix-command flakes"

sudo nixos-rebuild switch --flake ~/workstation-flake#workstation
