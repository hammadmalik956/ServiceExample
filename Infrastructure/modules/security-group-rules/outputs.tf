output "ingress_rule_ids" {
  value = [for rule in aws_security_group_rule.ingress : rule.id]
}

output "egress_rule_ids" {
  value = [for rule in aws_security_group_rule.egress : rule.id]
}
