Cloud Engineering Second Semester Examination Project

Objective

Automate the provisioning of two Ubuntu-based servers, named "Master" and "Slave," using Vagrant. On the Master node, create a bash script to automate the deployment of a LAMP (Linux, Apache, MySQL, PHP) stack. This script should clone a PHP application from GitHub, install all necessary packages, and configure Apache web server and MySQL. Ensure the bash script is reusable and readable.

Using an Ansible playbook: Execute the bash script on the Slave node and verify that the PHP application is accessible through the VM's IP address (take a screenshot of this as evidence). Create a cron job to check the server's uptime every 12 am.

Requirements

Submit the bash script and Ansible playbook to a publicly accessible GitHub repository.
Document the steps with screenshots in md files, including proof of the application's accessibility (screenshots taken where necessary).
Use either the VM's IP address or a domain name as the URL.
PHP Laravel GitHub Repository: https://github.com/laravel/laravel
Solutions

Automation.sh

This script automates the process of setting up two virtual machines, "master" and "slave," with specific configurations, network settings, and required packages. You can use Vagrant to manage and deploy these virtual machines, which is particularly useful for development and testing environments. Make sure to execute this script in the directory where you want to create the Vagrant environment, and ensure that Vagrant and VirtualBox (or another supported provider) are installed on your system.

Create Vagrantfile

The script begins by generating a Vagrantfile, which is a configuration file for defining the virtual machine environment. It configures two virtual machines: "master" and "slave."

Master Configuration

The script configures the "master" virtual machine. It specifies the base box to be used (in this case, "ubuntu/focal64"). Assigns a private network IP address (192.168.27.87) to the "master." Allocates memory and CPU resources to the virtual machine. Defines provisioning steps for the "master" using a shell script. The shell script does the following:

Generates an SSH key pair without a passphrase.
Copies the SSH public key to the "slave" machine to enable passwordless SSH access.
Updates and upgrades system packages.
Installs the Avahi-Daemon and libnss-mdns packages.
Slave Configuration

Similar to the "master," the script configures the "slave" virtual machine. It specifies the base box, assigns a private network IP (192.168.33.101), allocates resources, and defines provisioning steps. The provisioning script for the "slave" ensures that the SSH server is installed, allows SSH password authentication for key copy, and restarts the SSH service. It also updates and upgrades system packages and installs the Avahi-Daemon and libnss-mdns packages.

Vagrant Environment Initialization

Finally, the script initializes and starts the Vagrant environment using the vagrant up command. This command reads the Vagrantfile and provisions the specified virtual machines.

1. LARAVEL

Laravel, often referred to as "The PHP Framework for Web Artisans," is truly a masterpiece in the world of web development. It's not just a framework; it's an elegant and sophisticated symphony of code that simplifies the complexities of building modern web applications.

Laravel brings joy to developers with its clean and expressive syntax, making code both readable and enjoyable to work on. It pampers developers with a plethora of built-in tools and features, from the powerful Eloquent ORM for database interactions to an intuitive Blade templating engine for crafting beautiful views.

This framework excels in crafting elegant and maintainable code, making it a favorite choice for both beginners and seasoned developers. Laravel's community support, along with its extensive documentation, ensures that every challenge is met with a helping hand.

2. LAMP STACK

Linux (Operating System): In this context, Linux serves as the operating system for your server. It provides the foundation for all other components of the stack to operate. Linux is a robust and stable operating system choice for web servers.

Apache (Web Server): Apache is a widely used open-source web server. It listens for incoming web requests and serves web pages and other content to users' browsers. In the context of Laravel, Apache is responsible for receiving HTTP requests and routing them to the Laravel application for processing.

MySQL (Database): MySQL is a popular open-source relational database management system. It is used to store, retrieve, and manage the application's data. Laravel can communicate with the MySQL database to perform operations like storing user data, content, and more.

PHP (Scripting Language): PHP is a server-side scripting language. Laravel is written in PHP and it runs on the server. PHP is responsible for processing user requests, interacting with the database, and generating dynamic web pages. Laravel leverages PHP to build web applications and manage web routes, controllers, views, and models.

3. ANSIBLE

Ansible, often described as a "simple, yet powerful" open-source automation tool, is a true game-changer in the world of IT operations and infrastructure management. This elegant and efficient automation platform provides a wide range of capabilities that simplify complex tasks, enhance productivity, and promote consistency across systems and networks.

SECTIONS OF THE REPO

The directory and files you've provided are part of an Ansible project that aims to automate the provisioning and configuration of two servers (referred to as "Master" and "Slave") and deploy a LAMP stack along with a Laravel application. Let's delve deeper into the purpose and content of each file:

Ansible.cfg

The ansible.cfg file contains configuration settings for Ansible. Here's what each setting means:

[defaults]: This section defines default configuration options.

inventory = inventory: Specifies the inventory file to use. In this case, it points to an inventory file named "inventory."
private_key_file = ~/.ssh/id_rsa: Specifies the SSH private key file to use for authentication. The ~ represents the user's home directory, and ~/.ssh/id_rsa is the path to the private key.
host_key_checking = False: Disables host key checking to prevent interactive prompts for new hosts.
slave-playbook.yml
The slave-playbookdeploy.yaml file is an Ansible playbook. Playbooks describe a series of tasks to be executed on remote hosts. Here's a breakdown of the playbook's content:

hosts: all: Indicates that these tasks should be executed on all hosts defined in the inventory.
become: true: Specifies that Ansible should escalate privileges and run commands as a superuser (typically using sudo).
pre-tasks: This section defines tasks that should be executed before the main tasks.
name: update & upgrade server: Describes the first task, which updates and upgrades system packages using the apt module.
name: set cron job to check uptime of the server every 12 am: Defines the second task, which uses the cron module to schedule a cron job for checking server uptime at midnight.
name: copy the bash scripts to the slave machine: Describes the task for copying a bash script to the slave machine.
name: Set Execute Permissions on the Script: Specifies a task for setting execute permissions on the copied script.
name: Run Bash Script: Describes the final task, which runs a bash script (laravel-slave.sh) with specific arguments.
inventory

The inventory file defines the target hosts that Ansible will operate on. In this case, it contains the IP address 192.168.33.101, which is likely the IP address of your "Slave" machine. This file tells Ansible where to run the tasks defined in the playbook.

file directory

This directory contains bash script files, deploy.sh. It is used in the deployment process. Here's a brief description of deploy.sh:

deploy.sh is a bash script for automating the deployment of a LAMP stack and a Laravel application. It performs the following tasks:

Installs essential packages.
Configures the firewall (UFW).
Installs and configures Apache.
Installs MySQL and runs the MySQL secure installation script.
Installs and configures PHP.
Configures PHP settings.
Installs Git and Composer.
Configures Apache for Laravel.
Clones the Laravel application from a GitHub repository.
Sets Laravel permissions.
Configures the Laravel .env file.
Sets up the database for Laravel.
Overall, the ansible.cfg file configures Ansible settings, the deploy.yaml playbook defines tasks to be executed, the inventory file lists target hosts, and the file directory contains bash scripts used for server provisioning and application deployment.

This Ansible project automates the deployment and configuration of servers and a Laravel application, making it more efficient and reproducible. It's a powerful tool for infrastructure automation and application deployment.

A proof of the deployments
![master](<images/Screenshot 2023-10-28 at 12.42.17 AM.png>)