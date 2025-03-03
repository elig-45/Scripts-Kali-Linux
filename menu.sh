#!/bin/bash
# Menu principal pour exécuter les différents scripts disponibles pour Kali Linux

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

# Télécharger et donner les permissions d'exécution aux scripts
color_echo "1;34" "\nTéléchargement des scripts et attribution des permissions d'exécution..."
wget -q https://raw.githubusercontent.com/elig-45/switch-xfce-to-gnome/main/switch_xfce_to_gnome.sh -O switch_xfce_to_gnome.sh
wget -q https://raw.githubusercontent.com/elig-45/switch-xfce-to-gnome/main/kali_en_to_fr.sh -O kali_en_to_fr.sh
wget -q https://raw.githubusercontent.com/elig-45/switch-xfce-to-gnome/main/xfce_cleaner.sh -O xfce_cleaner.sh
wget -q https://raw.githubusercontent.com/elig-45/switch-xfce-to-gnome/main/ssh_setup.sh -O ssh_setup.sh
chmod +x switch_xfce_to_gnome.sh kali_en_to_fr.sh xfce_cleaner.sh ssh_setup.sh

# Affichage du menu principal
while true; do
    clear
    color_echo "1;34" "\n=== Menu Principal ===\n"
    echo "1) Basculer de XFCE à GNOME"
    echo "2) Configurer Kali Linux en français"
    echo "3) Optimiser le stockage et nettoyer les anciennes dépendances XFCE"
    echo "4) Quitter"
    echo -n "Choisissez une option : "
    read -r option

    case $option in
        1)
            color_echo "1;32" "\nExécution du script pour basculer de XFCE à GNOME..."
            /bin/bash ./switch_xfce_to_gnome.sh
            ;;
        2)
            color_echo "1;32" "\nExécution du script pour configurer Kali Linux en français..."
            /bin/bash ./kali_en_to_fr.sh
            ;;
        3)
            color_echo "1;32" "\nExécution du script pour optimiser le stockage et nettoyer les anciennes dépendances XFCE..."
            /bin/bash ./xfce_cleaner.sh
            ;;
        4)
            color_echo "1;32" "\nQuitter le menu. Au revoir !"
            exit 0
            ;;
        *)
            color_echo "1;31" "\nOption invalide. Veuillez réessayer."
            ;;
    esac

    echo -n "Appuyez sur une touche pour continuer..."
    read -r -n 1
done
