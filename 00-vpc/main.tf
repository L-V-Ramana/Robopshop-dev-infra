module "vpc_dev"{
    # source = "git::https://github.com/L-V-Ramana/aws_vpc_module.git?ref=main"
    source = "../../aws_vpc_module"
    project = var.project
    environment = var.environment
}

# output "vpc_id" {
#   value = module.vpc_dev.vpc_id
# }


output "public_subnet_ids"{
  value = module.vpc_dev.public_subnet_id
}