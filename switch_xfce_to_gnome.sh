#!/bin/bash

# Vérifier si l'utilisateur est root
if [ "$EUID" -ne 0 ]; then
  zenity --error --text="Veuillez exécuter ce script en tant que root (sudo)." --title="Erreur"
  exit 1
fi

# Correction des problèmes de Zenity sous VirtualBox et autres environnements VM
export XDG_RUNTIME_DIR=/run/user/$(id -u)
export NO_AT_BRIDGE=1

# Vérifier si l'option --text est passée en argument
FORCE_TEXT_MODE=false
for arg in "$@"; do
  if [ "$arg" = "--text" ]; then
    FORCE_TEXT_MODE=true
  fi
done

# Vérifier si un affichage graphique est disponible ou si le mode texte est forcé
if [ -z "$DISPLAY" ] || [ "$FORCE_TEXT_MODE" = true ]; then
    echo "Mode texte activé. Zenity ne sera pas utilisé."
    export ZENITY_MODE="text"
else
    export ZENITY_MODE="gui"
fi

# S'assurer que les Additions Invité VirtualBox ou les outils VM sont bien installés
if lspci | grep -qi virtualbox; then
    echo "Détection d'un environnement VirtualBox, installation des Additions Invité..."
    sudo apt install -y virtualbox-guest-utils virtualbox-guest-x11 > /dev/null 2>&1
elif lspci | grep -qi vmware; then
    echo "Détection d'un environnement VMware, installation des outils VMware..."
    sudo apt install -y open-vm-tools-desktop > /dev/null 2>&1
elif systemd-detect-virt | grep -qi kvm; then
    echo "Détection d'un environnement KVM/QEMU, installation des outils KVM..."
    sudo apt install -y spice-vdagent > /dev/null 2>&1
fi

# Configurer la touche Super pour ouvrir directement le menu des applications
echo "Configuration de la touche Super pour ouvrir le menu des applications..."
gsettings set org.gnome.mutter overlay-key ''
gsettings set org.gnome.shell.keybindings show-apps "['Super_L']"

# Fonction pour afficher une barre de progression
display_progress() {
  local duration=$1
  local step=0
  local total_steps=100
  if [ "$ZENITY_MODE" = "gui" ]; then
    (
      while [ $step -le $total_steps ]; do
        echo $step
        echo "# Progression : $step%"
        sleep $(awk "BEGIN {print $duration / $total_steps}")
        step=$((step + 2))
      done
    ) | zenity --progress --title="Installation en cours" --text="Veuillez patienter..." --percentage=0 --auto-close --no-cancel --pulsate 2>/dev/null || echo "Progression en mode texte..."
  else
    echo -ne "["
    for ((i = 0; i < total_steps; i++)); do
      sleep $(awk "BEGIN {print $duration / $total_steps}")
      echo -ne "#"
    done
    echo "] Terminé."
  fi
}

# Estimation du temps en secondes pour chaque étape
UPDATE_TIME=10
INSTALL_TIME=20
CONFIG_TIME=5
REMOVE_TIME=15
FULL_UPDATE_TIME=30
TOTAL_TIME=$((UPDATE_TIME + INSTALL_TIME + CONFIG_TIME + REMOVE_TIME))

# Affichage initial du temps estimé
if [ "$ZENITY_MODE" = "gui" ]; then
  zenity --info --text="Temps total estimé : $TOTAL_TIME secondes" --title="Informations" --ok-label="D'accord" 2>/dev/null || echo "Temps total estimé : $TOTAL_TIME secondes"
else
  echo "Temps total estimé : $TOTAL_TIME secondes"
fi

# Demande de mise à jour complète du système avant redémarrage
if [ "$ZENITY_MODE" = "gui" ]; then
  if zenity --question --text="Voulez-vous mettre à jour tous les paquets et la distribution avant de redémarrer ?" --title="Mise à jour complète" --ok-label="Oui" --cancel-label="Non" 2>/dev/null; then
    echo "Mise à jour complète en cours..."
    display_progress $FULL_UPDATE_TIME
    apt full-upgrade -y && apt autoremove -y > /dev/null 2>&1
  fi
else
  read -p "Voulez-vous mettre à jour tous les paquets et la distribution avant de redémarrer ? (y/N): " response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Mise à jour complète en cours..."
    display_progress $FULL_UPDATE_TIME
    apt full-upgrade -y && apt autoremove -y > /dev/null 2>&1
  fi
fi

# Mise à jour des dépôts
echo "Mise à jour du système..."
display_progress $UPDATE_TIME
apt update -y && apt upgrade -y > /dev/null 2>&1

# Installation de GNOME
echo "Installation de GNOME..."
display_progress $INSTALL_TIME
apt install -y kali-desktop-gnome > /dev/null 2>&1

# Configuration de GDM comme gestionnaire de session
echo "Configuration de GDM..."
display_progress $CONFIG_TIME
DEBIAN_FRONTEND=noninteractive dpkg-reconfigure gdm3 > /dev/null 2>&1

# Optionnel : Désinstallation de XFCE
if [ "$ZENITY_MODE" = "gui" ]; then
  if zenity --question --text="Voulez-vous désinstaller XFCE ?" --title="Suppression XFCE" --ok-label="Oui" --cancel-label="Non" 2>/dev/null; then
    echo "Suppression de XFCE..."
    display_progress $REMOVE_TIME
    apt remove --purge -y xfce4 xfce4-* > /dev/null 2>&1
    apt autoremove -y > /dev/null 2>&1
  fi
else
  read -p "Voulez-vous désinstaller XFCE ? (y/N): " response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Suppression de XFCE..."
    display_progress $REMOVE_TIME
    apt remove --purge -y xfce4 xfce4-* > /dev/null 2>&1
    apt autoremove -y > /dev/null 2>&1
  fi
fi

# Optionnel : Exécution du script xfce_cleaner.sh pour optimiser le stockage
if [ "$ZENITY_MODE" = "gui" ]; then
  if zenity --question --text="Voulez-vous optimiser le stockage et nettoyer les anciennes dépendances XFCE ?" --title="Optimisation du stockage" --ok-label="Oui" --cancel-label="Non" 2>/dev/null; then
    echo "Optimisation du stockage et nettoyage des anciennes dépendances XFCE..."
    /bin/bash /c:/Users/Eli/Desktop/Dev/switch-xfce-to-gnome/xfce_cleaner.sh
  fi
else
  read -p "Voulez-vous optimiser le stockage et nettoyer les anciennes dépendances XFCE ? (y/N): " response
  if [[ "$response" =~ ^[Yy]$ ]]; then
    echo "Optimisation du stockage et nettoyage des anciennes dépendances XFCE..."
    /bin/bash ./xfce_cleaner.sh
  fi
fi

# Redémarrage nécessaire
if [ "$ZENITY_MODE" = "gui" ]; then
  if zenity --question --text="L'installation est terminée. Voulez-vous redémarrer maintenant ?" --title="Redémarrage" --ok-label="Redémarrer" --cancel-label="Annuler" 2>/dev/null; then
    reboot
  else
    zenity --info --text="Vous pouvez redémarrer plus tard." --title="Redémarrage reporté" --ok-label="D'accord"
  fi
else
  echo "Installation terminée. Redémarrage dans 5 secondes..."
  sleep 5
  reboot
fi
