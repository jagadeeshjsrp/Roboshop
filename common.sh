app_user=roboshop
script=$(realpath "$0")
scrpit_path=$(dirname "$script")

print_head() {
  echo -e "\e[36m>>>>>>>> $1 <<<<<<<<<<<<\e[0m"
}
schema_setup(){
  if [ "$schema_setup" == "mongo" ]; then
    print_head "copy mongodb repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

    print_head "install mongodb client"
    dnf install mongodb-org-shell -y

   print_head "load schema"
    mongo --host mongodb-dev.devjsr1.online </app/schema/{component}.js
  fi
}

func_nodejs()  {
  print_head "Configuring nodejs repos"
  dnf module disable nodejs -y
  dnf module enable nodejs:18 -y

  print_head "install nodejs"
  dnf install nodejs -y

  print_head "Add Application user"
  useradd ${app_user}

  print_head "create application directory"
  rm -rf /app
  mkdir /app

  print_head "download app content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  print_head "unzip app content"
  unzip /tmp/${component}.zip

  print_head "install nodejs dependencies "
  npm install

  print_head "copy cart config "
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

  print_head "start cart service "
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl start ${component}

  schema_setup
}


