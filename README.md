# GOOGLE CLOUD PLATFORM 3 TIER APPLICATION
# Prerequisities: 
 - Login to your Google Cloud Console
- Create a Billing Account
 * This part tells google to look for a billing account named "My Billing Account". So "My Billing Account" must be created first in the console for this script to run. If there is a different billing account you would like to use for this project, you can specify it and just change the name in the block of code. 
 #### - Go to GCP CLI and copy project URL (ssh) from github. 
From your local execute **git clone REPO_URL**. Check the logs and make sure it's cloned properly. Go to "setup_project_id" folder and create a project with the billing account added using the following code:

 ```
 data "google_billing_account" "acct" {
	    display_name = "My Billing Account"
	    open = true
	}
resource "random_password" "password" {
	    length = 16
	    numeric = false
	    special = false
	    lower = true
	    upper = false
	}
	resource "google_project" "testproject" {
	    name = "AUGUST-GCP_TEAM3"
	    project_id = random_password.password.result
	    billing_account = data.google_billing_account.acct.id
	}
```
 ### this part enables the services so we can provision the resources 

 ```
 provisioner "local-exec" {
	    command = <<-EOT
	        gcloud services enable compute.googleapis.com
	        gcloud services enable dns.googleapis.com
	        gcloud services enable storage-api.googleapis.com
	        gcloud services enable container.googleapis.com
	    EOT
	  }
	}
```
### Once created make sure you see your project ID in yellow color to make sure you are inside your project and can start provisioning resources. Exit the "setup_project_id" folder and make sure you are in the "AUGUST-GCP_TEAM3" then move to "backend_storage" folder and create a Cloud Storage Bucket and change the backend configuration to your new bucket and your Google Cloud project.  Then run **terraform init** and **terraform apply** commands.

```
resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "default" {
  name          = "${random_id.bucket_prefix.hex}-bucket-tfstate"
  force_destroy = false
  location      = "US"
  storage_class = "STANDARD"
  versioning {
    enabled = true
  }
}
output  bucket_name {
    value = google_storage_bucket.default.name
}
```
Exit the "backend_storage" folder and make sure you are in the "AUGUST-GCP_TEAM3" folder and do **terraform init**. Make sure the project Id is set in the variables file to the correct project ID you just created and do **terraform apply -auto-approve** and it will build all resources needed for a fully functioning three tier application.
# VPC module

>In this project, we used global VPC, because it provided us managed and global virtual network for all of our Gcloud resources through subnets.

## Steps:

1. Create vpc.tf file in folder with .gitignore and README.md files.
2. Use google_compute_network resource to create the vpc

```
resource "google_compute_network" "vpc-network-team3" {
   name = "var.vpc_name"
   auto_create_subnetworks = "true"
   routing_mode = "GLOBAL"
}
```

3. Open integrated terminal for this folder

4. DO NOT FORGET to set the project first, otherwise your resources won't be created under your project in GCP

5. Command for setting the project: *gcloud config set project [PROJECT_ID]*

6. Run **terraform init** command to initialize it

7. Run **terraform plan** and see if you have any syntax error

8. Run **terraform apply** to apply your changes

9. Go to Google Console and check if your VPC is created under the name of team3-vpc

# Database

> Google Cloud SQL is managed database service and it allows us to run MySQL, PosgreSQL on GCloud.

### 
1. In Cloud Shell under your repo folder, create a folder DB and add terraform files in it - dbinstance.tf, variables.tf and provider.tf

2. In dbinstance.tf add your resources to create your database instance.   Use google_sql_database_instance resource for this:

```
resource “google_sql_database_instance” “database” {
  name                = var.dbinstance_name
  database_version    = var.data_base_version
  region              = var.region
  root_password       = var.db_password
  deletion_protection = “false”
  project             = var.project_name
}
  
```
### 
3. In dbinstance.tf file add your resource to create your database inside db instance
```
resource "google_sql_database" "database" {
  name     = var.db_name
  instance = google_sql_database_instance.database.name
}

resource "google_sql_user" "users" {
  name     = var.db_username
  instance = google_sql_database_instance.database.name
  host     = var.db_host
  password = var.db_password
}
```

4. In variables.tf add your variables to make your resources more dynamic
4. Run **terraform init**, **terraform apply** to apply your changes
5. Check Gcloud and make sure your resources are created under **team3-db-instance**
6. In Google Console, you will be able to find your db instance's **Public IP address** and also **Connection name**
7. From SQL service, add a user to your database instance
8. You can connect to your db instance from **Cloud Shell by using gcloud sql connect team3-db-instance --user=yourusername  --quiet** command
9. Connect to your database instance, use **show databases;** query and make sure your db is created. this db will be used for wordpress connection
10. If you see your db inside your db instance, you should be good. Move on

