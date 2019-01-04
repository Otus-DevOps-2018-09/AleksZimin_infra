#!/bin/bash
my_packages_lst="ruby-full ruby-bundler build-essential"
my_date=$(date +%Y-%m-%d)
my_time=$(date +%H-%M-%S)
my_script_path="$(dirname "$(readlink -f "$0")")"
my_script_name="$(basename "$(readlink -f "$0")")"
my_log_path="${my_script_path}/logs/${my_script_name}_${my_date}_${my_time}"

#============================================ Do not edit below ============================================#
if [ "$1" = "-enable_logging" ]; then
  mkdir -p "$(dirname "$my_log_path")"
  exec >"$my_log_path" 2>&1
  echo "$(date +%H-%M-%S): Use exec for redirection stdout and stderr in $my_log_path"
fi

echo "$(date +%H-%M-%S): Running $my_script_name script."
echo "$(date +%H-%M-%S): Check the last time apt update was execute"
[ -z "$(find -H /var/lib/apt/periodic/update-success-stamp -maxdepth 0 -mtime -1)" ] && apt-get update || echo "$(date +%H-%M-%S): Skip apt-get update because it was run less than 1 day ago"
echo "$(date +%H-%M-%S): Starting packages installation. The following packages will be installed: $my_packages_lst";echo

for my_package in $my_packages_lst
do
  if dpkg --status "$my_package" >/dev/null 2>&1
    then
      echo "$(date +%H-%M-%S): Package $my_package already installed"; echo
    else
      echo "$(date +%H-%M-%S): Package $my_package NOT installed. Installation of this package begins."
      echo "$(date +%H-%M-%S): apt-get install -y $my_package"
      apt-get install -y "$my_package"; echo
  fi
done
echo; echo "$(date +%H-%M-%S): Check versions of Ruby and Bundler"
ruby -v
bundle -v
echo "$(date +%H-%M-%S): End of $my_script_name script. Exit."
exit
