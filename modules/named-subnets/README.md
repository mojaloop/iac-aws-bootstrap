# Named Subnets

Creates subnets - with a given name - for a given VPC. Also generates associated ACLs and route tables.

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14 |

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| attributes | Additional attributes (e.g. `policy` or `role`) | `list(string)` | `[]` | no |
| availability\_zone | Availability Zone | `any` | n/a | yes |
| cidr\_block | Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`) | `any` | n/a | yes |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, `attributes` | `string` | `"-"` | no |
| enabled | Set to false to prevent the module from creating any resources | `string` | `"true"` | no |
| eni\_id | An ID of a network interface which is used as a default route in private route tables (\_e.g.\_ `eni-9c26a123`) | `string` | `""` | no |
| igw\_id | Internet Gateway ID which will be used as a default route in public route tables (e.g. `igw-9c26a123`). Conflicts with `ngw_id` | `string` | `""` | no |
| max\_subnets | Maximum number of subnets which can be created. This variable is being used for CIDR blocks calculation. Default to length of `names` argument | `string` | `"16"` | no |
| name | Application or solution name | `string` | n/a | yes |
| namespace | Namespace (e.g. `acme`) | `string` | n/a | yes |
| nat\_enabled | Flag of creation NAT Gateway | `string` | `"true"` | no |
| ngw\_id | NAT Gateway ID which will be used as a default route in private route tables (e.g. `igw-9c26a123`). Conflicts with `igw_id` | `string` | `""` | no |
| private\_network\_acl\_egress | Egress network ACL rules | `list` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| private\_network\_acl\_id | Network ACL ID that will be added to the subnets. If empty, a new ACL will be created | `string` | `""` | no |
| private\_network\_acl\_ingress | Egress network ACL rules | `list` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| public\_network\_acl\_egress | Egress network ACL rules | `list` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| public\_network\_acl\_id | Network ACL ID that will be added to the subnets. If empty, a new ACL will be created | `string` | `""` | no |
| public\_network\_acl\_ingress | Egress network ACL rules | `list` | <pre>[<br>  {<br>    "action": "allow",<br>    "cidr_block": "0.0.0.0/0",<br>    "from_port": 0,<br>    "protocol": "-1",<br>    "rule_no": 100,<br>    "to_port": 0<br>  }<br>]</pre> | no |
| subnet\_names | List of subnet names (e.g. `['apples', 'oranges', 'grapes']`) | `list(string)` | n/a | yes |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`) | `map(string)` | `{}` | no |
| type | Type of subnets (`private` or `public`) | `string` | `"private"` | no |
| vpc\_id | VPC ID | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| named\_subnet\_ids | Map of subnet names to subnet IDs |
| ngw\_id | NAT Gateway ID |
| ngw\_private\_ip | Private IP address of the NAT Gateway |
| ngw\_public\_ip | Public IP address of the NAT Gateway |
| private\_named\_subnet\_ids | Map of subnet names to subnet IDs |
| route\_table\_ids | Route Table IDs |
| subnet\_ids | Subnet IDs |

