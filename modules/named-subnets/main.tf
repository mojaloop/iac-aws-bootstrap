/**
 * # Named Subnets
 *
 * Creates subnets - with a given name - for a given VPC. Also generates associated ACLs and route tables.
 *
 */

data "aws_vpc" "default" {
  id = var.vpc_id
}
