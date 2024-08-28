script=$(realpath "$0")
scrpit_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$rabbitmq_appuser_password" ]; then
  echo Input Robosho Appuser Password Missing
  exit
fi

echo -e "\e[36m>>>>>>>>configuring Erlang Repos <<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>Install Erlang <<<<<<<<<<<<\e[0m"
dnf install erlang -y

echo -e "\e[36m>>>>>>>>configuring RabbitMq Repos <<<<<<<<<<<<\e[0m"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash

echo -e "\e[36m>>>>>>>Install RabbitMq <<<<<<<<<<<<\e[0m"
dnf install rabbitmq-server -y

echo -e "\e[36m>>>>>>>>Start RabbitMq <<<<<<<<<<<<\e[0m"
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server

echo -e "\e[36m>>>>>>>>Add Application user in RabbitMq <<<<<<<<<<<<\e[0m"
rabbitmqctl add_user roboshop ${rabbitmq_appuser_password}
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
