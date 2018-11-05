#!/bin/bash
my_package="mongodb-org"
my_date=$(date +%Y-%m-%d)
my_time=$(date +%H-%M-%S)
my_script_path="$(dirname "$(readlink -f "$0")")"
my_script_name="$(basename "$(readlink -f "$0")")"
my_log_path=${my_script_path}/logs/"$my_script_name"_${my_date}_${my_time}

#============================================ Do not edit below ============================================#
if [ "$1" = "enable_logging" ]; then
  mkdir -p "$(dirname "$my_log_path")"
  exec >"$my_log_path" 2>&1
  echo "$(date +%H-%M-%S): Use exec for redirection stdout and stderr in $my_log_path"
fi

echo "$(date +%H-%M-%S): Running $my_script_name script."
echo "$(date +%H-%M-%S): Starting packages installation. The following packages will be installed: $my_package"; echo


if dpkg --status $my_package >/dev/null 2>&1
  then
    echo "$(date +%H-%M-%S): Package $my_package already installed"
  else
    echo "$(date +%H-%M-%S): Package $my_package NOT installed. Installation of this package begins."
    apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
    bash -c 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list'
    apt-get update
    echo "$(date +%H-%M-%S): apt-get install -y $my_package"
    apt-get install -y $my_package; echo
    systemctl start mongod
    systemctl enable mongod
    systemctl status mongod
fi

echo "$(date +%H-%M-%S): End of $my_script_name script. Exit."
exit
