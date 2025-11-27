#!/bin/bash

# Instalación de otras herramientas prueba
echo "--------------------------------------"
echo "Instalando herramientas adicionales..."
echo "--------------------------------------"

if [ -f .env ]; then
    source .env
fi

# 1. Creación y permisos del directorio para estadísticas
sudo mkdir -p /var/www/html/stats
sudo chown -R www-data:www-data /var/www/html/stats
sudo chmod 755 /var/www/html/stats

# 2. Instalación y configuración de phpMyAdmin
echo -e "\n------------------------"
echo "Instalando phpMyAdmin..."
echo "------------------------"

echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password ${DB_ROOT_PASSWORD}" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password ${DB_ROOT_PASSWORD}" | sudo debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password ${DB_ROOT_PASSWORD}" | sudo debconf-set-selections

sudo apt install -y phpmyadmin
sudo phpenmod mbstring

# 3. Instalación y configuración de Adminer
echo -e "\n---------------------"
echo "Instalando Adminer..."
echo "---------------------"

sudo wget https://www.adminer.org/latest.php -O /var/www/html/adminer.php
sudo chown www-data:www-data /var/www/html/adminer.php
sudo chmod 644 /var/www/html/adminer.php

# 4. Instalación de GoAccess
echo -e "\n----------------------"
echo "Instalando GoAccess..."
echo "----------------------"

sudo apt install -y goaccess

# Generar reporte con GoAccess + permisos
sudo goaccess /var/log/apache2/access.log -o /var/www/html/stats/index.html --log-format=COMBINED --real-time-html
sudo chown www-data:www-data /var/www/html/stats/index.html
sudo chmod 644 /var/www/html/stats/index.html

# 5. Configuración de .htaccess
echo -e "\n------------------------------------"
echo "Configurando el archivo .htaccess..."
echo "------------------------------------"

# Activar módulo rewrite
sudo a2enmod rewrite

# Configurar autenticación
sudo tee /var/www/html/stats/.htaccess > /dev/null <<EOF
AuthType Basic
AuthName "Acceso restringido"
AuthUserFile /etc/apache2/.htpasswd
Require valid-user
EOF

# Permisos .htaccess
sudo chown www-data:www-data /var/www/html/stats/.htaccess
sudo chmod 644 /var/www/html/stats/.htaccess

# Creación de usuario (solo si no existe)
if [ ! -f /etc/apache2/.htpasswd ] ; then
    sudo htpasswd -cb /etc/apache2/.htpasswd $STATS_USER $STATS_PASSWORD
else
    sudo htpasswd -b /etc/apache2/.htpasswd $STATS_USER $STATS_PASSWORD
fi

# Permisos .htpasswd
sudo chown root:www-data /etc/apache2/.htpasswd
sudo chmod 640 /etc/apache2/.htpasswd

# Reinicio del servidor
sudo systemctl restart apache2

# 6. Fin de instalación
echo -e "\n--------------------------------------"
echo "¡INSTALACIÓN FINALIZADA CORRECTAMENTE!"
echo -e "--------------------------------------\n"
echo "Para ver las herramientas instaladas:"
echo "   • phpMyAdmin → http://TU_IP/phpmyadmin"
echo "   • Adminer → http://TU_IP/adminer.php"
echo -e "   • GoAccess → http://TU_IP/stats/\n"

echo -e "\n--------------"
echo "¡HASTA PRONTO!"
echo -e "--------------\n"
