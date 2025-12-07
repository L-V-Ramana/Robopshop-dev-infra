# resource "aws_key_pair""openvpn"{ # if the key is not imported to aws
#     key_name = "opnevpn"
#     public_key = file("D:\\DevSecOps\\Keypairs\\key")
# }

resource "aws_instance""vpn"{
    ami = data.aws_ami.open_vpn.id
    instance_type = "t3.micro"
    vpc_security_group_ids = [ data.aws_ssm_parameter.vpn_sg.value ]
    subnet_id = split(",",data.aws_ssm_parameter.public_subnet_id.value)[0]
    key_name = "AllowAll"
    user_data = file("openvpn.sh")

    tags =  merge(local.tags,{
            Name = "${var.project}-${var.environment}-vpn"
    })

}

resource "aws_route53_record""vpn_record"{
    name = "vpn-dev.ramana.site"
    type = "A"
    ttl= 1
    zone_id = var.zone_id
    records = [aws_instance.vpn.public_ip]
    allow_overwrite = true
}