# Autoscaling
>For handling increasings in traffic dynamically we used Autoscaling. It's adding/reducing capacity.

### 1. Create asg.tf file and add *google_compute_autoscaler* resource inside the file. Use *gcloud compute images list* command to list of available images in GCloud. 

```
resource "google_compute_autoscaler" "team3" {
     depends_on = [
        google_sql_database_instance.database,
        
    ]
  name   = var.ASG_name
  zone   = var.zone
  target = google_compute_instance_group_manager.my-igm.self_link
  ```

  ### 2. Section where you can define the number of instances running by editing the variables file under maximum or minimum
```
  autoscaling_policy {
    max_replicas    = var.maximum_instances
    min_replicas    = var.minimum_instances
    cooldown_period = 60
  }
}
```


### 3. Creating a machine template so the autoscaling knows what type of machine to work with.

```
resource "google_compute_instance_template" "compute-engine" {
     depends_on = [
        google_sql_database_instance.database,
      
    ]
  name                    = var.template_name
  machine_type            = var.machine_type
  can_ip_forward          = false
  project                 = var.project_name
}
```
### 4. Also add your **google_compute_instance_group_manager**, **google_compute_target_pool**, and **google_compute_firewall** resource in asg.tf file as well for handling firewall and targets groups.

### creating a target pool

```
resource "google_compute_target_pool" "team3" {
  name    = var.targetpool_name
  project = var.project_name
  region  = var.region
}
```
### creating a group manager for the instances

```
resource "google_compute_instance_group_manager" "my-igm" {
  name    = var.igm_name
  zone    = var.zone
  project = var.project_name
  version {
    instance_template = google_compute_instance_template.compute-engine.self_link
    name              = "primary"
  }
  target_pools       = [google_compute_target_pool.team3.self_link]
  base_instance_name = "team3"
}
```

### indicating the image for the instance

```
data "google_compute_image" "centos_7" {
  family  = "centos-7"
  project = "centos-cloud"
}

module "lb" {
  source       = "GoogleCloudPlatform/lb/google"
  version      = "2.2.0"
  region       = var.region
  name         = var.lb_name
  service_port = 80
  target_tags  = ["my-target-pool"]
  network      = google_compute_network.vpc-network-team3.name
}
```


### 5. Add variables.tf file inside your ASG folder. Variables file will allow you to have your scripts more dynamic. Instead of hardcoding the data inside your resources, variables.tf file will give you opportunity to keep your data inside it and fetch from another file as long as the files share same root.
### 6. Add startup.sh file for bootstrapping. It means whatever command like you in this file, it will be launching during the instance provisioning. Please see **metadata_startup_script = file("startup.sh")** line under *google_compute_instance_template* resource. In our case, here is our script to install wordpress:

```
yum install httpd wget unzip epel-release mysql -y
    yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm
    yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    yum -y install yum-utils
    yum-config-manager --enable remi-php56   [Install PHP 5.6]
    yum -y install php php-mcrypt php-cli php-gd php-curl php-mysql php-ldap php-zip php-fileinfo
    wget https://wordpress.org/latest.tar.gz
    tar -xf latest.tar.gz -C /var/www/html/
    mv /var/www/html/wordpress/* /var/www/html/
    cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    chmod 666 /var/www/html/wp-config.php
    sed 's/'database_name_here'/'${google_sql_database.database.name}'/g' /var/www/html/wp-config.php -i
    sed 's/'username_here'/'${google_sql_user.users.name}'/g' /var/www/html/wp-config.php -i
    sed 's/'password_here'/'${var.db_password}'/g' /var/www/html/wp-config.php -i
    sed 's/'localhost'/'${google_sql_database_instance.database.ip_address.0.ip_address}'/g' /var/www/html/wp-config.php -i
    sed 's/SELINUX=permissive/SELINUX=enforcing/g' /etc/sysconfig/selinux -i
    getenforce
    setenforce 0
    chown -R apache:apache /var/www/html/
    systemctl start httpd
    systemctl enable httpd
    SCRIPT
  tags = ["wordpress-firewall"]
  disk {
    source_image = data.google_compute_image.centos_7.self_link
  }
  network_interface {
    network = google_compute_network.vpc-network-team3.id
    access_config {
      // Include this section to give the VM an external ip address
    }
  }
```


###
7. Go Gcloud and check if resources are created properly
8. Use public IP for the instance and see if you are able to load the wordpress
9. Use **mysql -u username -h yourip -p team3db** command to connect from your VM machine to your database instance
10. And  your wordpress should be **UP and RUNNING!!!**  


## Collaborations: 
1. Sarvarkhuja Tursinov
2. Nazerke Baikonak




