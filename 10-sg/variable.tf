
variable "project" {
  default = "Roboshop"
}

variable "environment" {
  default = "Dev"
}

variable "frontend_sg"{
  default = "front_end_sg"
}

variable "frontend_description"{
  default = "sg_for_front_end"
}

variable "bastion_sg_name"{
  default = "bastion"

}

variable "bastion_sg_description"{
  default = "sg-for-bastion"
}

variable "mysql_ports"{
  default = [22,3306]
}

variable "rabbitmq_port" {
  default = [22,5672]
}