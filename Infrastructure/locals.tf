locals {
  tags = {
    Environment     = var.env
    SemanticVersion = var.semantic_version
  }
  user_data = templatefile("${path.module}/scripts/userdata.sh", {
    myenv = var.env
  })

  k8s_sg_ids = {
    for sg_key, mod in module.k8s_sg_shells : sg_key => mod.id
  }

  k8s_resolved_rules = {
    for sg_key, sg_value in var.security_groups :
    sg_key => {
      ingress_rule_list = [
        for rule in sg_value.ingress_rule_list : merge(rule, {
          source_security_group_id = (
            can(regex("^REPLACE_", tostring(rule.source_security_group_id))) ?
            local.k8s_sg_ids[replace(rule.source_security_group_id, "REPLACE_", "")] :
            rule.source_security_group_id
          )
        })
      ]
      egress_rule_list = [
        for rule in sg_value.egress_rule_list : merge(rule, {
          source_security_group_id = (
            can(regex("^REPLACE_", tostring(rule.source_security_group_id))) ?
            local.k8s_sg_ids[replace(rule.source_security_group_id, "REPLACE_", "")] :
            rule.source_security_group_id
          )
        })
      ]
    }
  }
}