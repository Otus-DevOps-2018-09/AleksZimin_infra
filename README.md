# AleksZimin_infra
AleksZimin Infra repository

## HW-11
[![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra.svg?branch=ansible-4)](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra)

### Основное задание:
* Создал виртуалку в гипервизоре, поддерживающем nested virtualisation (я использовал kvm).
* На данной ВМ установил virtualbox 5.2 и vagrant 2.2.3.
* Склонировал на новую ВМ мой репозиторий и скопировал файл vault.key.
* Создал Vagrantfile.
* Создал виртуалки, описанные в Vagrantfile. Проверил их работоспособность и связь друг с другом.
* Создал плейбук base.yml в котором описал установку python. Добавил данный плейбук в site.yml.
* Убрал плейбук users.yml из site.yml.
* Изменил роль db: создал файл тасков install_mongo.yml, вынес таски управления конфигом mongodb в отдельный файл config_mongo.yml, изменил main.yml.
* Выполнил провижининг локальной машины dbserver. 
* Проверил доступность порта монги для хоста appserver.
* Изменил роль app: создал файл тасков ruby.yml, вынес таски настройки puma сервера в puma.yml, изменил main.yml.
* Определил ansible провижинер для хоста appserver в Vagrantfile.
* Применил провижининг для хоста appserver
* Параметризировал имя пользователя в роли app и в плейбуке deploy.yml
* Добавил extra_vars переменные в блок определения провижинера в Vagrantfile. Определил там "deploy_user" => "vagrant", т.к. vagrant выполняет плейбуки от этого пользователя
* Проверил корректность создания ВМ и деплоя приложения с нуля
* Для запуска приложения по адресу http://10.10.10.20 необходимо добавить в Vagrantfile extra_var:
```
"nginx_sites" => { "default" => [
          "listen 80",
          "server_name 'reddit'",
          "location / { proxy_pass http://127.0.0.1:9292;}"]}
```

* Установил virtualenv virtualenvwrapper для работы в виртуальном окружении
* Создал виртуальное окружение venv.
* Добавил директорию venv в .gitignore
* Добавил в файл requirements.txt новые записи
* Установил molecule, testinfra, python-vagrant
* Внутри роли db инициализировал тестовую инфраструктуру molecule.
* Добавил тесты для molecule в тестовом фреймворке testinfra.
* Создал тестовую машину для проверки роли
* Внес изменения в db/molecule/default/playbook.yml
* Самостоятельно дописал один тест на прослушивание порта монги(27017).
* Использовал роли db и app в плейбуках packer_db.yml и packer_app.yml, изменил шаблоны пакера
* Проверил шаблоны пакера
```
packer validate -var-file=packer/variables.json packer/app.json
packer validate -var-file=packer/variables.json packer/db.json

packer build -var-file=packer/variables.json packer/app.json
packer build -var-file=packer/variables.json packer/db.json
```

## HW-10
[![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra.svg?branch=ansible-3)](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra)

### Основное задание:
* Создал роли app и db.
* Проверил работу ролей.
* Настроил работу для нескольких окружений (stage и prod).
* Настроил вывод информации об окружении, в котором находится конфигурируемый хост.
* Перенес все плейбуки в директорию ansible/playbooks.
* Внес новые пути к плейбукам в шаблонах app и db, используемые Packer.
* Проверил шаблоны app и db, используемые Packer:
```
packer validate -var-file=packer/variables.json packer/app.json
packer validate -var-file=packer/variables.json packer/db.json
```
* Перенес файлы, не относящиеся к текущей конфигурации, в директорию ansible/old.
* Улучшил файл ansible.cfg
* Проверил работу ролей с окружениями (настроил stage и prod окружения)
* Установил и настроил community-роль jdauphant.nginx для проксирования запросов с 80 порта на порт приложения
* Добавил в конфигурацию terraform открытие 80 порта для инстанса приложения
* Добавил вызов роли jdauphant.nginx в плейбук app.yml
* Пересоздал ресурсы терраформа для stage окружения
* Применил плейбук site.yml для окружения stage и проверил, что приложение теперь доступно на 80 порту
* Создал файл vault.key вне репозитория и записал в него строку ключа
```
openssl rand 258 | openssl enc -A -base64 > ~/.ansible/vault.key
```
* Создал плейбук users.yml. Зашифровал файл credentials.yml
* Добавил вызов плейбука users.yml в site.yml. Выполнил  site.yml для stage окружения
* Включил парольную аутентификацию и зашел на инстансы под созданными пользователями. 

## HW-9
[![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra.svg?branch=ansible-2)](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra)

### Основное задание:
* Закомментировал код провижинга в модулях app и db терраформа.
* Создал плейбук с одним сценарием. Проверил его работу.
* Создал плейбук с несколькими сценариями. 
* Самостоятельно добавил сценарий для деплоя приложения. 
* Проверил работу плейбука с несколькими сценариями.
* Создал несколько плейбуков и проверил их работу.
* Создал плейбуки для замены bash скриптов в провижининге packer.
* Изменил провижининг в packer на ansible плейбуки.
* Создал новые образы с использованием нового провижинера.
* На основе созданных app и db образов запустил stage окружение.
* Проверил работу плейбука site.yml. 


## HW-8
[![Build Status](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra.svg?branch=ansible-1)](https://travis-ci.com/Otus-DevOps-2018-09/AleksZimin_infra)

### Основное задание:
* Установил pip и ansible.
* Заполнил инвентори в формате ini.
* Перевел инвентори в формат YAML.
* Сравнил команды shell и command; command,service,systemd, command,git.
* Создал первый плейбук. Запустил его повторно после выполнения команды
```
 ansible app -m command -a 'rm -rf ~/reddit'
```

Изменился вывод ansible:
```
appserver                  : ok=2    changed=1    unreachable=0    failed=0
```

Произошло это из за того, что предыдущей командой мы удалили каталог с клонированным репо. Плейбук внес изменения, склонировав данную папку. В первый запуск плейбука данный каталог уже существовал, поэтому изменения на хосте не произошли.


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
