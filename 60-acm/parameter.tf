resource "aws_ssm_parameter""certificate_arn"{
    name = "/${var.project}/${var.environment}/certificate-arn"
    type = "String"
    value = aws_acm_certificate.ramana.arn
}