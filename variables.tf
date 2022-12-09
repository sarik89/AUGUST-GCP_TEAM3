variable "machine_type" {
  type        = string
  default     = "e2-medium"
  description = "add your machine type"
}

variable "project_name" {
  type        = string
  default     = "YourProjectID" #that yellow part 
  description = "enter your project name"
}


variable "region" {
  type        = string
  default     = "us-south1"
  description = "add desired region"
}


variable "zone" {
  type        = string
  default     = "us-south1-a"
  description = "zone where to deploy resource"
}

variable "minimum_instances" {
  type        = number
  default     = "1"
  description = "minimum desired instances running at a given point"
}

variable "maximum_instances" {
  type        = number
  default     = "5"
  description = "maximum desired instances running at a given point"
}

variable "data_base_version" {
  type        = string
  default     = "MYSQL_5_7" #MYSQL_5_6, MYSQL_5_7, MYSQL_8_0, POSTGRES_9_6,POSTGRES_10, POSTGRES_11, POSTGRES_12, POSTGRES_13, SQLSERVER_2017_STANDARD, SQLSERVER_2017_ENTERPRISE, SQLSERVER_2017_EXPRESS, SQLSERVER_2017_WEB
  description = "specifies the database version"
}


variable "db_password" {
  type        = string
  default     = "mydbppassword"
  description = "description"
}

variable "db_username" {
  type        = string
  default     = "bob"
  description = "input the database authorized user "
}

variable "db_host" {
  type        = string
  default     = "%"
  description = "description"
  
}

variable "db_name" {
  type        = string
  default     = "my_dbname"
  description = "description"
}

variable "vpc_subnetip_range" {
  type        = string
  default     = "192.168.10.0/24"
  description = "CIDR range of the VPC being created"
}

variable "vpc_subnet_name" {
  type        = string
  default     = "public"
  description = "name of the vpc subnet being created"
}

variable "vpc_name" {
  type        = string
  default     = "vpc-gcp-team3"
  description = "desired name of the vpc being created"
}

variable "ASG_name" {
  type        = string
  default     = "my-autoscaler-gcp-team3"
  description = "desired name for the autoscaling"
}

variable "template_name" {
  type        = string
  default     = "my-instance-template-gcp-team3"
  description = "desired name for the compute instance template" 
}

variable "targetpool_name" {
  type        = string
  default     = "my-target-pool"
  description = "description"
}

variable "igm_name" {
  type        = string
  default     = "gcp-team3-igm"
  description = "description"
}

variable "lb_name" {
  type        = string
  default     = "load-balancer"
  description = "description"
}

variable "dbinstance_name" {
  type        = string
  default     = "wordpress"
  description = "name of database instance"
}


variable "authorized_networks" {
  type        = string
  default     = "0.0.0.0/0"
  description = "authorized networks ip incoming to the database"
}