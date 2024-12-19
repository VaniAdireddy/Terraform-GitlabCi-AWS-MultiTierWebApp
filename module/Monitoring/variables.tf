# This file stores the Variables for Monitoring Module

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "tag_value" {
  type    = string
  default = "TerraformAWSCloudInfraAutomationProject"
}

variable "asg_name" {
  type = string
  default = ""
}

variable "db_identity" {
  type = string
  default = ""
}