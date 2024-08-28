app_user=roboshop
script=$(realpath "$0")
scrpit_path=$(dirname "$script")

func_print_head() {
  echo -e "\e[36m>>>>>>>> $1 <<<<<<<<<<<<\e[0m"
}
func_schema_setup(){
  if [ "$schema_setup" == "mongo" ]; then
    print_head "copy mongodb repo"
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo

    print_head "install mongodb client"
    dnf install mongodb-org-shell -y

   print_head "load schema"
    mongo --host mongodb-dev.devjsr1.online </app/schema/{component}.js
  fi

  if [ "${schema_setup}" == "mysql" ]; then

    func_print_head "Install Mysql"
    dnf install mysql -y

    func_print_head "Load Schema"
    mysql -h mysql-dev.devjsr1.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql
  fi

}

fun_app_prereq() {
    func_print_head "Add Application USer"
    useradd ${app_user}

    func_print_head "Create Application Directory"
    rm -rf /app
    mkdir /app

    func_print_head "Download App Content"
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip

    func_print_head "Extract App Content"
    cd /app
    unzip /tmp/${component}.zip
}

func_systemd_setup(){
    func_print_head "SetUp Systemd Service"
    cp ${script_path}/${component}.service /etc/systemd/system/${component}.service

    func_print_head "Start ${component} Service"
    systemctl daemon-reload
    systemctl enable ${component}
    systemctl restart ${component}

}

func_nodejs()  {
  func_print_head "Configuring nodejs repos"
  dnf module disable nodejs -y
  dnf module enable nodejs:18 -y

  func_print_head "install nodejs"
  dnf install nodejs -y

  func_app_prereq

  func_print_head "install nodejs dependencies"
  cd /app
  npm install

  func_schema_setup
  func_systemd_setup


}

func_java() {
  func_print_head "Install Maven"
  dnf install maven -y

  func_app_prereq

  func_print_head "Download Maven Dependencies"
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar

  func_schema_setup

  func_systemd_setup

}


