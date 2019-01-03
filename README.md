# AleksZimin_infra
AleksZimin Infra repository

## HW-4
[![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra.svg?branch=cloud-testapp)](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra)

### Дополнительное задание:
#### Создаем инстанс (загрузка startup скрипта из локального файла)
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script="PATH_TO_SCRIPT/startup_reddit.sh"
```

#### Создаем bucket в Google Cloud Storage для хранения скриптов
```
gsutil mb -p infra-220012 -c regional -l europe-west1 gs://infra_scripts/
```

#### Копируем скрипты в bucket:
cd ~/REPO/AleksZimin_infra
gsutil -m cp *.sh gs://infra_scripts/

#### Создаем инстанс (загрузка startup скрипта по URL)
```
gcloud compute instances create reddit-app\
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --scopes storage-ro\
  --metadata startup-script-url="gs://infra_scripts/startup_reddit.sh"
```
#### Создаем правило firewall:
```
gcloud compute firewall-rules create default-puma-server\
  --allow=tcp:9292\
  --direction=INGRESS\
  --source-ranges=0.0.0.0/0\
  --target-tags=puma-server
```
#### Данные для подключения
```
testapp_IP = 35.210.36.229
testapp_port = 9292
``` 



## HW-3
[![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra.svg?branch=cloud-bastion)](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra)
### Подключение к хосту someinternalhost в одну строку.
#### Проверяем, запущен ли агент авторизации, если нет, то запускаем его. Далее добавляем приватный ключ в ssh агент авторизации и подключаемся по ssh к someinternalhost через bastion.
```
ssh-add -L >> /dev/null || eval `ssh-agent -s` && ssh-add ~/.ssh/GCP_zav.edu.devops@gmail.com && ssh -t -A GCP_zav.edu.devops@35.210.36.229 ssh 10.132.0.3
```
### Дополнительное задание:
#### Создать алиас в  ~/.ssh/config:
```
vim ~/.ssh/config
```
#### Добавить в конец файла настройки для  хоста someinternalhost:
```
Host someinternalhost
     User GCP_zav.edu.devops
     HostName 10.132.0.3
     ProxyCommand ssh -i ~/.ssh/GCP_zav.edu.devops@gmail.com -W %h:%p GCP_zav.edu.devops@35.210.36.229
     IdentityFile ~/.ssh/GCP_zav.edu.devops@gmail.com
```
#### Подключаться командой:
```
ssh someinternalhost
```

### Подключение к VPN-серверу
#### Описание
Подключаться с помощью клиента OpenVPN. Панель управления VPN-сервера расположена по адресу:
```
https://35.210.36.229.xip.io/setup
```
#### Данные для подключения
```
bastion_IP = 35.210.36.229
someinternalhost_IP = 10.132.0.3
```
