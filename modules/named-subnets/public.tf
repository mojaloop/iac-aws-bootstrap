locals {
  public_subnet_az_map = var.enabled && var.type == "public" ? var.subnet_az_map : {}
  ngw_count      = var.enabled && var.type == "public" && var.nat_enabled ? 1 : 0
}

module "public_label" {
  source    = "../null-label"
  namespace = var.namespace
  name      = var.name
  # stage      = var.stage
  delimiter  = var.delimiter
  tags       = var.tags
  attributes = compact(concat(var.attributes, ["public"]))
  enabled    = var.enabled
}

resource "aws_subnet" "public" {
  for_each          = local.public_subnet_az_map
  vpc_id            = var.vpc_id
  availability_zone = each.value.az
  cidr_block        = cidrsubnet(var.cidr_block, ceil(log(var.max_subnets, 2)), each.value.cidr_block_index)

  tags = {
    "Name"      = "${module.public_label.id}${var.delimiter}${each.key}"
    "Stage"     = module.public_label.stage
    "Namespace" = module.public_label.namespace
    "Named"     = each.key
    "Type"      = var.type
  }
}

resource "aws_route_table" "public" {
  for_each          = local.public_subnet_az_map
  vpc_id   = var.vpc_id

  tags = {
    "Name"      = "${module.public_label.id}${var.delimiter}${each.key}"
    "Stage"     = module.public_label.stage
    "Namespace" = module.public_label.namespace
  }
}

resource "aws_route" "public" {
  for_each          = local.public_subnet_az_map
  route_table_id         = aws_route_table.public[each.key].id
  gateway_id             = var.igw_id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public" {
  for_each          = local.public_subnet_az_map
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_network_acl" "public" {
  count      = var.enabled == "true" && var.type == "public" && signum(length(var.public_network_acl_id)) == 0 ? 1 : 0
  vpc_id     = data.aws_vpc.default.id
  subnet_ids = values(aws_subnet.public)[*].id
  dynamic "egress" {
    for_each = var.public_network_acl_egress
    content {
      action          = lookup(egress.value, "action", null)
      cidr_block      = lookup(egress.value, "cidr_block", null)
      from_port       = lookup(egress.value, "from_port", null)
      icmp_code       = lookup(egress.value, "icmp_code", null)
      icmp_type       = lookup(egress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(egress.value, "ipv6_cidr_block", null)
      protocol        = lookup(egress.value, "protocol", null)
      rule_no         = lookup(egress.value, "rule_no", null)
      to_port         = lookup(egress.value, "to_port", null)
    }
  }
  dynamic "ingress" {
    for_each = var.public_network_acl_ingress
    content {
      action          = lookup(ingress.value, "action", null)
      cidr_block      = lookup(ingress.value, "cidr_block", null)
      from_port       = lookup(ingress.value, "from_port", null)
      icmp_code       = lookup(ingress.value, "icmp_code", null)
      icmp_type       = lookup(ingress.value, "icmp_type", null)
      ipv6_cidr_block = lookup(ingress.value, "ipv6_cidr_block", null)
      protocol        = lookup(ingress.value, "protocol", null)
      rule_no         = lookup(ingress.value, "rule_no", null)
      to_port         = lookup(ingress.value, "to_port", null)
    }
  }
  tags = module.public_label.tags
}

resource "aws_eip" "default" {
  count = local.ngw_count
  vpc   = "true"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_nat_gateway" "default" {
  count         = local.ngw_count
  allocation_id = join("", aws_eip.default.*.id)
  subnet_id     = aws_subnet.public["management"].id
  tags          = module.public_label.tags

  lifecycle {
    create_before_destroy = true
  }
}
