# LOAD BALANCER SOLUTION WITH NGINX AND SSL/TLS 

**Note: This project is a continuation of project 7,8,9 this means that all must be up and running well before I can implement project 10. The diffrence is that I am removing Appache LB and replacing it with NGINX LB. The following conditions must be met for project 9 to run:**

* Apache (httpd) process is up and running on both web servers
* All necessary TCP/UDP ports are opened on all the servers (3306, 111, 2049, 80)
* Client browsers can access both web servers by their respective public IP or public DNS.

## Cloud Infracture for the Project

* **Cloud Platform:** AWS
* **OS**: 3 Red Hat Enterprise Linux 8; 3 Ubuntu 20.04

**Server Applications:**
* Webserver (Red Hat Enterprise Linux 8): 2 Apache2
* Load balancer Server (Ubuntu 20.04): NGINX load balancer
* Database server (Ubuntu 20.04): MYSQL
* Storage Server (Red Hat Enterprise Linux 8): NFS server
* CI/CD Server (Ubuntu 20.04): Jenkins

**Project setup diagram:**
![project10-nginx-lb](https://user-images.githubusercontent.com/65962095/188865089-e3253c45-f0d3-4b48-b887-fe0b903b2178.png)

## Step 1: CONFIGURE NGINX AS A LOAD BALANCER
1. **Create an EC2 VM based on Ubuntu Server 20.04 LTS and open the ports: TCP port 80 for HTTP connections, and TCP port 443 for secured HTTPS connections**

2. **Install Nginx**
```markdown
sudo apt update
sudo apt install nginx
```

3. **configure Nginx as a load balancer to point traffic to the resolvable DNS names of the webservers following steps below:**
* Update /etc/hosts file for local DNS with Web Servers’ names: Webserver1 and Webserver2 and their local IP addresses

```markdown
sudo vi /etc/hosts
``` 
and add 172.31.89.68 Webserver1
172.31.90.196 Webserver2

* Edit vi /etc/nginx/nginx.conf and paste the following:
```markdown
#insert following configuration into http section

 upstream myproject {
    server Web1 weight=5;
    server Web2 weight=5;
  }

server {
    listen 80;
    server_name bomatooling.xyz www.bomatooling.xyz;
    location / {
      proxy_pass http://myproject;
    }
  }

#comment out this line
#       include /etc/nginx/sites-enabled/*;

```
```markdown
sudo systemctl restart nginx
sudo systemctl status nginx
```

## Step 2: Register a domain name.

1. **Register a new domain name with any domain name company of choice:**

The website for my domain name: https://my.hostafrica.com/ and my domain name is bomatooling.xyz and date registered is 07/09/22 and expires 01/07/23

sudo rm -f /etc/nginx/sites-enabled/default  : to disable nginx default page

Steps to link my domain name to my NGINX LB ec2
1. Visit AWS console, search route 53, create hosted zone, there paste your domain name and make it public
2. Create 2 record names using ur public IP as VALUE/ROUTE TRAFFIC, for one of the record use www as subdomain.
3. Visit your domain account > domain manager>nameserver, edit it and paste the links generated when creating hosted zone.
4. Edit /etc/nginx/nginx.conf and replace   DOMAIN.COM with the domain name bomatooling.xyz www.bomatooling.xyz created and restart nginx to apply the new configurations.

LB ends here.

NOTE: NGINX up and running, Nginx is already performing its work of load balancing. However subsequent step is just to enhance the entire LB and introduce more sucurity into the system(SSL/TLS)

## Step 3: Secure your website using, SSL/TLS.

1. **Ensure that snapd is running: Snaps are 'universal' packages that work across many different Linux systems, enabling secure distribution of the latest apps and utilities for cloud, servers, desktops and the internet of things.**

```markdown
sudo systemctl status snapd
```

2. **Install certbot: Package that contain SSL/TLS certificate.**

```markdown
sudo snap install --classic certbot
```
Use the following cli to link certbot in /snap/bin/certbot to /usr/bin/certbot, this means that whatever is saved in the first file will be replicated across to the second.
```markdown
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot --nginx
```

3. **SSL/TLS certificate renewal**

![ssl](https://user-images.githubusercontent.com/65962095/188865872-f3531fef-36b7-4bbd-acc7-6ebbaec1962b.png)

3. SSL/TLS certificate renewal

 
 * dry-run renew:
   ```markdown
sudo certbot renew --dry-run
```
 * cronjob
 
```crontab -e
 * */12 * * *   root /usr/bin/certbot renew > /dev/null 2>&1
```

 End of Project 10
