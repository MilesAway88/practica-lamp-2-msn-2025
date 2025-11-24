# Práctica LAMP 2 (LAMP en EC2)

## Descripción
En esta tarea aprendemos a automatizar la instalación y despliegue de una pila LAMP y otras herramientas adicionales en una instancia EC2 de AWS con Ubuntu Server.

## Despliegue en local

1. Clonar los archivos del [proyecto][1]

2. Añadir permisos de ejecución a los scripts:<br>
    `chmod +x install-lamp.sh install-tools.sh`

3. (Opcional) Modificar archivo .env con datos personalizados

4. Ejecutar archivo de instalación:<br>
    `sudo ./install-lamp.sh`

5. Ejecutar archivo de despliegue:<br>
    `sudo ./install-tools.sh`

6. Comprobar funcionamiento en el navegador:<br>
    Ir a `http://localhost`

## Despliegue en AWS EC2

### Configuración de la instancia:
- **AMI:** Debian 13 (fijarse en el **"Nombre de usuario"** al seleccionarlo)
- **Tipo:** t3.micro
- **Par de claves:** Crear uno nuevo (RSA > .pem) o usar uno ya creado<br>
    - *Se recomienda guardarlo en directorio **~/.ssh***
- **Grupos de Seguridad:** Puertos 22 (SSH), 80 (HTTP), 443 (HTTPS) abiertos
- **IP Elástica:** [Tu IP elástica] (se asignará después)

### Pasos a seguir:
1. Crear instancia EC2 con Debian<br>
    - **Importante:** Configurar bien los grupos de seguridad

2. Asignar una IP Elástica:
    - Menú lateral > Red y seguridad > Direcciones IP elásticas > Asignar dirección IP elástica
    - **Importante:** Comprobar que realmente esté asignada a la instancia (pincha en la dirección IPv4)

3. Conectar por SSH: `ssh -i ~/.ssh/{TU_PAR_DE_CLAVES.PEM} {USUARIO}@{IP_ELASTICA}`
    - *Si tu usuario es "admin":* `ssh -i ~/.ssh/{TU_PAR_DE_CLAVES.PEM} admin@{IP_ELASTICA}`
    - *Si tu usuario es "ec2-user":* `ssh -i ~/.ssh/{TU_PAR_DE_CLAVES.PEM} ec2-user@{IP_ELASTICA}`

4. Clonar [repositorio][1]:<br>
    `git clone {url_repositorio}`

5. (Opcional) Modificar el fichero *.env.example*
    - **Importante:** Poner la IP elástica en la variable *SERVER_IP*

6. Añadir permisos de ejecución a los scripts:<br>
    `chmod +x install-lamp.sh install-tools.sh`

7. Ejecutar archivo de instalación:<br>
    `sudo ./install-lamp.sh`

8. Ejecutar archivo de despliegue:<br>
    `sudo ./install-tools.sh`

9. Comprobar funcionamiento en el navegador:<br>
    Ir a `http://{IP_ELASTICA}`

---

>**Notas sobre la práctica**
>---------------------------
>
>- Se instala *mariadb-server* porque en Debian moderno, *mysql-server* ha sido reemplazado por el primero.
>
>- Al instalar *mariadb-server*, automáticamente instala también *mariadb-cliente*, y crea un enlace simbólico entre `mysql` y `mariadb`.
>
>- La instalación de MariaDB en Debian ya es segura, por lo que no hace falta usar `mariadb-secure-installation`.
>
>- El comando `2>/dev/null || true` sirve para que no muestre un error, en caso de darlo, que sería en segundas instalaciones ya que *root* ya tendría contraseña.
>
>- No hace falta usar `a2enmod` con PHP en versiones modernas, ya que el módulo se habilita automáticamente al instalar `libapache2-mod-php`.
>
>- No hace falta usar `a2ensite` ya que el archivo `000-default.conf` ya viene habilitado por defecto.
>
>- Hay que cambiar propietario y dar permisos a Apache para que pueda ejecutar los scripts (usuario *www-data*)

---

[1]: https://github.com/MilesAway88/practica-lamp-2-msn-2025
[2]: 