#!/bin/bash
my_date=$(date +%Y-%m-%d)
my_time=$(date +%H-%M-%S)
my_script_name="start_reddit"
my_startup_scripts_folder=/startup_scripts/
my_log_path="${my_startup_scripts_folder}/logs/${my_script_name}_${my_date}_${my_time}"
my_executing_script_lst="install_ruby.sh install_mongodb.sh deploy.sh"
#Задаем переменные, которые будут экспортированы в вызываемые скрипты (экспортируемые переменные указывать в блоке между set -a и set +a)
set -a
my_backet_name="infra_scripts"
set +a
my_package="wget"
my_git_link="https://raw.githubusercontent.com/Otus-DevOps-2018-09/AleksZimin_infra/cloud-testapp/"
#============================================ Do not edit below ============================================#
#functions
#First parameter-name of executable script
my_func_Download_GIT () {
  if dpkg --status $my_package >/dev/null 2>&1
    then
      echo "$(date +%H-%M-%S): Package $my_package already installed"; echo
    else
      echo "$(date +%H-%M-%S): Package $my_package NOT installed. Installation of this package begins."
      echo "$(date +%H-%M-%S): Check the last time apt update was execute"
      [ -z "$(find -H /var/lib/apt/periodic/update-success-stamp -maxdepth 0 -mtime -1)" ] && apt-get update || echo "$(date +%H-%M-%S): Skip apt-get update because it was run less than 1 day ago"
      echo "$(date +%H-%M-%S): apt-get install -y $my_package"
      apt-get install -y $my_package; echo
  fi
  echo "$(date +%H-%M-%S): wget -O ${my_startup_scripts_folder}/${1} ${my_git_link}/${1}"
  wget -O "${my_startup_scripts_folder}/${1}" "${my_git_link}/${1}"
  }
my_func_Download_GS () {
  echo "$(date +%H-%M-%S): gsutil cp gs://${my_backet_name}/${1} ${my_startup_scripts_folder}/${1}"
  gsutil cp "gs://${my_backet_name}/${1}" "${my_startup_scripts_folder}/${1}"
  if [ $? -ne 0 ]; then
    echo "$(date +%H-%M-%S): Error downloading script from gs://${my_backet_name}/${1}. Try download script from another source"
    my_func_Download_GIT "$1"
  fi
}

#script:
exec >"$my_log_path" 2>&1
mkdir -p "$(dirname "$my_log_path")"
#:>"$my_log_path"

##{ 
echo "$(date +%H-%M-%S): Running $my_script_name script."
echo "$(date +%H-%M-%S): Path to log file: $my_log_path"  
for my_executing_script in $my_executing_script_lst
do
  echo "$(date +%H-%M-%S): Download $my_executing_script script"
  my_func_Download_GS "$my_executing_script"
  echo "$(date +%H-%M-%S): Set the rights for downloaded script"
  chmod +x "${my_startup_scripts_folder}/$my_executing_script"
  echo "$(date +%H-%M-%S): Start $my_executing_script script"
  sh "${my_startup_scripts_folder}/$my_executing_script" -enable_logging
  echo
done
echo "$(date +%H-%M-%S): End of $my_script_name script. Exit."
#} >>"$my_log_path" 2>&1


exit
