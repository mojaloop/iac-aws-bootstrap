resource "aws_route53_zone" "tenant_public" {
  name = var.domain
  tags = merge({}, var.tags)
}

resource "aws_route53_zone" "tenant_private" {
  name = "${lower(var.tenant)}.${var.domain}.internal"
  vpc {
    vpc_id = module.vpc.vpc_id
  }
  tags = merge({}, var.tags)
}

# data "aws_route53_zone" "selected" {
#   name         = var.domain
#   private_zone = false
# }

# resource "aws_route53_record" "subdomain-ns" {
#   zone_id = data.aws_route53_zone.selected.zone_id
#   name    = data.aws_route53_zone.selected.name
#   type    = "NS"
#   ttl     = "30"

#   records = [
#     aws_route53_zone.tenant_public.name_servers.0,
#     aws_route53_zone.tenant_public.name_servers.1,
#     aws_route53_zone.tenant_public.name_servers.2,
#     aws_route53_zone.tenant_public.name_servers.3,
#   ]
# }
