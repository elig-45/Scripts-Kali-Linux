#!/bin/bash
# Script pour configurer Kali Linux entièrement en français
# et désinstaller la langue anglaise.

# Fonction d'affichage coloré
function color_echo() {
    local color_code="$1"
    local message="$2"
    echo -e "\033[${color_code}m${message}\033[0m"
}

# Vérification des droits d'administration
if [ "$EUID" -ne 0 ]; then
    color_echo "1;31" "Veuillez exécuter ce script en tant que root (sudo)."
    exit 1
fi

color_echo "1;34" "\n=== Configuration complète de Kali Linux en français ===\n"

# Vérification de l'espace disponible
REQUIRED_SPACE_MB=600
AVAILABLE_SPACE_MB=$(df /var/cache/apt/archives | tail -1 | awk '{print $4}')
if (( AVAILABLE_SPACE_MB < REQUIRED_SPACE_MB * 1024 )); then
    color_echo "1;31" "Pas assez d'espace disponible sur /var/cache/apt/archives. Veuillez libérer de l'espace et réessayer."
    exit 1
fi

# Mise à jour des paquets
color_echo "1;32" "\nMise à jour de la liste des paquets..."
apt update -y && apt upgrade -y

# Installation des paquets de langue française
color_echo "1;32" "\nInstallation des paquets de langue française..."
apt install -y locales-all manpages-fr aspell-fr libreoffice-l10n-fr

# Configuration des locales
color_echo "1;32" "\nConfiguration des locales en français..."
sed -i 's/^# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
update-locale LANG=fr_FR.UTF-8

# Définition du clavier en français (AZERTY)
color_echo "1;32" "\nConfiguration du clavier en français (AZERTY)..."
setxkbmap fr
echo 'XKBLAYOUT="fr"' > /etc/default/keyboard
dpkg-reconfigure -f noninteractive keyboard-configuration

# Définition du fuseau horaire (France)
color_echo "1;32" "\nConfiguration du fuseau horaire..."
timedatectl set-timezone Europe/Paris

# Suppression de la langue anglaise
color_echo "1;33" "\nSuppression des paquets liés à la langue anglaise..."
apt remove -y manpages-en aspell-en libreoffice-l10n-en

# Suppression des locales anglaises
color_echo "1;33" "\nDésactivation des locales anglaises..."
sed -i '/en_US.UTF-8 UTF-8/d' /etc/locale.gen
locale-gen

# Redémarrage du service de localisation
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
