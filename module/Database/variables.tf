# This file stores the Variables for Database Module

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "tag_value" {
  type    = string
  default = "TerraformAWSCloudInfraAutomationProject"
}

variable "vpc_id_main" {
  type    = string
  default = ""
}

variable "ec2sg" {
  type    = string
  default = ""
}

variable "privatesub1" {
  type    = string
  default = ""
}

variable "privatesub2" {
  type    = string
  default = ""
}