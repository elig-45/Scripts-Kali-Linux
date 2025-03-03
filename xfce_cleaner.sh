#!/bin/bash
# Script d'optimisation de stockage pour Kali Linux
# Ce script met à jour les paquets, nettoie les caches et supprime
# les anciens paquets (ici les paquets XFCE) ainsi que leurs dépendances inutiles.
# Il affiche également l'espace libre avant et après l'exécution pour montrer la différence.
# Exécutez-le en tant que root (ou avec sudo).

# Fonction pour afficher un message en couleur
function color_echo() {
    local color_code="$1"
    local message="$2"
    echo -e "\033[${color_code}m${message}\033[0m"
}

# Vérification des privilèges root
if [ "$EUID" -ne 0 ]; then
    color_echo "1;31" "Veuillez exécuter ce script en tant que root ou avec sudo."
    exit 1
fi

# Définir le point de montage à surveiller (ici "/")
MOUNT_POINT="/"

# Récupérer l'espace libre en Ko avant nettoyage
free_before=$(df --output=avail "$MOUNT_POINT" | tail -n1 | tr -d ' ')

# Conversion en format lisible (optionnel, nécessite numfmt)
free_before_hr=$(numfmt --to=iec-i --suffix=B "$free_before")

color_echo "1;34" "\n=== Optimisation du stockage sur Kali Linux ===\n"
color_echo "1;32" "Espace libre avant optimisation : $free_before_hr"

# Mise à jour de la liste des paquets
color_echo "1;32" "\nMise à jour de la liste des paquets..."
apt update

# Nettoyage du cache des paquets
color_echo "1;32" "\nNettoyage du cache des paquets..."
apt-get autoclean -y

# Suppression des paquets et dépendances inutilisés
color_echo "1;32" "\nSuppression des dépendances et paquets inutilisés..."
apt-get autoremove -y

# Détection des paquets XFCE installés
color_echo "1;32" "\nRecherche des paquets relatifs à XFCE..."
xfce_packages=$(dpkg -l | grep -i xfce | awk '{print $2}')

if [ -n "$xfce_packages" ]; then
    color_echo "1;33" "\nLes paquets XFCE suivants ont été détectés :"
    echo "$xfce_packages"
    echo ""
    color_echo "1;33" "Voulez-vous supprimer ces paquets ? (y/n)"
    read -r confirm
    if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
        color_echo "1;32" "\nSuppression des paquets XFCE..."
        for pkg in $xfce_packages; do
            apt-get purge -y "$pkg"
        done
        color_echo "1;32" "\nNettoyage des dépendances restantes..."
        apt-get autoremove -y
    else
        color_echo "1;31" "\nSuppression des paquets XFCE annulée."
    fi
else
    color_echo "1;32" "\nAucun paquet XFCE n'a été détecté."
fi

# Récupérer l'espace libre en Ko après nettoyage
free_after=$(df --output=avail "$MOUNT_POINT" | tail -n1 | tr -d ' ')
free_after_hr=$(numfmt --to=iec-i --suffix=B "$free_after")

# Calcul de la différence d'espace (en Ko)
gain_kb=$(( free_after - free_before ))
gain_hr=$(numfmt --to=iec-i --suffix=B "$gain_kb")

color_echo "1;34" "\n=== Optimisation terminée. ==="
color_echo "1;32" "Espace libre après optimisation : $free_after_hr"
color_echo "1;32" "Gain d'espace : $gain_hr"
