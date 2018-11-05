#!/bin/bash
my_date=$(date +%Y-%m-%d)
my_time=$(date +%H-%M-%S)
my_script_path="$(dirname "$(readlink -f "$0")")"
my_script_name="$(basename "$(readlink -f "$0")")"
my_log_path=${my_script_path}/logs/"$my_script_name"_${my_date}_${my_time}
my_reddit_folder="/etc/reddit/"
#my_user="GCP_zav.edu.devops"
#============================================ Do not edit below ============================================#
#Funcions:
my_func_Get_Reddit() {
  echo "$(date +%H-%M-%S): git clone -b monolith https://github.com/express42/reddit.git $my_reddit_folder"
  git clone -b monolith https://github.com/express42/reddit.git "$my_reddit_folder"
  cd "$my_reddit_folder"
  echo "$(date +%H-%M-%S): bundle install"
  #sudo su "$my_user" -c bundle install
  bundle install
  echo "$(date +%H-%M-%S): Start puma process"
  puma -d
}

#Script:
if [ "$1" = "enable_logging" ]; then
  mkdir -p "$(dirname "$my_log_path")"
  exec >"$my_log_path" 2>&1
  echo "$(date +%H-%M-%S): Use exec for redirection stdout and stderr in $my_log_path"
fi

echo "$(date +%H-%M-%S): Running Reddit App installation script."
if [ -z "$(ps aux | grep -v grep | grep puma)" ]
  then
    echo "$(date +%H-%M-%S): Process puma does not exist. Try to start the process."
    if [ ! -d "$my_reddit_folder" ]; then
        echo "$(date +%H-%M-%S): Directory reddit does not exist. Clone it from repo"
        my_func_Get_Reddit
        echo "$(date +%H-%M-%S): End of Reddit App installation script. Exit."
        exit
    fi
    cd "$my_reddit_folder"
    puma -d
    if [ $? -ne 0 ]; then
      echo "$(date +%H-%M-%S): Failed to start process puma. Try clone repo again, bundle install and start process"
      my_func_Get_Reddit
    fi
  else echo "$(date +%H-%M-%S): Process puma already exists."
fi

echo "$(date +%H-%M-%S): End of Reddit App installation script. Exit."
exit