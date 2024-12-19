# This file stores the Variables for Network_VPC Module

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "tag_value" {
  type    = string
  default = "TerraformAWSCloudInfraAutomationProject"
}