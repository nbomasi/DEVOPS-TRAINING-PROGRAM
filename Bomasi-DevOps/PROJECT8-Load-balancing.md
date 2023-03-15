# LOAD BALANCER SOLUTION WITH APACHE

**Note: This project is a continuation of project 7, this means that project 7 must be up and running well before I can implement project 8. The diffrence is that I am considering 2 web servers instead of 3 and adding apache load balancer so tha a single URL will be use to access the web against the 3 that was used in project 7. The following conditions must be met for project 8 to run:**

* Apache (httpd) process is up and running on both web servers
* /var/www directories of the web servers are mounted to /mnt/apps of NFS server
* All necessary TCP/UDP ports are opened on all the servers (3306, 111, 2049, 80)
* Client browsers can access both web servers by their respectiv public IP or public DNS.

## Cloud Infracture for the Project

* **Cloud Platform:** AWS
* **OS**: 3 Red Hat Enterprise Linux 8; Ubuntu 20.04

**Server Applications:**
* Webserver (Red Hat Enterprise Linux 8): 2 Apache2
* Database server (Ubuntu 20.04): MYSQL
* Storage Server (Red Hat Enterprise Linux 8): NFS server

**Project setup diagram**

![Project8_setup_diagram](https://user-images.githubusercontent.com/65962095/187235677-6d1c6637-a674-4ab7-bbbf-ad97ccb02a42.png)


## IMPLEMENTATION OF PROJECT

1. **Create AWS ec2 Ubuntu instance and name it Project-8-apache-lb, also open inbound rule port 80**

2. **Install Apache Load Balancer on Project-8-apache-lb server and configure it to point traffic coming to Load Balancer (LB) to both Web Servers:**

#Install apache2
```markdown
sudo apt update
sudo apt install apache2 -y
sudo apt-get install libxml2-dev
```

#Enable following modules:
```markdown
sudo a2enmod rewrite
sudo a2enmod proxy
sudo a2enmod proxy_balancer
sudo a2enmod proxy_http
sudo a2enmod headers
sudo a2enmod lbmethod_bytraffic
sudo systemctl restart apache2
```
3. **To Configure Load balancing on the serve:**
```markdown
sudo vi /etc/apache2/sites-available/000-default.conf

#Add this configuration into this section <VirtualHost *:80> <Proxy "balancer://mycluster">
               BalancerMember http://172.31.89.68:80 loadfactor=5 timeout=1
               BalancerMember http://172.31.90.196:80 loadfactor=5 timeout=1
               ProxySet lbmethod=bytraffic
               # ProxySet lbmethod=byrequests
        </Proxy>

        ProxyPreserveHost On
        ProxyPass / balancer://mycluster/
        ProxyPassReverse / balancer://mycluster/ </VirtualHost>


#Restart apache server

sudo systemctl restart apache2
```
Try confirm the setup, by browsing LB public IP

Unmount the /var/log/httpd from the NFS server and restart the entire setup:

The LB will load the web server page as shown below:

![Final project7](https://user-images.githubusercontent.com/65962095/187235060-4f273c2e-30a4-4923-a20b-f3be4a5f2e4e.png)

**USING DNS INSTEAD OF PUBLIC IP ADDRESS, WHICH IS DIFFICULT TO REMEMBER**

```markdown
#Open this file on your LB server

sudo vi /etc/hosts

#Add 2 records into this file with Local IP address and arbitrary name for both of your Web Servers

172.31.89.68 Webserver1
172.31.90.196 Webserver2
```

Now go back to sudo vi /etc/apache2/sites-available/000-default.conf and update the following:
```markdown
BalancerMember http://Webserver1:80 loadfactor=5 timeout=1
BalancerMember http://Webserver2:80 loadfactor=5 timeout=1
```

Curling into the 2 webservers from LB
```markdown
curl http://webserver1 or http://webserver1
```
![Dns](https://user-images.githubusercontent.com/65962095/187234925-3c5f1536-e20a-42d4-8403-8f5d1e800294.png)


