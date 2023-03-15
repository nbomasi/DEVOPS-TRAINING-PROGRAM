# PROJECT1 - LAMP

- AWS account created prior to now, hence I will omit that step.

1. Creation of Ubuntu EC2 Virtual Machine on AWS platform

![EC2 1](https://user-images.githubusercontent.com/65962095/169944350-a7c59319-dbdd-447f-bcfd-f99237cb4664.PNG)
![EC2 2](https://user-images.githubusercontent.com/65962095/169944353-4181054d-22a5-49c2-80ee-b3ebda21650a.PNG)

2. To Connect to EC2 with Powershell
   Command: <$ ssh -i C:\Users\Bomasi\Downloads\bomasi1.pem ubuntu@3.87.87.182> 
![Connnection to EC2 with powershell](https://user-images.githubusercontent.com/65962095/169945572-e83216ab-3d77-4b6f-b12f-325f35cdf4ab.PNG)

3. Installing apache: 
   Commands: <$ apt update>; <$ sudo apt install apache2>; <$ sudo systemctl status apache2>
![Apache installed](https://user-images.githubusercontent.com/65962095/169946012-7a0c25ef-c8c4-49b7-843d-d310411432c7.PNG)
![Apache web interface](https://user-images.githubusercontent.com/65962095/169946019-c4fe5438-b114-49cc-8b51-30d9184ab971.PNG)

4. Installing My MYSQL-SERVER (Why this password?)
   Commands: sudo apt install mysql-server; <$ sudo mysql>; <$ ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'PassWord.1';>
   <$ sudo mysql_secure_installation>
![Mysql Installed](https://user-images.githubusercontent.com/65962095/169946355-60a48ec9-25fd-48f7-b879-01fe957cbecf.PNG)

5. Installing PHP
   Commands: <$ sudo apt install php libapache2-mod-php php-mysql>; <$ php -v>
![php -v](https://user-images.githubusercontent.com/65962095/169946559-2a858eb0-f498-46f3-873a-cb2762e6e31a.PNG)

6. Creating a Virtual Host (Why do I have to change USER?)
   Commands: <$ sudo mkdir /var/www/projectlamp>;  <$ sudo chown -R $USER:$USER /var/www/projectlamp>; <$ sudo vi /etc/apache2/sites-available/projectlamp.conf>
   <$ sudo ls /etc/apache2/sites-available>; <$ sudo a2ensite projectlamp>
![Virtual host](https://user-images.githubusercontent.com/65962095/169946974-559b69e9-3089-43cd-86bb-0304ded24cfd.PNG)

7. Enabling PHP on Website
   sudo vim /etc/apache2/mods-enabled/dir.conf; sudo systemctl reload apache2; vim /var/www/projectlamp/index.php; sudo rm /var/www/projectlamp/index.php
![PHP PAGE](https://user-images.githubusercontent.com/65962095/169947118-2cb31172-b3b8-42d3-b778-ff0f16844214.PNG)

**QUESTION**: General Question: With this project, does this mean, I will not have to buy domain name? host, and services of word press







   

