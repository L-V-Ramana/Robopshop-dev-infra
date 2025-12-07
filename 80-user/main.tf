module "user"{
    source = "../../terraform-module-roboshop"
    component = "user"
    priority = "20"
}