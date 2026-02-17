module "user" {
    source = "../../Terraform-ModuleCommonCode-Roboshop"
    Component = "User"
    rule_priority = 20
}