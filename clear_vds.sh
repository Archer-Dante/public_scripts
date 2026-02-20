# Удаляем логи
sudo journalctl --vacuum-size=50M
sudo truncate -s 0 /var/log/btmp 2>/dev/null
sudo find /var/log -name "*.gz" -delete 2>/dev/null
sudo find /var/log -name "*.old" -delete 2>/dev/null

# Удаляем списки 
sudo truncate -s 0 /var/log/btmp

# Ставим fail2ban чтобы btmp более не рос
sudo apt update
sudo apt install fail2ban -y

# Удалить логи ASF
sudo rm -rf "/home/VPS_combined/logs"

# Удалить логи Dropler
sudo rm -rf "/home/dropler_linux/logs"

# чистка apt кэша
sudo apt clean
sudo rm -rf /var/lib/apt/lists/*
sudo apt update
sudo apt autoremove --purge -y

# удаление snap
sudo apt remove snapd -y
sudo apt autoremove -y
sudo apt remove snapd --purge -y
sudo rm -rf /snap /var/snap /var/lib/snapd /var/cache/snapd

# удаление некоторых файлов старых ядер линукс
ls -la /usr/src/
# Удалить всё кроме текущего ядра
CURRENT=$(uname -r)
sudo find /usr/src -maxdepth 1 -type d -name "linux-headers-*" ! -name "*$CURRENT*" -exec rm -rf {} \;

# удаляем прошивки, они не нужны для серверов
sudo rm -rf /usr/lib/firmware/*

# удаление всех ядер кроме текущего
CURRENT=$(uname -r)
for pkg in $(dpkg --list | grep linux-image | grep "^ii" | awk '{print $2}' | grep -v "$CURRENT"); do
    echo "🗑️ Удаляю $pkg..."
    sudo apt remove --purge -y "$pkg"
done

# удаляем APT кэш
sudo apt clean
sudo rm -rf /var/lib/apt/lists/*
sudo apt update -qq

# удаляем.документации (опционально)
sudo rm -rf /usr/share/doc/* /usr/share/man/* /usr/share/info/* 2>/dev/null

# выставляем 2гб свап
sudo swapoff -a && sudo sed -i.bak '/swap/d' /etc/fstab && sudo rm -f /swapfile && sudo fallocate -l 2G /swapfile && sudo chmod 600 /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile && echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab