terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

provider "cloudflare" {
  version = "~> 3.0"
  api_token = var.cloudflare_api_token
}



resource "cloudflare_record" "api" {
  zone_id = var.cloudflare_zone_id
  name    = "api"
  value   = "a3db085ff34f14972a57e0823d76d5ca-f95c25c339a0d22d.elb.me-central-1.amazonaws.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "media" {
  zone_id = var.cloudflare_zone_id
  name    = "media"
  value   = "dm0wmuq0e40fu.cloudfront.net"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "link" {
  zone_id = var.cloudflare_zone_id
  name    = "link"
  value   = "199.36.158.100"
  type    = "A"
  ttl     = 1
  proxied = true

}