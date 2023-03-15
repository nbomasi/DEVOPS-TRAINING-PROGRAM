# DEVOPS TOOLING WEBSITE SOLUTION

The aim of this project is to introduce a set of DevOps tools that will help the DevOps team in day to day activities in managing, developing, testing, deploying and monitoring different projects. The tools are: 
**Jenkins, Kubernetes, Jfrog Artifactory, Ranchers, Grafana, Prometheus, and Kibana**

## Cloud Infracture for the Project

* **Cloud Platform:** AWS
* **OS**: 3 Red Hat Enterprise Linux 8; Ubuntu 20.04

**Server Applications:**
* Webserver (Red Hat Enterprise Linux 8):3 Apache2
* Database server (Ubuntu 20.04): MYSQL
* Storage Server (Red Hat Enterprise Linux 8): NFS server

## STAGE1: NFS Server Installation

**Having attached volume from AWS console:** I want to create 3 logical volumes from the 3 volumes attached from the AWS console.

* ## Creating Logical Volume

**Step1: Disk partioning with gdisk**
 ```markdown
sudo gdisk /dev/xvdf
 sudo gdisk /dev/xvdg
 sudo gdisk /dev/xvdh
```

**Step2: Creating physical volume (pvcreate) 
Having installed lvm2 (sudo yum install lvm2)**
```markdown
sudo pvcreate /dev/xvdf1
sudo pvcreate /dev/xvdg1
sudo pvcreate /dev/xvdh1
```
**Step3: Creating volume group named 'nfs-vg' (vgcreate)**
```markdown
sudo vgcreate nfs-vg /dev/xvdf1 /dev/xvdg1 /dev/xvdh1
```
**Step4: Creating 3 logical volume from the volume group 'nfs-vg'** named **lv-opt lv-apps,** and **lv-logs** respectively (lvcreate):
```markdown
sudo lvcreate -n lv-opt -L 9G nfs-vg
sudo lvcreate -n lv-apps -L 9G nfs-vg
sudo lvcreate -n lv-logs -L 9G nfs-vg
```
**Step5: Format Logical volume as xfs**
```markdown
sudo mkfs.xfs /dev/nfs-vg/lv-opt
sudo mkfs.xfs /dev/nfs-vg/lv-apps
sudo mkfs.xfs /dev/nfs-vg/lv-logs
```
**Step6: To create mount point on /mnt**,
Make directories under /mnt:
```markdown
sudo mkdir apps
sudo mkdir logs
sudo mkdir opt
```
**To mount temporarily:**
```markdown
sudo mount /dev/nfs-vg/lv-opt /mnt/opt
sudo mount /dev/nfs-vg/lv-apps /mnt/apps
sudo mount /dev/nfs-vg/lv-logs /mnt/logs
```
**To mount Permenently:**
Use the following command to get the LV UUID
```markdown
sudo blkid
```
Open fstab file to set up the mount using the UUID
```markdown
sudo vi /etc/fstab
```
Add the following to the existing document in fstab
```markdown
UUID=27dcd64f-9e16-4233-ab17-ec637d81faa8	/mnt/opt	xfs	defaults 0 0 
UUID=38679ed3-a598-4444-9ae8-1d8934f4b5ed	/mnt/apps	xfs	defaults 0 0 
UUID=070fa1d7-8e30-4368-8854-287f08b2d7f9	/mnt/logs	xfs	defaults 0 0
```
**Step7: Install NFS server, configure it to start on reboot and make sure it is u and running**
```markdown
sudo yum -y update
sudo yum install nfs-utils -y
sudo systemctl start nfs-server.service
sudo systemctl enable nfs-server.service
sudo systemctl status nfs-server.service
```

