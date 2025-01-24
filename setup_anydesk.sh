#!/bin/bash
echo "
 SSSSSSS  EEEEEEE  RRRRRR   HHH   HHH IIIIIIII IIIIIIII
 SSS      EEE      RRR  RR  HHH   HHH    III     III
 SSSSSS   EEEEE    RRRRRR   HHHHHHHHH    III     III
     SSS  EEE      RRR  RR  HHH   HHH    III     III
 SSSSSSS  EEEEEEE  RRR   RR HHH   HHH IIIIIIII IIIIIIII

 SSSSSSS  HHH   HHH YYY   YYY PPPPPP   YYY   YYY LLL      OOOOOOO  VVV     VVV
 SSS      HHH   HHH  YYY YYY  PPP  PP   YYY YYY  LLL      OOO OOO   VVV   VVV
 SSSSSS   HHHHHHHHH   YYYYY   PPPPPP     YYYYY   LLL      OOO OOO    VVV VVV
     SSS  HHH   HHH    YYY    PPP        YYY     LLL      OOO OOO     VVVV
 SSSSSSS  HHH   HHH    YYY    PPP        YYY     LLLLLLL  OOOOOOO      VV

      11   iii tttttttt      pppppp  rrrrrrr   ooooooo
      11         ttt         pp   pp rr   rr  oo     oo
      11   iii   ttt   ..... pppppp  rr  rrr  oo     oo
      11   iii   ttt         pp      rr   rr  oo     oo
      11   iii   ttt         pp      rr    rr  ooooooo
"
# Скрипт для настройки AnyDesk на Ubuntu 22.04
# Отключает Wayland, настраивает автологин и перезагружает систему

set -e

# Переменные
GDM_CONFIG="/etc/gdm3/custom.conf"
USERNAME=$(whoami)

# Функция для проверки root-прав
check_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "❌ Скрипт необходимо запускать с правами root. Используйте: sudo ./setup_anydesk.sh"
        exit 1
    fi
}

## Установка AnyDesk
#install_anydesk() {
#    echo "📥 Установка AnyDesk..."
#    wget https://download.anydesk.com/linux/anydesk_6.3.0-1_amd64.deb -O /tmp/anydesk.deb
#    apt install -y /tmp/anydesk.deb
#    apt install -f -y
#    systemctl enable anydesk
#    systemctl start anydesk
#    echo "✅ AnyDesk установлен и запущен."
#}

# Отключение Wayland и включение автологина
configure_gdm() {
    echo "⚙️ Настройка GDM3..."
    if [ -f "$GDM_CONFIG" ]; then
        sed -i '/^#WaylandEnable=/ s/^#//' $GDM_CONFIG
        sed -i 's/WaylandEnable=true/WaylandEnable=false/' $GDM_CONFIG
        if ! grep -q "AutomaticLogin=$USERNAME" $GDM_CONFIG; then
            echo "AutomaticLoginEnable=true" >> $GDM_CONFIG
            echo "AutomaticLogin=$USERNAME" >> $GDM_CONFIG
        fi
        echo "✅ GDM3 настроен: отключен Wayland и включен автологин для пользователя $USERNAME."
    else
        echo "❌ Файл $GDM_CONFIG не найден. Проверьте правильность пути."
        exit 1
    fi
}

# Разрешение доступа AnyDesk к экрану
configure_display_access() {
    echo "🔑 Разрешение доступа AnyDesk к экрану..."
    xhost +SI:localuser:root
    echo "✅ Доступ к экрану разрешен."
}

## Открытие портов для AnyDesk
#configure_firewall() {
#    echo "🛡️ Настройка брандмауэра..."
#    ufw allow 7070
#    ufw allow 80
#    ufw allow 443
#    ufw reload
#    echo "✅ Порты для AnyDesk открыты."
#}

# Перезагрузка системы
reboot_system() {
    echo "🔄 Перезагрузка системы через 5 секунд..."
    sleep 5
    reboot
}

# Основная программа
main() {
    check_root
#    install_anydesk
    configure_gdm
    configure_display_access
#    configure_firewall
    reboot_system
}

# Запуск скрипта
main
