script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo Input MySql Root Password Missing
  exit
fi


echo -e "\e[36m>>>>>>>>configuring nodejs repos <<<<<<<<<<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[36m>>>>>>>>copy mysql repo file <<<<<<<<<<<<\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[36m>>>>>>>>Install Mysql <<<<<<<<<<<<\e[0m"
dnf install mysql-community-server -y

echo -e "\e[36m>>>>>>>>start Mysql <<<<<<<<<<<<\e[0m"
systemctl enable mysqld
systemctl start mysqld


echo -e "\e[36m>>>>>>>>Reset MySql Password<<<<<<<<<<<<\e[0m"
mysql_secure_installation --set-root-pass $mysql_root_password