script=$(realpath "$0")
scrpit_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>Install Golang<<<<<<<<<<<<\e[0m"
dnf install golang -y

echo -e "\e[36m>>>>>>>>Add Application User <<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>Create Application User <<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>Download App Content  <<<<<<<<<<<<\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip

echo -e "\e[36m>>>>>>>>Extract App Content <<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/dispatch.zip

echo -e "\e[36m>>>>>>>>Download Dependencies <<<<<<<<<<<<\e[0m"
cd /app
go mod init dispatch
go get
go build

echo -e "\e[36m>>>>>>>>Setup Systemd <<<<<<<<<<<<\e[0m"
cp ${script_path}/dispatch.service /etc/systemd/system/dispatch.service

echo -e "\e[36m>>>>>>>>configuring nodejs repos <<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable dispatch
systemctl start dispatch