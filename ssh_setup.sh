#!/bin/bash
# Script pour activer et sécuriser le serveur SSH sous Kali Linux

# Fonction pour afficher des messages en couleur
function color_echo() {
    local color_code="$1"
    local message="$2"
    echo -e "\033[${color_code}m${message}\033[0m"
}

# Vérification des privilèges root
if [ "$EUID" -ne 0 ]; then
    color_echo "1;31" "Veuillez exécuter ce script en tant que root (sudo)."
    exit 1
fi

color_echo "1;34" "\n=== Activation et configuration de SSH ===\n"

# Demande à l'utilisateur de saisir le port SSH souhaité
read -p "Entrez le port SSH souhaité (par défaut 22): " ssh_port
ssh_port=${ssh_port:-22}

# Installation de SSH si non installé
if ! command -v sshd &> /dev/null; then
    color_echo "1;33" "Installation du serveur SSH..."
    apt install -y openssh-server > /dev/null
fi

# Activation et démarrage du service SSH
color_echo "1;32" "Activation et démarrage de SSH..."
systemctl enable ssh > /dev/null
systemctl start ssh > /dev/null

# Configuration sécurisée du fichier /etc/ssh/sshd_config
color_echo "1;32" "Sécurisation de SSH..."
sed -i 's/#Port .*/Port '"$ssh_port"'/' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin .*/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/#PasswordAuthentication .*/PasswordAuthentication no/' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication .*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/#X11Forwarding .*/X11Forwarding no/' /etc/ssh/sshd_config

# Redémarrage du service SSH
color_echo "1;32" "Redémarrage du service SSH..."
systemctl restart ssh > /dev/null

color_echo "1;34" "\n=== Configuration terminée ! ==="
color_echo "1;32" "Le serveur SSH est maintenant actif et sécurisé."
color_echo "1;33" "L'authentification par mot de passe est désactivée."
color_echo "1;33" "Seule l'authentification par clé SSH est autorisée."
color_echo "1;31" "⚠️ Pensez à ajouter votre clé publique avant de fermer la session !"
