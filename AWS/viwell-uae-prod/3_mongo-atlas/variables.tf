# Atlas Organization ID 
variable "atlas_org_id" {
  type        = string
  default = "6318a3cb5d9b7743898c33d8"
  description = "Atlas Organization ID"
}
# Atlas Project Name
variable "atlas_project_name" {
  type        = string
  description = "Atlas Project Name"
  default = "PROJECT 0"
}

# Atlas Project Environment
variable "environment" {
  type        = string
  default = "production"
  description = "The environment to be built"
}

# Cluster Instance Size Name 
variable "cluster_instance_size_name" {
  type        = string
  default = "m40"
  description = "Cluster instance size name"
}

variable "cluster_username" {
  type        = string
  default = "admin"
  description = "admin username"
}

variable "cluster_password" {
  type        = string
  description = "admin password"
}

# Cloud Provider to Host Atlas Cluster
variable "cloud_provider" {
  type        = string
  default = "aws"
  description = "AWS or GCP or Azure"
}

# Atlas Region
variable "atlas_region" {
  type        = string
  default = "me-central-1"
  description = "Atlas region where resources will be created"
}

# MongoDB Version 
variable "mongodb_version" {
  type        = string
  default = "5.0.18"
  description = "MongoDB Version"
}

# IP Address Access
variable "ip_address" {
  type = string
  description = "IP address used to access Atlas cluster"
}

# AWS Region
variable "aws_region" {
  type = string
  default = "me-central-1"
  description = "AWS Region"
}