![nfs server installed](https://user-images.githubusercontent.com/65962095/187160140-1edb0a3d-98f0-446e-93e2-891cad1878df.png)


**Step8: Setting up permission on the LVs created in NFS server so that web server can read, write and execute from the files**
```markdown
sudo chown -R nobody: /mnt/apps
sudo chown -R nobody: /mnt/logs
sudo chown -R nobody: /mnt/opt

sudo chmod -R 777 /mnt/apps
sudo chmod -R 777 /mnt/logs
sudo chmod -R 777 /mnt/opt

sudo systemctl restart nfs-server.service
```
**Step9: Configure access to NFS for clients within the same subnet** 
```markdown
sudo vi /etc/exports

/mnt/apps 172.31.80.0/20(rw,sync,no_all_squash,no_root_squash)
/mnt/logs 172.31.80.0/20(rw,sync,no_all_squash,no_root_squash)
/mnt/opt 172.31.80.0/20(rw,sync,no_all_squash,no_root_squash)

sudo exportfs -arv
```
**Step10: Check which port is used by NFS and open it using Security Groups**
```markdown
rpcinfo -p | grep nfs
```
tcp port use by NFS: 2049, open this port under inbound rule in AWS console.

Others ports to be open to enable client login: TCP 111, UDP 111, UDP 2049

![NSF port](https://user-images.githubusercontent.com/65962095/187159847-f9fdd5a2-6415-4ce2-b6bb-d87fc4c6222c.png)
![Ports open in AWS console](https://user-images.githubusercontent.com/65962095/187159659-fb3b6b22-d6f7-4b9d-876a-fe0002b7bf24.png)


## STAGE2: Configure the database server
**Step1: Get Ubuntu server from AWS console install and configure mysql db, the last cli will enable you to change the loopback IP to 0.0.0.0**
```markdown
sudo apt update -y
sudo apt install mysql-server
sudo systemctl status mysqld
sudo systemctl restart mysqld
sudo systemctl enable mysld
sudo vi /etc/mysql/mysql.conf.d/msqld.cnf
```

**Step2: Configure mysql DB**
```markdown
sudo mysql -p
CREATE DATABASE tooling;
CREATE USER `webaccess`@`172.31.80.0/20` IDENTIFIED BY 'password';
GRANT ALL ON tooling.* TO 'webaccess'@'172.31.80.0/20';
FLUSH PRIVILEGES;
SHOW DATABASES;
```

## STAGE4: Prepare the Web Servers
The following settings will be configured on each of the 3 web servers:

* Configure NFS client (this step must be done on all three servers)
* Deploy a Tooling application to our Web Servers into a shared NFS folder
* Configure the Web Servers to work with a single MySQL database.

Having lunched a Redhat OS, 

1. **Install NFS client**

```markdown
sudo yum install nfs-utils nfs4-acl-tools -y
```
Mount /var/www/ and target the NFS server’s export for apps

```markdown
sudo mkdir /var/www
sudo mount -t nfs -o rw,nosuid 172.31.85.68:/mnt/apps /var/www
``` 
(What this command does is that whatever file that is capture from the web to /www is redirected to the apps directory on which the lv-apps was mounted)


As usual to make the mount permanent, the etc/fstab must be edited. But no need for uuid but private IP of nfs server

172.31.85.68:/mnt/apps /var/www nfs defaults 0 0

2. **To install remi's repository, apache and php:**
```markdown
sudo yum install httpd -y

sudo dnf install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

sudo dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-8.rpm

sudo dnf module reset php

sudo dnf module enable php:remi-7.4

sudo dnf install php php-opcache php-gd php-curl php-mysqlnd

sudo systemctl start php-fpm

sudo systemctl enable php-fpm

sudo setsebool -P httpd_execmem 1
```
Another 2 web server was set up using following above steps. When a test.txt file is created in one server, its replicated across to the 3 servers and the NFS server

3. **Locate the log folder for Apache (/var/log/httpd) on the Web Server and mount it to NFS server’s export for logs**. 
Repeat step №4 to make sure the mount point will persist after reboot
```markdown
172.31.85.68:/mnt/logs /var/log/httpd nfs defaults 0 0                 
```

sudo mount -t nfs -o rw,nosuid 172.31.85.68:/mnt/apps /var/log/httpd
The step 3 is done on the 3 web servers

4. **For darey.io tooling repository to get all the Devops tools mentioned earlier.**

After forking repo, install git on web servers, then clone the forked repo:
```markdown
sudo yum git install
git clone https://github.com/nbomasi/tooling.git
```
```markdown
sudo cp -R html/. /var/www/html 
``` 
To copy the content of cloned git html to /var/www/html

Please ensure to open port 80 on the web servers, also if httpd does not run, disable SELINUX permanently by editing the file:
sudo vi /etc/sysconfig/selinux 
SELINUX=disabled

5. **Connect web server to mysql**
Edit the directory /var/www/html/functions.php and add the following command:
$db = mysqli_connect('172.31.22.142', 'webaccess', 'password', 'tooling');


To update the mysql db from tooling-db.sql, cd to tooling:
```markdown
mysql -h 172.31.22.142 -u webaccess -p tooling < tooling-db.sql
```
Use the following CLI to confirm creation of admin account in DB
```markdown
use tooling;
show tables;
select * from users;
```
Note: To be able to view the updated web page, the default httpd page must be moved elsewhere to be backed up.
```markdown
sudo mv /etc/httpd/conf.d/welcome.conf /etc/httpd/welcome.backup
```
Opening the public IP address of the webservers will open the following attached page, which is the essense of the project:

![Final project7](https://user-images.githubusercontent.com/65962095/187157015-f768fae8-a986-4d7e-9e49-9cc73fcb1e7f.png)
![Final Project71](https://user-images.githubusercontent.com/65962095/187157025-199b8745-a2e0-42e3-a4ad-e4fcb4fd869a.png)











