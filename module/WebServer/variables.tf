# This file stores the Variables for WebServer Module

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

variable "publicsub1" {
  type    = string
  default = ""
}

variable "publicsub2" {
  type    = string
  default = ""
}

variable "albsg" {
  type    = string
  default = ""
}

variable "ec2sg" {
  type    = string
  default = ""
}

variable "DB_USER" {}
variable "DB_PASSWORD_PARAM" {}
variable "DB_HOST" {}
variable "DB_NAME" {}
variable "DB_PORT" {}
