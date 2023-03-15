# CLIENT-SERVER ARCHITECTURE WITH MYSQL

1. **Installing and Setting up Mysql Server**
Commands: sudo apt install mysql-server ; sudo mysql_secure_installation ; CREATE USER 'remote_user'@'%' IDENTIFIED BY 'password'; , CREATE DATABASE test_db;
GRANT ALL ON test_db.* TO 'remote_user'@'%' WITH GRANT OPTION; , 
![Capture](https://user-images.githubusercontent.com/65962095/177247948-21484eac-01bf-4d27-af55-9bc41daaf87c.PNG)

2. **Installing and Setting up Mysql client**
Command: sudo apt install mysql-client ; sudo mysql -u remote_user -h 172.31.94.236 -p 
![database access](https://user-images.githubusercontent.com/65962095/177248286-85cdae34-6f01-4e92-a43b-84d6c0370ff5.PNG)




