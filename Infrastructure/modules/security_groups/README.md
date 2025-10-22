<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | <= 5.90.0 |



## Resources

| Name | Type |
|------|------|
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.default_egress_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.default_ingress_rules](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_svc"></a> [aws\_svc](#input\_aws\_svc) | Variable to identify type of security group like alb, FE, BE etc | `string` | n/a | yes |
| <a name="input_costCategory"></a> [costCategory](#input\_costCategory) | Allowed values are: RnD, marketing, customer | `string` | `"marketing"` | no |
| <a name="input_description"></a> [description](#input\_description) | A description for the security group | `string` | `"Security group created by terraform"` | no |
| <a name="input_egress_rule_list"></a> [egress\_rule\_list](#input\_egress\_rule\_list) | List of security group egress rules | <pre>list(object({<br/>    source_security_group_id = string<br/>    cidr_blocks              = list(string),<br/>    description              = string,<br/>    from_port                = number,<br/>    protocol                 = string,<br/>    to_port                  = number<br/>  }))</pre> | <pre>[<br/>  {<br/>    "cidr_blocks": [<br/>      "0.0.0.0/0"<br/>    ],<br/>    "description": "Default egress rule",<br/>    "from_port": 0,<br/>    "protocol": "all",<br/>    "source_security_group_id": null,<br/>    "to_port": 65535<br/>  }<br/>]</pre> | no |
| <a name="input_ingress_rule_list"></a> [ingress\_rule\_list](#input\_ingress\_rule\_list) | List of security group ingress rules | <pre>list(object({<br/>    source_security_group_id = string<br/>    cidr_blocks              = list(string),<br/>    description              = string,<br/>    from_port                = number,<br/>    protocol                 = string,<br/>    to_port                  = number<br/>  }))</pre> | `[]` | no |
| <a name="input_micro_svc"></a> [micro\_svc](#input\_micro\_svc) | Variable to identify micro service | `string` | n/a | yes |
| <a name="input_org"></a> [org](#input\_org) | This tag is used to uniquely identify resources within organization | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The id of the VPC where the security group is being deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->