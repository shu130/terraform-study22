# ./variables.tf

#--------------------------
# Provider
variable "profile" {}
variable "region" {}

#--------------------------
# VPC
variable "aws_region" {}

variable "vpc_name" {}

variable "vpc_cidr" {}

variable "availability_zones" {}

variable "public_subnets" {}

variable "private_subnets" {}

#--------------------------
# AutoScaling Group
variable "ec2_instance_name" {}

variable "ec2_instance_type" {}

variable "ec2_ami" {}

variable "ec2_key_pair" {}


#--------------------------
# RDS
variable "rds_name" {}

variable "rds_db_name" {}

variable "rds_username" {}

variable "rds_password" {
  sensitive = true
}

variable "rds_allocated_storage" {}

variable "rds_instance_class" {}

variable "rds_engine_version" {}

variable "rds_multi_az" {
  type = bool
}
