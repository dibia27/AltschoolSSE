# Deployment of LAMP Stack

## Objective

This guide explains the automated deployment of two Vagrant-based Ubuntu systems, designated as Master and Slave. The Master node is integrated with LAMP stack, and a cloned PHP Lavarel application from GitHub. On the Slave node, Ansible is used to verify the IP address' accessibility to the PHP application, and a cron job is created to check the server's uptime every 12 am.

## Prerequisites

- [Vagrant](https://www.vagrantup.com/)
- [VirtualBox](https://www.virtualbox.org/)
- [VirtualBox](https://www.virtualbox.org/)
- [Ansible](https://www.ansible.com/)

## Specifications:

### Vagrantfile configuration:

I used `vagrant init generic/ubuntu2204` to create a Vagrantfile in the directory. I added the following configurations to the Vagrantfile:

```ruby
Vagrant.configure("2") do |config|
  config.vm.define "master" do |master|
    master.vm.box = "generic/ubuntu2204"
    master.vm.network "private_network", ip: "192.168.33.10"
    master.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
        master.vm.boot_timeout = 1200
  end

  config.vm.define "slave" do |slave|
    slave.vm.box = "generic/ubuntu2204"
    slave.vm.network "private_network", ip: "192.168.33.11"
    slave.vm.provider "virtualbox" do |vb|
      vb.memory = "1024"
    end
        slave.vm.boot_timeout = 1200
  end
```

### Deploy two Ubuntu systems:

I added the following commands to the bash script to automate the deployment of two Vagrant-based Ubuntu systems (Master and Slave) and to integrate the Master node with LAMP stack, and a cloned PHP Lavarel application from GitHub.

```bash
#!/bin/bash

# The variables for VM names and IP addresses
MASTER_VM="master"
SLAVE_VM="slave"
MASTER_IP="192.168.33.10"
SLAVE_IP="192.168.33.11"

# Provisioning of the master VM
vagrant up $MASTER_VM

# SSH into the master VM
vagrant ssh $MASTER_VM

# Update package repository
sudo apt update

# Installation of the required packages (LAMP stack)
sudo apt install -y apache2 mysql-server php libapache2-mod-php php-mysql

# Cloning the Laravel application from GitHub
git clone https://github.com/laravel/laravel /var/www/html/laravel

# Configuration of Apache to serve the Laravel application
sudo cp /var/www/html/laravel/.env.example /var/www/html/laravel/.env
sudo chown -R www-data:www-data /var/www/html/laravel
sudo chmod -R 755 /var/www/html/laravel/storage

# Virtual host configuration for Apache
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/laravel.conf
sudo sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\/laravel\/public/' /etc/apache2/sites-available/laravel.conf
sudo a2ensite laravel
sudo a2dissite 000-default
sudo systemctl reload apache2

# Secure MySQL
sudo mysql_secure_installation

# Exit the SSH session
exit
```

Then I ran the following commands to execute the bash script:

```bash
chmod +x AltschoolSSE.sh
./AltschoolSSE.sh
```

### Inter-node Communication:

To ensure that Lavarel is accessible through the Slave node's IP address, I did the following:

I first Setup SSH access using the following commands:

```bash
ssh-keygen -t rsa -b 4096
ssh-copy-id slave@192.168.33.11
ssh slave@192.168.33.11
```

Then I created an Ansible Playbook to make the Lavarel accessible through the Slave node's IP address and to create a cron job:

```yaml
---
- name: Deploy Laravel Application
  host: 192.168.33.11
  become: yes
  tasks:
    - name: Copy the deployment script to the Slave node
      copy:
        src: AltschoolSSE.sh
        dest: /tmp/AltschoolSSE.sh
        mode: "0755"
      delegate_to: localhost # This copies the script from the master VM to the slave VM

    - name: Execute the deployment script on the Slave node
      command: /tmp/AltschoolSSE.sh
      args:
        chdir: /tmp
      delegate_to: localhost # This runs the script on the slave VM

    - name: Verify that Laravel is accessible
      wait_for:
        host: 192.168.33.11
        port: 80
        state: started
        timeout: 60
      ignore_errors: yes

- name: Create slavephp Cron Job
  hosts: 192.168.33.11
  become: yes
  tasks:
    - name: Add the slavephp cron job
      cron:
        name: "uptime_check"
        minute: 0
        hour: 0
        job: "uptime > /var/log/uptime.log 2>&1"
```

Then I ran this command to excecute the yaml file:
`ansible-playbook slavephp.yml`

I got this result:
![Ansible Playbook result](<Screenshot 2023-10-21 150649.png>)

## Conclusion

With the guide and scripts I've provided, I've streamlined the deployment of PHP application while ensuring that the servers are configured and maintained.
