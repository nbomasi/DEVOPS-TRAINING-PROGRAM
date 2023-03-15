#WEB SOLUTION WITH WORDPRESS#

[sudo gdisk /dev/xvdf To create partion xvdf]  
sudo gdisk /dev/xvdg To create partion xvdg  
sudo gdisk /dev/xvdh To create partion xvdh  

Partition page

sudo pvcreate /dev/xvdf1 /dev/xvdg1 /dev/xvdh1 #To create physical volume (PV)  

To create volume group named webdata-vg from the PVs  
sudo vgcreate webdata-vg /dev/xvdf1 /dev/xvdg1 /dev/xvdh1  

To create 2 logical volumes (apps-lv and logs-lv) from the  Vg  
sudo lvcreate -n apps-lv -L 14G webdata-vg  
sudo lvcreate -n logs-lv -L 14G webdata-vg  

![Partitions created](https://user-images.githubusercontent.com/65962095/178684342-61c64aab-132b-4b24-9e83-6351e1569936.PNG)  
![Volumes](https://user-images.githubusercontent.com/65962095/178684345-873ffcf6-0198-468f-8e15-ffd457573690.PNG)  
![LVs created](https://user-images.githubusercontent.com/65962095/178684702-99938ea2-8658-41c2-ae27-c2242d8f99a6.PNG)  


To Create file system for the LV (ext4)  
sudo mkfs -t ext4 /dev/webdata-vg/apps-lv  
sudo mkfs -t ext4 /dev/webdata-vg/logs-lv  

To create directories that will store website file data and log data That will be my mount point  
sudo mkdir -p /var/www/html  
sudo mkdir -p /home/recovery/logs  

To store logs into the new mount points created created.  
sudo rsync -av /var/log/. /home/recovery/logs/  
sudo rsync -av /home/recovery/logs/. /var/log  

To mount in /var/www/html and /var/log  
UUID=32bddfa2-7f74-41b1-9a8f-53d0149661ce /var/www/html ext4 defaults 0 0  
UUID=0c9dad11-6753-4bae-add6-277587253002 /var/log ext4 defaults 0 0  

**STEP 2: TO PREPARE DATABASE SERVER**   
Launch a second RedHat EC2 instance that will have a role – ‘DB Server’  
Repeat the same steps as for the Web Server, but instead of apps-lv create database_lv and mount it to /db directory instead of /var/www/html/.  

**STEP 3: Install WordPress on your Web Server EC2**  
1. **Update the repository**  
   sudo yum -y update  

2. **Install wget, Apache and it’s dependencies**  
   sudo yum -y install wget httpd php php-mysqlnd php-fpm php-json  

3. **Start Apache**  
   sudo systemctl enable httpd  
   sudo systemctl start httpd    

4. **To install PHP and it’s dependencies**  
    sudo yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm  
    sudo yum install yum-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm  
    sudo yum module list php  
    sudo yum module reset php  
    sudo yum module enable php:remi-7.4  
    sudo yum install php php-opcache php-gd php-curl php-mysqlnd  
    sudo systemctl start php-fpm  
    sudo systemctl enable php-fpm  
    setsebool -P httpd_execmem 1   

5. **Restart Apache**  
    sudo systemctl restart httpd  
    mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf_backup : To disable apache default page, so that wordpress can set in.  

6. **Download wordpress and copy wordpress to var/www/html**  

   mkdir wordpress  
   cd   wordpress  
   sudo wget http://wordpress.org/latest.tar.gz  
   sudo tar xzvf latest.tar.gz  
   sudo rm -rf latest.tar.gz  
   cp wordpress/wp-config-sample.php wordpress/wp-config.php  
   cp -R wordpress/. /var/www/html/ (To copy only the the content of wordpress)  
   wp-config.php was edited to enter the mysql DB user information.  

7. **Configure SELinux Policies**  

  sudo chown -R apache:apache /var/www/html/  
  sudo chcon -t httpd_sys_rw_content_t /var/www/html -R  
  sudo setsebool -P httpd_can_network_connect=1  


**STEP 4: Install MySQL on your DB Server EC2 **  
    sudo yum update  
    sudo yum install mysql-server  
    Verify that the service is up and running by using sudo systemctl status mysqld, if it is not running, restart the service and enable it so it will be         running even after reboot:  

    sudo systemctl restart mysqld  
    sudo systemctl enable mysqld : I was unable to login back into mysql, until I had to use the following : mysql -uroot -p (https://phoenixnap.com/kb/how-to-     create-new-mysql-user-account-grant-privileges)  
    
    ![Remotely login](https://user-images.githubusercontent.com/65962095/178684938-4910c866-0559-4d8e-8abe-50a3c15c3a60.PNG)  


**STEP 5: Configure DB to work with WordPress**  

    sudo mysql (mysql -uroot -p)  
    CREATE DATABASE wordpress;  
    CREATE USER 'newuser'@'%' IDENTIFIED BY 'Eee068037';  
    GRANT ALL ON wordpress.* TO 'newuser'@'%';  
    FLUSH PRIVILEGES;  
    SHOW DATABASES;  
    exit  
 Note: For REDHAT, the mysql file is saved in /etc/my.cnf  


**STEP 6: Configure WordPress to connect to remote database.**  
   port 3306 was opened on DB server to enable remote onnection  
   sudo yum install mysql , mysql server installed on web server, because its redhat, client could not be installed seperately.  
   
   ![Final wordpress page](https://user-images.githubusercontent.com/65962095/178684100-f49aed1f-3ce8-4603-a7c6-6ebb15a71629.PNG)  
![wordpress page](https://user-images.githubusercontent.com/65962095/178684111-ba335f9e-a9f1-45cd-b5fd-aaaa8ea85b49.PNG)  


   










