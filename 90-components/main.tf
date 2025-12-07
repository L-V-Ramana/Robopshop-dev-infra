

module "components"{
    for_each = "${var.components}"
    source = "../../terraform-module-roboshop"
    component = "${each.key}"
    priority  = each.value
}