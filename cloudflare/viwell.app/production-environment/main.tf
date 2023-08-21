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
  value   = "ae3619f8fec004d60873b01d75317e80-67d1be69a114d47a.elb.me-central-1.amazonaws.com"
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
  proxied = false

}
resource "cloudflare_record" "portal" {
  zone_id = var.cloudflare_zone_id
  name    = "portal"
  value   = "d37w0wf4uvzy13.cloudfront.net"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "thryve" {
  zone_id = var.cloudflare_zone_id
  name    = "thryve"
  value   = "ae3619f8fec004d60873b01d75317e80-67d1be69a114d47a.elb.me-central-1.amazonaws.com"
  type    = "CNAME"
  ttl     = 1
  proxied = true

}
resource "cloudflare_record" "google-txt" {
  zone_id  = var.cloudflare_zone_id  
  name     = "@"  
  value    = "google-site-verification=WKfAm7J-ht7sIxQ2IXJe_MgUJDPbqJLFcBs4iUad0tM"
  type     = "TXT"
  ttl      = 1 
  proxied  = false
}
resource "cloudflare_record" "vimeo" {
  zone_id = var.cloudflare_zone_id
  name    = "vimeo"
  value   = "d1fnbuthqeodla.cloudfront.net"
  type    = "CNAME"
  ttl     = 1
  proxied = false
}
resource "cloudflare_record" "firebase" {
  zone_id = var.cloudflare_zone_id
  name    = "_acme-challenge.link.viwell.app"
  value   = "NJVUiOdNssKixOPxqq8m8os7vyotLYwnIILQ1UET9FM"
  type    = "TXT"
  ttl     = 1
  proxied = false
}