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



resource "cloudflare_record" "api-dev" {
  zone_id = var.cloudflare_zone_id
  name    = "api-dev"
  value   = "a29ef57723c9a4a39a5d0a065168c207-60791b954c0f9cd6.elb.us-east-1.amazonaws.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "api-dev-b" {
  zone_id = var.cloudflare_zone_id
  name    = "api-dev-b"
  value   = "a29ef57723c9a4a39a5d0a065168c207-60791b954c0f9cd6.elb.us-east-1.amazonaws.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "api-staging" {
  zone_id = var.cloudflare_zone_id
  name    = "api-staging"
  value   = "a29ef57723c9a4a39a5d0a065168c207-60791b954c0f9cd6.elb.us-east-1.amazonaws.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "api-survey-dev" {
  zone_id = var.cloudflare_zone_id
  name    = "api-survey-dev"
  value   = "a29ef57723c9a4a39a5d0a065168c207-60791b954c0f9cd6.elb.us-east-1.amazonaws.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "api-test" {
  zone_id = var.cloudflare_zone_id
  name    = "api-test"
  value   = "a29ef57723c9a4a39a5d0a065168c207-60791b954c0f9cd6.elb.us-east-1.amazonaws.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "media-dev" {
  zone_id = var.cloudflare_zone_id
  name    = "media-dev"
  value   = "d33ivtrkrzapho.cloudfront.net"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "media-test" {
  zone_id = var.cloudflare_zone_id
  name    = "media-test"
  value   = "d2sur8j6cjded3.cloudfront.net"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "media-staging" {
  zone_id = var.cloudflare_zone_id
  name    = "media-staging"
  value   = "d1tennlo849zh7.cloudfront.net"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "api-sec" {
  zone_id = var.cloudflare_zone_id
  name    = "api-sec"
  value   = "a0552adc72de14c5c9967b82ca256122-7327462405cfaa9a.elb.me-central-1.amazonaws.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "media-sec" {
  zone_id = var.cloudflare_zone_id
  name    = "media-sec"
  value   = "d2kmle91kxklk2.cloudfront.net"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}

resource "cloudflare_record" "portal-dev" {
  zone_id = var.cloudflare_zone_id
  name    = "portal-dev"
  value   = "portal-dev.viwell.app.s3-website-us-east-1.amazonaws.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "portal-dev-b" {
  zone_id = var.cloudflare_zone_id
  name    = "portal-dev-b"
  value   = "portal-dev-b.viwell.app.s3-website-us-east-1.amazonaws.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "portal-sec" {
  zone_id = var.cloudflare_zone_id
  name    = "portal-sec"
  value   = "portal-sec.viwell.app.s3-website.me-central-1.amazonaws.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "portal-staging" {
  zone_id = var.cloudflare_zone_id
  name    = "portal-staging"
  value   = "portal-staging.viwell.app.s3-website-us-east-1.amazonaws.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "portal-test" {
  zone_id = var.cloudflare_zone_id
  name    = "portal-test"
  value   = "portal-test.viwell.app.s3-website-us-east-1.amazonaws.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "media-dev-b" {
  zone_id = var.cloudflare_zone_id
  name    = "media-dev-b"
  value   = "d2fbtyhllblui5.cloudfront.net"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}