#!/bin/bash
my_date=$(date +%Y-%m-%d)
my_time=$(date +%H-%M-%S)
my_script_path="$(dirname "$(readlink -f "$0")")"
my_script_name="$(basename "$(readlink -f "$0")")"
my_def_log_path=${my_script_path}/logs/"$my_script_name"_${my_date}_${my_time}
my_app_folder="/etc/reddit/"
my_bin_folder="/usr/local/bin/"
my_app_repo="https://github.com/express42/reddit.git"
my_app_user="puma_user"
my_app_group="ruby"
#Указать каталоги, владельцев которых будем менять (через запятую)
my_folders="$my_app_folder"
#Указать, какие параметры использовать при chown (1 параметр применяется к 1 каталогу в my_folders, 2 параметр-ко второму каталогу и т.д.).
#Для каждого каталога можно указать только один параметр
#Если параметры не нужны, то оставить поле пустым и поставить разделитель (символ вертикальной черты). 
#Пример: my_chown_parameters="||-R" - при смене владельца у первых двух каталогов не будут применятся параметры. При обработке третьего каталога будет применен параметр -R
my_chown_parameters="-R"
my_process_name="puma"
#Default value for default_service_conf
def_default_service_conf="/tmp/puma_reddit_default.service"
#Default value for my_service_conf
def_my_service_conf="/etc/systemd/system/puma_reddit.service"
# Переменная my_backet_name может быть экспортирована в скрипте, кторый вызывает данный скрипт. Проверяем ее. Если она не задана, то используем значение по умолчанию
if [ ! -n "$my_backet_name" ]; then
  my_backet_name="infra_scripts"
fi

#============================================ Do not edit below ============================================#

#Funcions:
my_func_Get_Reddit() {
  echo "$(date +%H-%M-%S): Check if group $my_app_group exist"
  if getent group $my_app_group>/dev/null 2>&1
    then
      echo "$(date +%H-%M-%S): Group $my_app_group exist"
    else
      echo "$(date +%H-%M-%S): Group $my_app_group does not exist. Create $my_app_group"
      echo "$(date +%H-%M-%S):groupadd -r $my_app_group"
      groupadd -r "$my_app_group"
  fi
  echo "$(date +%H-%M-%S): Check if users $my_app_user exist"
  if id -u $my_app_user>/dev/null 2>&1
    then
      echo "$(date +%H-%M-%S): User $my_app_user exist"
    else
      echo "$(date +%H-%M-%S): User $my_app_user does not exist. Create $my_app_user"
      #Создаем системного пользователя
      echo "$(date +%H-%M-%S): adduser --system --no-create-home $my_app_user"
      adduser --system --no-create-home $my_app_user
  fi
  echo "$(date +%H-%M-%S): Check if user $my_app_user in group $my_app_group"
  if groups $my_app_user | grep $my_app_group>/dev/null 2>&1
    then
      echo "$(date +%H-%M-%S): User $my_app_user in group $my_app_group"
    else
      echo "$(date +%H-%M-%S): $my_app_user not in group $my_app_group: adduser $my_app_user $my_app_group"
      adduser "$my_app_user" "$my_app_group"
  fi

  # Скачиваем приложение
  echo "$(date +%H-%M-%S): git clone -b monolith $my_app_repo $my_app_folder"
  git clone -b monolith "$my_app_repo" "$my_app_folder"
  mkdir -p "$my_app_folder/tmp/"

  # Переходим в каталог с приложением и устанавливаем его
  echo "$(date +%H-%M-%S): Install application: cd $my_app_folder && bundle install"
  cd "$my_app_folder" && bundle install

  #Меняем переменную окружения IFS (Internal Field Separator). Указываем | в качестве разделителя полей. Сохраняем старый разделитель во временной переменной
  tmpIFS="$IFS"
  IFS="|"
  set -- $my_chown_parameters
  for my_folder in $my_folders
    do  
      my_parameter=$1
    if [ ! -n "$my_parameter" ] 
      then
        echo "$(date +%H-%M-%S): Change owner of $my_folder: chown $my_app_group $my_folder"
        chown $my_app_user:$my_app_group "$my_folder"
      else
        echo "$(date +%H-%M-%S): Change owner of $my_folder: chown $my_app_group $my_folder $my_parameter"
        chown "$my_parameter" $my_app_user:$my_app_group "$my_folder"	
    fi 
    shift 
  done
  IFS="$tmpIFS"

  echo
  echo "$(date +%H-%M-%S): Create systemd config for service"
  echo "$(date +%H-%M-%S): sed 's:replace_this_app_folder:'"${my_app_folder}"':g;s:replace_this_bin_folder:'"${my_bin_folder}"':g;s:replace_this_user:'"${my_app_user}"':g;s:replace_this_group:'"${my_app_group}"':g' "$default_service_conf" | sudo tee "$my_service_conf""
  sed 's:replace_this_app_folder:'"${my_app_folder}"':g;s:replace_this_bin_folder:'"${my_bin_folder}"':g;s:replace_this_user:'"${my_app_user}"':g;s:replace_this_group:'"${my_app_group}"':g' "$default_service_conf" | sudo tee "$my_service_conf" > /dev/null
  echo "$(date +%H-%M-%S): Enable and start service"
  systemctl daemon-reload
  echo "$(date +%H-%M-%S): systemctl enable $my_service_name"
  systemctl enable "$my_service_name"
  echo "$(date +%H-%M-%S): systemctl start $my_service_name"
  systemctl start "$my_service_name"
  sleep 15
  echo "$(date +%H-%M-%S): check service: systemctl is-active $my_service_name"
  if systemctl is-active "$my_service_name"
    then
     echo "$(date +%H-%M-%S): Success!"
    else
     echo "$(date +%H-%M-%S): Cant't start service $my_service_name. Exit"
     exit 1
  fi 
}

