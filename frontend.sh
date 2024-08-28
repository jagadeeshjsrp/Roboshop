script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

echo -e "\e[36m>>>>>>>>Install Nginx <<<<<<<<<<<<\e[0m"
yum install nginx -y

echo -e "\e[36m>>>>>>>>Copy Roboshop Config File  <<<<<<<<<<<<\e[0m"
cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m>>>>>>>Removing Already Existed Content<<<<<<<<<<<<\e[0m"
rm -rf /usr/share/nginx/html/*

echo -e "\e[36m>>>>>>>>Downlaod App Content <<<<<<<<<<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip

echo -e "\e[36m>>>>>>>>Extract App Content <<<<<<<<<<<<\e[0m"
cd /usr/share/nginx/html
unzip /tmp/frontend.zip

# some files need to be created.
echo -e "\e[36m>>>>>>>>Start Nginx <<<<<<<<<<<<\e[0m"
systemctl restart nginx
systemctl enable nginx