# 🚀 Switch XFCE to GNOME | Basculer XFCE vers GNOME

![GitHub stars](https://img.shields.io/github/stars/ton-utilisateur/switch-xfce-to-gnome?style=social)
![GitHub forks](https://img.shields.io/github/forks/ton-utilisateur/switch-xfce-to-gnome?style=social)
![GitHub license](https://img.shields.io/github/license/ton-utilisateur/switch-xfce-to-gnome)
![Platform](https://img.shields.io/badge/platform-Kali%20Linux-blue)

## 🌍 Description
### 🇫🇷 Script pour basculer de XFCE à GNOME sous Kali Linux
- Installe et configure GNOME proprement
- Configure `gdm3` comme gestionnaire de session
- 📌 **Fixe les problèmes d'affichage en VM** (VirtualBox, VMware, KVM)
- 🖥️ **Remappe la touche Super (Windows)** pour ouvrir le menu des applications

### 🇬🇧 Script to switch from XFCE to GNOME on Kali Linux
- Installs and configures GNOME properly
- Sets `gdm3` as the default display manager
- 📌 **Fixes display issues in VM** (VirtualBox, VMware, KVM)
- 🖥️ **Maps the Super (Windows) key** to open the application menu

---

## 📥 Installation & Usage
```bash
wget https://raw.githubusercontent.com/ton-utilisateur/switch-xfce-to-gnome/main/switch_xfce_to_gnome.sh
chmod +x switch_xfce_to_gnome.sh
sudo ./switch_xfce_to_gnome.sh
```

---

## 🛠 Fonctionnalités | Features
✅ Installe **GNOME** proprement  
✅ Détecte automatiquement l'environnement **VirtualBox, VMware, KVM** et installe les outils nécessaires  
✅ Désactive la touche Super (Windows) pour **ouvrir directement le menu des applications**  
✅ Offre une **option de mise à jour complète avant redémarrage**  
✅ Permet la **désinstallation de XFCE si l'utilisateur le souhaite**  

---

## ❓ Dépannage | Troubleshooting
### 🌑 Écran noir après connexion ?  
🛠 Essayez ceci :
```bash
sudo dpkg-reconfigure gdm3
sudo reboot
```
Si le problème persiste, utilisez :
```bash
sudo apt install -y kali-desktop-gnome
sudo update-alternatives --set x-session-manager /usr/bin/gnome-session
sudo reboot
```

### 🔄 Restaurer XFCE
```bash
sudo apt install -y kali-desktop-xfce
```

---

## 📜 Licence | License
Ce projet est sous licence **MIT**.

---

## 📢 Contribuer | Contribute
💡 **Toute contribution est la bienvenue !**  
Forkez le dépôt, proposez des **pull requests**, ou ouvrez une **issue** pour signaler un problème.

---

## 🔗 Liens utiles | Useful Links
- 🌐 [Site officiel de GNOME](https://www.gnome.org/)
- 📜 [Documentation Kali Linux](https://www.kali.org/docs/)