#Script:
if [ -n "$1" ]; then
  while [ -n "$1" ]
  do
    case "$1" in
      -enable_logging)
        my_log_path="$my_def_log_path";;
      -default_service_conf)
        echo "$(date +%H-%M-%S): default_service_conf=$2"
        default_service_conf="$2"
        #Используем shift для сдвига параметров, которые были переданы в скрипт (в случае case с ключом и параметром получится двойной сдвиг: сдвинем ключ и параметр)
        shift;;
      -service_conf)
        echo "$(date +%H-%M-%S): my_service_conf=$2"
        my_service_conf="$2"
        shift;;
      *) echo "$(date +%H-%M-%S): \"$1\" is not an option." ;;
    esac
  #Используем shift для сдвига ключей, которые были переданы в скрипт 
  shift
  done
fi

# Добавим переменную my_log_path. Если она задана, то путь к логу берем из нее (задается в environment_vars в packer)
if [ -n "$my_log_path" ]; then
  echo "$(date +%H-%M-%S):Logging enabled. Use exec for redirection stdout and stderr in $my_log_path"
  mkdir -p "$(dirname "$my_log_path")"
  exec >"$my_log_path" 2>&1 
fi

echo "$(date +%H-%M-%S): Running Reddit App installation script."
if [ ! -n "$default_service_conf" ]; then
  echo "$(date +%H-%M-%S): Not defined default_service_conf. Use default value and download default config file in ${def_default_service_conf}"
  echo "default_service_conf=$def_default_service_conf"
  default_service_conf=$def_default_service_conf
  echo "gsutil cp gs://${my_backet_name}/$(basename "$default_service_conf") $default_service_conf"
  gsutil cp "gs://${my_backet_name}/$(basename "$default_service_conf")" "$default_service_conf"
fi

if [ ! -n "$my_service_conf" ]; then
  echo "$(date +%H-%M-%S): Not defined service conf. Use default value"
  echo "my_service_conf=$def_my_service_conf"
  my_service_conf="$def_my_service_conf"
fi
my_service_name="$(basename "$my_service_conf")"

echo 
if [ -z "$(pgrep "$my_process_name")" ]
  then
    echo "$(date +%H-%M-%S): Process does not exist. Try to start the service."
    if [ ! -d "$my_app_folder" ]; then
        echo "$(date +%H-%M-%S): Directory reddit does not exist. Clone it from repo and install service"
        my_func_Get_Reddit
        echo "$(date +%H-%M-%S): End of Reddit App installation script. Exit."
        exit
    fi
    systemctl start "$my_service_name"
    if [ $? -ne 0 ]
      then
        echo "$(date +%H-%M-%S): Failed to start service. Try clone repo again, app install and start service"
        my_func_Get_Reddit
      else
        if systemctl is-active "$my_service_name"
          then
            echo "$(date +%H-%M-%S): Success!"
          else
            echo "$(date +%H-%M-%S): Cant't start service $(basename "$my_service_conf"). Exit"
            exit 1
        fi
    fi
  else echo "$(date +%H-%M-%S): Process already exists."
fi

echo "$(date +%H-%M-%S): End of Reddit App installation script. Exit."
exit
