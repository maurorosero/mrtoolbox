#!/usr/bin/env bash
#Bash script     : bootstrap.sh
#Apps            : Personal Bin Utilities (MRosero)
#Description     : Bootstrap Base Packages Install
#Author		     : MRP/mrp - Mauro Rosero P.
#Company email   : mauro@rosero.one
#Personal email  : mauro.rosero@gmail.com
#Date            : 20240501
#Version         : 1.5.8
#Notes           :
#==============================================================================
#==============================================================================

install() {
	local install_home=$1
    local bin_home=${install_home}/bin
	local bin_token=$2
	local bin_owner=$3
	local bin_repo=$4
	local download_path=$5

	# Load bootstrap base messages
	set_messages() {
		pymsg_001="Instalando o actualizando Python a la última versión..."
		pymsg_002="No se pudo determinar el sistema operativo."
		pymsg_003="Python instalado o actualizado correctamente."
	}

	if [ -f "${bin_home}/msg/bootstrap.$LANG" ]
	then
		source "${bin_home}/msg/bootstrap.$LANG"
	else
		set_messages
	fi

	install_or_update_python() {
		echo "${pymsg_001}"
		package_list_1="python3 python3-pip sqlite3 git curl wget zip dialog gettext"
		package_list_2="python python-pip sqlite git curl wget zip dialog gettext"
		if [ "$(uname)" == "Darwin" ]; then
			# En macOS, instalamos o actualizamos Python a través de Homebrew
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
			echo "Instalando ${package_list_2}..."
			brew install ${package_list_2}
		elif [ -f /etc/debian_version ] || [ -f /etc/os-release ]; then
			# En sistemas Debian y derivados, instalamos o actualizamos Python a través de apt
			echo "Instalando ${package_list_1}..."
			apt install -y ${package_list_1}
		elif [ -f /etc/redhat-release ]; then
			# En sistemas Red Hat, instalamos o actualizamos Python a través de yum
			echo "Instalando ${package_list_1}..."
			yum install -y ${package_list_1}
		elif [ -f /etc/arch-release ]; then
			# En Arch Linux, instalamos o actualizamos Python a través de pacman
			echo "Instalando ${package_list_2}..."
			pacman -Sy --noconfirm ${package_list_2}
		elif [ -f /etc/rc.conf ]; then
			# En BSD, instalamos o actualizamos Python a través de pkg
			echo "Instalando ${package_list_1}..."
			pkg install -y ${package_list_1}
		else
			echo "${pymsg_002}"
			exit 1
		fi
		echo "${pymsg_003}"
	}
	
	# Instalar o actualizar Python a la última versión y pre-requisitos bootstrap
	install_or_update_python
	
}

# Load head messages
LOCAL_BIN=${HOME}/bin
BIN_REPOS=bin

if [ -f "${LOCAL_BIN}/msg/head.$LANG" ]
then
	source "${LOCAL_BIN}/msg/head.$LANG"
else
	head_000="Utilitarios de Mauro Rosero P. (bootstrap bin)"
fi	

echo "${head_000}"
echo "------------------------------------------------------------------------------"
sudo bash -c "$(declare -f install); install ${HOME} ${BIN_REPOS}"

