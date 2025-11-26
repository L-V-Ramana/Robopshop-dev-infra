resource "aws_instance""bastion"{
    # count = length(local.public_subnet_ids)
    ami = data.aws_ami.roboshop.id
    instance_type = "t3.micro"
    vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
    # subnet_id = local.public_subnet_ids[count.index]
    subnet_id = local.public_subnet_ids[0]
    

    tags = merge(local.tags,var.bastion_tags,
    {
        Name = "${var.project}-${var.environment}-bastion_host"
    }
    )
}

