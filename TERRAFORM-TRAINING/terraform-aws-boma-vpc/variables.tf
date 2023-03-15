variable "aws_region" {}

variable "vpc_cidr" {
  default = "10.123.0.0/16"
}
variable "public_cidrs" {
  default = ["10.123.1.0/24", "10.123.3.0/24"]
}
variable "private_cidrs" {
  default = ["10.123.2.0/24", "10.123.4.0/24", "10.123.6.0/24"]
}
variable "public_sn_count" {
  default = 2
}
variable "private_sn_count" {
  default = 3
}
variable "max_subnets" {
  default = 5
}
variable "access_ip" {}
variable "db_subnet_group" {
  default = true
}

variable "AWS_ACCESS_KEY_ID" {
  default = "AKIAYO73CAVTZEHDQKW2"
}

variable "AWS_SECRET_KEY_ID" {
  default = "t5YLnoVCP1mfjktWSDP4QPYXA4Cz8Lq/W8TahZIJ"
}