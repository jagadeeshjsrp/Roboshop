echo -e "\e[36m>>>>>>>>configuring nodejs repos <<<<<<<<<<<<\e[0m"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y

echo -e "\e[36m>>>>>>>>install nodejs <<<<<<<<<<<<\e[0m"
dnf install nodejs -y

echo -e "\e[36m>>>>>>>>Add application user <<<<<<<<<<<<\e[0m"
useradd roboshop

echo -e "\e[36m>>>>>>>>create application directory <<<<<<<<<<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[36m>>>>>>>>download app content <<<<<<<<<<<<\e[0m"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[36m>>>>>>>>unzip app content <<<<<<<<<<<<\e[0m"
unzip /tmp/user.zip

echo -e "\e[36m>>>>>>>>install nodejs dependencies <<<<<<<<<<<<\e[0m"
npm install

echo -e "\e[36m>>>>>>>>copy user configuration <<<<<<<<<<<<\e[0m"
cp /home/centos/Roboshop/user.service /etc/systemd/system/user.service

echo -e "\e[36m>>>>>>>>start user service <<<<<<<<<<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl restart user

echo -e "\e[36m>>>>>>>>copy mongodb repo <<<<<<<<<<<<\e[0m"
cp /home/centos/Roboshop/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[36m>>>>>>>>install mongodb client <<<<<<<<<<<<\e[0m"
dnf install mongodb-org-shell -y

echo -e "\e[36m>>>>>>>load schema <<<<<<<<<<<<\e[0m"
mongo --host mongodb-dev.devjsr1.online </app/schema/user.js