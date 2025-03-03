![Switch XFCE to GNOME](banner.jpeg)

# 🚀 Switch XFCE to GNOME | Basculer XFCE vers GNOME

[![GitHub stars](https://img.shields.io/github/stars/elig-45/switch-xfce-to-gnome?style=social)](https://github.com/elig-45/switch-xfce-to-gnome/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/elig-45/switch-xfce-to-gnome?style=social)](https://github.com/elig-45/switch-xfce-to-gnome/network/members)
[![GitHub license](https://img.shields.io/github/license/elig-45/switch-xfce-to-gnome)](https://github.com/elig-45/switch-xfce-to-gnome/blob/main/LICENSE)
[![Platform](https://img.shields.io/badge/platform-Kali%20Linux-blue)](https://www.kali.org/)

---

## 🌍 Description

### 🇫🇷 Français

Ce script permet de basculer de **XFCE à GNOME** sous **Kali Linux** tout en **corrigeant les erreurs liées à VirtualBox, VMware et KVM**.

### 🇬🇧 English

This script allows switching from **XFCE to GNOME** on **Kali Linux**, while **fixing issues related to VirtualBox, VMware, and KVM**.

---

## 📥 Installation & Usage

```bash
wget https://raw.githubusercontent.com/elig-45/switch-xfce-to-gnome/main/switch_xfce_to_gnome.sh
chmod +x switch_xfce_to_gnome.sh
chmod +x xfce_cleaner.sh
sudo ./switch_xfce_to_gnome.sh
```

---

## 🛠 Fonctionnalités | Features

### 🇫🇷 Français
✅ Installe **GNOME** proprement  
✅ Détecte automatiquement l'environnement **VirtualBox, VMware, KVM** et installe les outils nécessaires  
✅ Désactive la touche **Super (Windows)** pour **ouvrir directement le menu des applications**  
✅ Offre une **option de mise à jour complète avant redémarrage**  
✅ Permet la **désinstallation de XFCE si l'utilisateur le souhaite**  
✅ **Optimise le stockage et nettoie les anciennes dépendances XFCE**  

### 🇬🇧 English
✅ Installs **GNOME** properly  
✅ Automatically detects **VirtualBox, VMware, KVM** environments and installs required tools  
✅ Disables the **Super (Windows) key** to **directly open the application menu**  
✅ Provides an **option for full system update before reboot**  
✅ Allows **XFCE removal if desired**  
✅ **Optimizes storage and cleans up old XFCE dependencies**  

---

## ❓ Dépannage | Troubleshooting

### 🌑 🇫🇷 Écran noir après connexion ?  
```bash
sudo dpkg-reconfigure gdm3
sudo reboot
```

Si le problème persiste, essayez ceci :
```bash
sudo apt install -y kali-desktop-gnome
sudo update-alternatives --set x-session-manager /usr/bin/gnome-session
sudo reboot
```

### 🌑 🇬🇧 Black screen after login?  
```bash
sudo dpkg-reconfigure gdm3
sudo reboot
```

If the issue persists, try:
```bash
sudo apt install -y kali-desktop-gnome
sudo update-alternatives --set x-session-manager /usr/bin/gnome-session
sudo reboot
```

### 🔄 🇫🇷 Restaurer XFCE  🇬🇧 Restore XFCE  
```bash
sudo apt install -y kali-desktop-xfce
```

---

## 📜 Licence | License

### 🇫🇷 Français
Ce projet est sous licence **MIT**.

### 🇬🇧 English
This project is licensed under **MIT**.

---

## 📢 Contribuer | Contribute

### 🇫🇷 Français
💡 **Toute contribution est la bienvenue !**  
Forkez le dépôt, proposez des **pull requests**, ou ouvrez une **issue** pour signaler un problème.

### 🇬🇧 English
💡 **Contributions are welcome!**  
Fork the repository, submit **pull requests**, or open an **issue** to report any problem.

---

## 🔗 Liens utiles | Useful Links

- 🌐 [Site officiel de GNOME](https://www.gnome.org/)
- 📜 [Documentation Kali Linux](https://www.kali.org/docs/)
