#!/bin/bash

# 1. Instalación de LAMP en Ubuntu
echo -e "\n-----------------------------------"
echo "Iniciando la instalación de LAMP..."
echo "-----------------------------------"

# Cargar variables si existen
if [ -f .env ]; then
    source .env
fi

# Actualización paquetes
sudo apt update && sudo apt upgrade -y

# Instalación de los paquetes de LAMP
sudo apt install -y apache2 apache2-utils
sudo apt install -y mysql-server
sudo apt install -y php libapache2-mod-php php-mysql php-cli php-mbstring php-curl php-gd php-zip php-xml

# Copia archivo de configuración Apache
sudo cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf

# 2. Inicialización de los servicios
echo -e "\n--------------------------"
echo "Iniciando los servicios..."
echo "--------------------------"
sudo systemctl start apache2
sudo systemctl start mysql
sudo systemctl enable apache2
sudo systemctl enable mysql

# 3. Configuración de MySQL
echo -e "\n--------------------------------"
echo "Configurando la base de datos..."
echo "--------------------------------"
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '${DB_ROOT_PASSWORD}';" 2>/dev/null || true
sudo mysql -e "FLUSH PRIVILEGES;" 2>/dev/null || true

# Prueba de PHP
echo -e "\n-------------------"
echo "Probando con PHP..."
echo "-------------------"
echo "<?php phpinfo(); ?>" | sudo tee /var/www/html/info.php

# Finalización de instalación
echo -e "\n------------------------------------"
echo "¡LAMP se ha instalado correctamente!"
echo -e "------------------------------------\n"

echo -e "\n--------------"
echo "¡HASTA PRONTO!"
echo -e "--------------\n"
