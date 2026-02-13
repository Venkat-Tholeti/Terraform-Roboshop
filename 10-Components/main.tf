module "component" {
    for_each = var.Components
    source = "git:: https://github.com/Venkat-Tholeti/Terraform-ModuleCommonCode-Roboshop.git?ref=main"
    component = each.key
    rule_priority = each.value.rule_priority
}