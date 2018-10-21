# AleksZimin_infra
AleksZimin Infra repository

## HW-3
###Подключение к хосту someinternalhost в одну строку.
####Проверяем, запущен ли агент авторизации, если нет, то запускаем его. Далее добавляем приватный ключ в ssh агент авторизации и подключаемся по ssh к someinternalhost через bastion.
```
ssh-add -L >> /dev/null || eval `ssh-agent -s` && ssh-add ~/.ssh/GCP_zav.edu.devops@gmail.com && ssh -t -A GCP_zav.edu.devops@35.210.36.229 ssh 10.132.0.3
```
###Дополнительное задание:
####Создать алиас в  ~/.ssh/config:
```
vim ~/.ssh/config
```
####Добавитьв конец файла настройки для  хоста someinternalhost:
```
Host someinternalhost
     User GCP_zav.edu.devops
     HostName 10.132.0.3
     ProxyCommand ssh -i ~/.ssh/GCP_zav.edu.devops@gmail.com -W %h:%p GCP_zav.edu.devops@35.210.36.229
     IdentityFile ~/.ssh/GCP_zav.edu.devops@gmail.com
```
####Подключаться командой:
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
