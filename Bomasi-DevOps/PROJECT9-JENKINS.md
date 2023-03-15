# TOOLING WEBSITE DEPLOYMENT AUTOMATION WITH CONTINUOUS INTEGRATION. INTRODUCTION TO JENKINS

**Note: This project is a continuation of project 8, this means that project 8 must be up and running well before I can implement project 9. The diffrence is that I am adding CI/CD tool (Jenkins) to project 8. The following conditions must be met for project 9 to run:**

* Apache (httpd) process is up and running on both web servers
* /var/www directories of the web servers are mounted to /mnt/apps of NFS server
* All necessary TCP/UDP ports are opened on all the servers (3306, 111, 2049, 80)
* Client browsers can access both web servers by their respectiv public IP or public DNS.

## Cloud Infracture for the Project

* **Cloud Platform:** AWS
* **OS**: 3 Red Hat Enterprise Linux 8; 3 Ubuntu 20.04

**Server Applications:**
* Webserver (Red Hat Enterprise Linux 8): 2 Apache2
* Load balancer Server (Ubuntu 20.04): Apache load balancer
* Database server (Ubuntu 20.04): MYSQL
* Storage Server (Red Hat Enterprise Linux 8): NFS server
* CI/CD Server (Ubuntu 20.04): Jenkins

**Project setup diagram:**
![Project9-setup Diagram](https://user-images.githubusercontent.com/65962095/187792385-2d1a697a-3ce3-4364-a13c-ac19a8c0ee58.png)

## Step 1: Installing Jenkins Server

1. Create an AWS EC2 server based on Ubuntu Server 20.04 LTS and name it "Project9-Jenkins"
2. Install JDK (since Jenkins is a Java-based application)
3. Install JDK (since Jenkins is a Java-based application)
```markdown
sudo apt update
sudo apt install default-jdk-headless
```
3. Install Jenkins
```markdown
to add Jenkins repository into Ubuntu server:
wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -

to add Jenkins package repository:
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt update
sudo apt-get install jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
```
Jenkin server uses TCP port 8080 by default and hence must be opened in ec2.
![Jenkins Installed](https://user-images.githubusercontent.com/65962095/187591098-32e7f6a4-3d2d-404b-a3ef-0da52afb5e20.png)

## Step 2: Initial setup of Jenkins Server
1. Login to the public IP(3.85.102.233:8080), which will direct you to where (/var/lib/jenkins/secrets/initialAdminPassword) you can locate default admin password, login with the password and install necessary **PLUGINS**

2. Login and install the needed plugins

3. Configure Jenkins to retrieve source codes from GitHub using Webhooks:
This is done by going to my tooling git repo > settings > webhooks > and adding Public IP of Jenkins server to the url feed (http://184.73.114.205:8080/github-webhook/). U must add the last '/'

## Step 3: Create FREESTYLE project on through Jenkins web interface:

Issue: project page did not load, error message below:
![Jenkins error](https://user-images.githubusercontent.com/65962095/187590105-80e115c6-8f67-49f7-82ce-9eb2ebc070d5.png)
Solution: On jenkins dashboard > Jenkins management > Global security configuration > Check 'enable proxy compatibilty'.

1. **Freestyle project create and build it with the steps in the images below:**
![Step1](https://user-images.githubusercontent.com/65962095/187590216-46f0e4f0-2f10-4f01-a96c-d36fc8efc7f0.png)
![Successfully-built](https://user-images.githubusercontent.com/65962095/187590503-cd1578f7-71a5-4c11-9254-a0a156947548.png)

2. **To enable automatic triger on of the project, follow steps below:**
![Automatic trigger](https://user-images.githubusercontent.com/65962095/187591979-ca942bd4-a374-4391-8758-b9d5b80cbc98.png)

To confirm the archived build:
```markdown
ls /var/lib/jenkins/jobs/My_freestyle_project/builds/2/archive$
```

## Step 3: Configure Jenkins to copy files to NFS Server via SSH

1. **Install "Publish Over SSH". by going to plugins and search for it.**

Goto: manage jenkins > Configure System > ssh plugin configuration and provide details of NFS server and test, if successful save:
![SSH CONNECTION](https://user-images.githubusercontent.com/65962095/187591251-4d7dfd56-a4a8-4e5d-8f03-5c10791a09f9.png)
![SSH2](https://user-images.githubusercontent.com/65962095/187787365-402d2154-a013-476a-bba7-1df8a2489783.png)
![SSH3](https://user-images.githubusercontent.com/65962095/187787372-f8fe692e-d6d0-44d4-88b2-8f0dce4980c9.png)


2. **To build such that the file is copied from Jenkins server to NFS-server (/mnt/apps)**

Error encountered:
![Second Error ](https://user-images.githubusercontent.com/65962095/187787502-8cb6296a-1dc3-444d-8b3c-830b4ca45f85.png)

**Solution: Permission and ownership of /mnt/apps were changed using the cli below:**
```markdown
sudo chmod -R 777 /mnt/apps
sudo chown -R nobody:nobody /mnt/apps
```

Final result as expected, all the built files in /var/lib/jenkins/jobs/My_freestyle_project/builds were copied to /mnt/apps:
![25 files copied](https://user-images.githubusercontent.com/65962095/187788037-08e4e5bc-aaa4-4dca-84d3-0f44b25887bc.png)












