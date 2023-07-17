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
