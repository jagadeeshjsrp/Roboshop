script=$(realpath "$0")
scrpit_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]; then
  echo Input MySql Root Password Missing
  exit
fi

echo -e "\e[36m>>>>>>>Install Maven <<<<<<<<<<<<\e[0m"
dnf install maven -y

echo -e "\e[36m>>>>>>>>add Application USer <<<<<<<<<<<<\e[0m"
useradd ${app_user}

echo -e "\e[36m>>>>>>>>Create Application Directory <<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>Download App Content <<<<<<<<<<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip

echo -e "\e[36m>>>>>>>>Extract App Content <<<<<<<<<<<<\e[0m"
cd /app
unzip /tmp/shipping.zip

echo -e "\e[36m>>>>>>>>Download Dependencies <<<<<<<<<<<<\e[0m"
cd /app
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[36m>>>>>>>>SetUp Systemd <<<<<<<<<<<<\e[0m"
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service


echo -e "\e[36m>>>>>>>>Install Mysl <<<<<<<<<<<<\e[0m"
dnf install mysql -y

echo -e "\e[36m>>>>>>>Load Schema<<<<<<<<<<<<\e[0m"
mysql -h mysql-dev.devjsr1.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql

echo -e "\e[36m>>>>>>>>Start Shipping <<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping