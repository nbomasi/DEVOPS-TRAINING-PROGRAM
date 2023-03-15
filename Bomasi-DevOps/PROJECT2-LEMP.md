# LEMP STACK IMPLEMENTATION

1. **INSTALLING THE NGINX WEB SERVER**
Command: sudo apt update ; _sudo apt install nginx ; sudo systemctl status nginx ; http://52.90.2.33
sudo apt install mysql-server  sudo mysql , ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'PassWord.1'; ,                           sudo mysql_secure_installation
sudo apt install php-fpm php-mysql_
![Nginx Installed](https://user-images.githubusercontent.com/65962095/170292184-d5173cec-8360-4723-bde5-f426ef3f5d4e.PNG)


2. **INSTALLING MYSQL**
Command: _sudo apt install nginx ; sudo systemctl status nginx ; http://52.90.2.33
sudo apt install mysql-server  sudo mysql , ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'PassWord.1'; ,                           sudo mysql_secure_installation
sudo apt install php-fpm php-mysql_
![Mysql Installed](https://user-images.githubusercontent.com/65962095/170290799-e5eb5704-e6ae-44c2-96ae-5ca41db7191e.PNG)


3. **INSTALLING PHP**
Command: _sudo apt install nginx ; sudo systemctl status nginx ; http://52.90.2.33
sudo apt install mysql-server  sudo mysql , ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'PassWord.1'; ,                           sudo mysql_secure_installation
sudo apt install php-fpm php-mysql_
![Phpinfo](https://user-images.githubusercontent.com/65962095/170288819-72c7a9e9-cc4c-4f8f-9b76-f378d6a5a64f.PNG)


4. **CONFIGURING NGINX TO USE PHP PROCESSOR**
Command: _sudo mkdir /var/www/projectLEMP ; sudo chown -R $USER:$USER /var/www/projectLEMP ; sudo vi /etc/nginx/sites-available/projectLEMP; sudo ln -s /etc/nginx/sites-available/projectLEMP /etc/nginx/sites-enabled/ ; sudo nginx -t ; sudo unlink /etc/nginx/sites-enabled/default ; sudo systemctl reload nginx ; _http://52.90.2.33
![Nginx to PHP](https://user-images.githubusercontent.com/65962095/170287931-a1702429-c192-499a-b927-b88e644ac389.PNG)


5. **TESTING PHP WITH NGINX**
Command: _sudo vi /var/www/projectLEMP/info.php ; http://52.90.2.33/info.php ; sudo rm /var/www/your_domain/info.php_
![Phpinfo](https://user-images.githubusercontent.com/65962095/170285973-16f276c1-89b4-4139-b6a0-d9aa64429bc1.PNG)


6. **RETRIEVING DATA FROM MYSQL DATABASE WITH PHP**
Commands: _CREATE DATABASE `example_database`; , CREATE USER 'example_user'@'%' IDENTIFIED WITH mysql_native_password BY 'password'; , GRANT ALL ON example_database.* TO           'example_user'@'%'; , mysql -u example_user -p , SHOW DATABASES; INSERT INTO example_database.todo_list (content) VALUES ("My first important item"); , SELECT           * FROM example_database.todo_list; , vi /var/www/projectLEMP/todo_list.php , http://52.90.2.33/todo_list.php_
![List created](https://user-images.githubusercontent.com/65962095/170284754-a17cd2c3-ad9c-4076-8fab-3f44468b3fe6.PNG)
![Todo list](https://user-images.githubusercontent.com/65962095/170284763-c1b3618d-d7e4-49b7-aedf-4e413aee3fef.PNG)



