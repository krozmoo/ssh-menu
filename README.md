# ssh-menu
Creacion de Menu Conexion SSH

La finalidad de este tutorial es crear un solo punto de acceso desde una terminal SSH para conectarnos a diferentes servidores desde este unico punto de acceso de manera segura y con menos procesos. (Como concepto de PIVOTE).

Primera Parte (Llaves SSH)

Generar par de claves SSH:
Desde tu maquina local o servidores PIVOTE, abrir una terminal y ejecuta el siguiente comando para generar un par de claves SSH:
ssh-keygen -t rsa
Al dar “enter” se solicitara primero que indiquemos la ubicacion de la clave privada y pública. De manera predeterminada la ubicación es “~/.ssh/id_rsa”, una buena practica es cambiarla de ubicacion pero de momento la dejaremos en dicha ruta. Como segunda opcion nos pedira crear una contraseña para la llave y confirmarla.
El resultado deberia ser algo asi:
llave ssh.png

Copiar la llave publica al servidor que deseamos conectarnos, con el comando ssh-copy-id (el usuario user debe ser remplazado con el que tengan creado en el destino).
ssh-copy-id user@192.168.0.100
Nota: Por temas de seguridad no subo la evidencia de la copia debido a que cuenta con información sensible de mi infraestructura.

Segunda Parte (Crear Menu en Bash)

El menu que crearemos consta con las siguientes caracteristicas:

Posee un menu principal que consta de 3 opciones (Produccion, Desarrollo y QA) esto es llamado los ambientes a los que nos queremos conectar.
Al ingresar a cada una de estos ambientes constaran con una sub-selección, indicando la lista de servidores que posee el ambiente a cual nos podemos conectar.
Inicialmente debemos definir donde quedara almacenado este scripts en bash, mi recomendación es crear una carpeta con un nombre llamado scripts y en ella almacenar todos los scripts futuros que realices, en mi caso ficticio creare en /home/scritps/ el archivo llamado “ssh-menu.sh”

#vim ssh-menu.sh

<script>
#!/bin/bash

# Función de conexion ssh (El parametro $1 se reemplazara por la ip del servidor que queramos acceder)
function connect_ssh() {
  ssh -i ~/.ssh/id_rsa/clave_privada user@$1
}

# Función para mostrar el menú del ambiente de producción
function show_production_submenu() {
  PS3="Seleccione un servidor para el ambiente Produccion: "
  select server_option in "${!production_servers[@]}"; do
    server=${production_servers[$server_option]}
    if [ -n "$server" ]; then
      connect_ssh $server
      break
    else
      echo "Opción inválida. Intente nuevamente."
    fi
  done
}

# Función para mostrar el menú del ambiente de Desarrollo
function show_desarrollo_submenu() {
  PS3="Seleccione un servidor para el ambiente Desarrollo: "
  select server_option in "${!desarrollo_servers[@]}"; do
    server=${desarrollo_servers[$server_option]}
    if [ -n "$server" ]; then
      connect_ssh $server
      break
    else
      echo "Opción inválida. Intente nuevamente."
    fi
  done
}

# Función para mostrar el menú del ambiente de QA
function show_qa_submenu() {
  PS3="Seleccione un servidor para el ambiente QA: "
  select server_option in "${!qa_servers[@]}"; do
    server=${qa_servers[$server_option]}
    if [ -n "$server" ]; then
      connect_ssh $server
      break
    else
      echo "Opción inválida. Intente nuevamente."
    fi
  done
}

# Definir servidores de producción con Nombres (Estos pueden ser cambiados a unos mas descriptivos)
declare -A production_servers=(
  ["Servidor 1"]="192.168.0.100"
  ["Servidor 2"]="192.168.0.101"
  ["Servidor 3"]="192.168.0.102"
  ["Servidor 4"]="192.168.0.103"
)

# Definir servidores de Desarrollo
declare -A desarrollo_servers=(
  ["Servidor 1"]="172.16.95.4"
  ["Servidor 2"]="172.16.95.10"
)

# Definir servidores de QA
declare -A qa_servers=(
  ["Servidor 1"]="192.168.0.115"
  ["Servidor 2"]="192.168.0.125"
)

# Menú principal
PS3="Seleccione un ambiente: "
select ambiente in "Produccion" "Desarrollo" "QA"; do
  case $ambiente in
    "Produccion")
      show_production_submenu
      break
      ;;
    "Desarrollo")
      show_desarrollo_submenu
      break
      ;;
    "QA")
      show_qa_submenu
      break
      ;;
    *)
      echo "Opción inválida. Intente nuevamente."
      ;;
  esac
done
  
</script>

Tercera Parte (Permisos)

Para poder ejecutar el scritps creado debemos darle permisos de ejecuccion esto se puede lograr con el comando:

chmod +x ssh-menu.sh
Tercera Parte (variable de Entorno)

Para poder acceder de manera rapida a nuestro menu podemos crear una variable de entorno que ejecute dicho escripts de manera rapida:

Primero accederemos a .bashrc (Esto se ha visto dentro de los cursos de Platzi)

vim .bashrc
dentro de nuestro archivo crearemos el alias

alias sshmenu='sh /scritps/ssh-menu.sh'
Guardamos y salimos del editor de texto vim con esc + : + wq!

Ejecutamos por ultimo el comando

bash 
Y ya con escribir sshmenu se nos abrira nuestro programa creado para conectarnos a diferentes servidores de manera rapida.

Consideraciones:

Cuando creamos la llave ssh deberemos ingresarla al acceder a cada servidor, esto se puede automatizar mas para que no te la pida, pero no se recomienda.
El menu se puede adaptar para que accedan diferentes usuarios mediante este pero lo ideal es que juegues investigando mas.
Hay opciones que se le puede agregar al menu como un [QUIT] para salir de este sin presionar combinacion de teclas como “ctrl + Z”
SALUDOS.

Atte. KrozmoCode.
