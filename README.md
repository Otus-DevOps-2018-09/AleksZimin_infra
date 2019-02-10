# AleksZimin_infra
AleksZimin Infra repository

## HW-7
[![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra.svg?branch=terraform-2)](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra)

### Основное задание:
* Определил ресурс файервола и импортировал существующую инфраструктуру в Terraform.
* Сделал шаблоны для packer db.json и app.json, на основе которых создал базовые образы reddit-db-base и reddit-app-base.
* Сделал модули app, db, vpc.
* Параметризировал модуль vpc и проверил его работу с разными ip адресами.
* Отформатировал конфигурационные файлы, используя команду `terraform fmt`.
* Использовал модуль storage-bucket от SweetOPS для создания бакетов, в которых будут храниться стейт файлы stage и prod окружений

### Дополнительное задание 1:
* Настроил хранение стейт файла в удаленном бекенде(gcp) для окружений stage и prod
* Убедился, что terraform видит текущую конфигурацию, не имея локального state файла
* При одновременном применении конфигурации из разных терминалов и разных каталогов получаем ошибку Error locking state

### Дополнительное задание 2:
#### В модуле app:
* Добавил provisioner "file" для копирования конфига сервиса и "remote-exec" для выполнения скрипта deploy.sh в модуле app
* Добавил data sources для подстановки в конфиг сервиса внутреннего ip адреса mongodb
* Перенес необходимые файлы в каталог files в директории модуля
#### В модуле db:
* Добавил provisioner "remote-exec" для изменения bindIp в конфиге mongodb
* Добавил в выходные переменные внутренний ip адрес mongodb
#### В main.tf добавил переменную с внутренним ip адресом mongodb в передаваемые параметры для модуля app 


## HW-6
[![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra.svg?branch=terraform-1)](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra)

### Основное задание:
* Установил terraform на ВМ с ОС ubuntu 1604
* Создал конфигурационные файлы terrraform
* Определил input переменную для приватного ключа и зоны (для зоны указано значение по умолчанию)
* Определил output переменную с внешним IP созданной виртуальной машины (использовал outputs.tf)
* Отформатировал все конфигурационные файлы с помощью команды
```
terraform fmt -write=true
```
* Создал файл terraform.tfvars.example, в котором указал переменные для образца

### Дополнительное задание 1:
* Добавил ssh ключ одного пользователя в метаданные проекта, используя google_compute_project_metadata_item 
* Добавил ssh ключ нескольких полльзователей в метаданные проекта , используя google_compute_project_metadata
* Добавил ssh ключ пользователя appuser_web в метаданные проекта через web интерфейс. Данный ключ был удален после выполнения команды terraform apply

### Дополнительное задание 2:
* Создал файл конфигурации lb.tf для создания http балансировщика. 
* Добавил в output переменные адрес балансировщика (balance_external_ip).
* Добавил еще один terraform ресурс для нового инстанса приложения, reddit-app2.
* Добавил новый инстанс в балансировщик.
* Остановил приложение на одном из инстансов. Приложение все равно было доступно.
* Проблемы, которые я вижу в такой конфигурации: у приложений разные базы данных, поэтому при переключении между инстансами мы видим разные посты. Необходима единая БД
* Изменил файлы lb.tf и main.tf, чтобы кол-во инстансов задавать через параметр ресурса count.
* Переменная count задается в файле variables.tf и по-умолчанию равна 1  

## HW-5
[![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra.svg?branch=packer-base)](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra)

### Основное задание:
* Создал параметризированный шаблон ubuntu16.json для packer в соответствии с заданием (создается образ reddit-base с предустановленными ruby и mongodb)
* Создал отдельный файл variables.json(в репо отсутствует-вместо него variables.json.example), в котором определил обязательные переменные

### Дополнительное задание:
* Создал шаблон immutable.json для packer (из образа, созданного в основном задании, создается образ reddit-full с готовым приложением)
* Дефолтный конфигурационный файл для службы лежит в каталоге packer/files
* В каталоге config-scripts создал скрипт create-reddit-vm.sh для создания ВМ на основе образа reddit-full

#### Для проверки корректности шаблонов использовать команды:
```
packer validate -var-file=variables.json.example ubuntu16.json
packer validate -var-file=variables.json.example immutable.json
``` 


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
```
gsutil -m cp *.sh gs://infra_scripts/
```

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
