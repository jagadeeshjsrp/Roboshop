script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>Install Golang<<<<<<<<<<<<\e[0m"
dnf install golang -y

func_app_prereq

echo -e "\e[36m>>>>>>>>Download Dependencies <<<<<<<<<<<<\e[0m"
cd /app
go mod init dispatch
go get
go build

func_systemd_setup