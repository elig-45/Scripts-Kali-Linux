#!/bin/bash
# Script pour configurer Kali Linux entièrement en français et désinstaller la langue anglaise.

function color_echo() {
    local color_code="$1"
    local message="$2"
    echo -e "\033[${color_code}m${message}\033[0m"
}

if [ "$EUID" -ne 0 ]; then
    color_echo "1;31" "Veuillez exécuter ce script en tant que root (sudo)."
    exit 1
fi

color_echo "1;34" "\n=== Configuration complète de Kali Linux en français ===\n"

# Libération d'espace disque
color_echo "1;33" "Nettoyage du cache APT..."
apt autoremove -y > /dev/null && apt clean > /dev/null

# Mise à jour des paquets
color_echo "1;32" "\nMise à jour de la liste des paquets..."
apt update -y > /dev/null && apt upgrade -y > /dev/null

# Installation des paquets de langue française
color_echo "1;32" "\nInstallation des paquets de langue française..."
apt install -y locales-all manpages-fr aspell-fr libreoffice-l10n-fr > /dev/null

# Configuration des locales
color_echo "1;32" "\nConfiguration des locales en français..."
sed -i 's/^# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
update-locale LANG=fr_FR.UTF-8

# Configuration persistante du clavier en AZERTY
color_echo "1;32" "\nConfiguration du clavier en français (AZERTY)..."
localectl set-x11-keymap fr
echo 'XKBLAYOUT="fr"' > /etc/default/keyboard
dpkg-reconfigure -f noninteractive keyboard-configuration

# Définition du fuseau horaire (France)
color_echo "1;32" "\nConfiguration du fuseau horaire..."
timedatectl set-timezone Europe/Paris

# Suppression des paquets anglais obsolètes
color_echo "1;33" "\nSuppression des paquets liés à la langue anglaise..."
apt remove -y manpages-en aspell-en libreoffice-l10n-en > /dev/null

# Désactivation des locales anglaises
color_echo "1;33" "\nDésactivation des locales anglaises..."
sed -i '/en_US.UTF-8 UTF-8/d' /etc/locale.gen
locale-gen

# Redémarrage des services de localisation
color_echo "1;32" "\nRedémarrage des services de localisation..."
systemctl restart systemd-localed

color_echo "1;34" "\n=== Configuration terminée ! ==="
color_echo "1;32" "Votre Kali Linux est maintenant entièrement en français."
color_echo "1;33" "Un redémarrage est recommandé pour appliquer tous les changements."
echo -e "\nVoulez-vous redémarrer maintenant ? (y/n)"
read -r confirm

if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    color_echo "1;32" "\nRedémarrage en cours..."
    reboot
else
    color_echo "1;33" "\nRedémarrage annulé. Pensez à le faire plus tard !"
fi
