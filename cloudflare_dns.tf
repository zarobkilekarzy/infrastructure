# cloudflare_dns.tf — rekordy DNS strefy zarobkilekarzy.pl (zaadoptowane).
# Wszystkie rekordy są publiczne w DNS; żaden nie niesie treści tożsamościowej:
# DMARC rua = adres raportów Cloudflare (opaque), google-site-verification = token
# już jawny w DNS. Dlatego treści są literałami (zone_id pozostaje zmienną).


# Rekord root (CNAME na zarobkilekarzy.pages.dev) usunięty przy przejściu z Pages na Workers:
# rekord dla zarobkilekarzy.pl tworzy teraz Custom Domain Workera (cloudflare_workers_custom_domain.site).

resource "cloudflare_dns_record" "mx3" {
  comment         = null
  content         = "route3.mx.cloudflare.net"
  data            = null
  name            = "zarobkilekarzy.pl"
  priority        = 54
  private_routing = null
  proxied         = false
  settings = {
    flatten_cname = null
    ipv4_only     = null
    ipv6_only     = null
  }
  tags    = []
  ttl     = 1
  type    = "MX"
  zone_id = var.cloudflare_zone_id
}

resource "cloudflare_dns_record" "mx2" {
  comment         = null
  content         = "route2.mx.cloudflare.net"
  data            = null
  name            = "zarobkilekarzy.pl"
  priority        = 94
  private_routing = null
  proxied         = false
  settings = {
    flatten_cname = null
    ipv4_only     = null
    ipv6_only     = null
  }
  tags    = []
  ttl     = 1
  type    = "MX"
  zone_id = var.cloudflare_zone_id
}

resource "cloudflare_dns_record" "mx1" {
  comment         = null
  content         = "route1.mx.cloudflare.net"
  data            = null
  name            = "zarobkilekarzy.pl"
  priority        = 32
  private_routing = null
  proxied         = false
  settings = {
    flatten_cname = null
    ipv4_only     = null
    ipv6_only     = null
  }
  tags    = []
  ttl     = 1
  type    = "MX"
  zone_id = var.cloudflare_zone_id
}

# Token weryfikacji Google (Google Sites); poprzedni token usunięty 25.10.2026.
resource "cloudflare_dns_record" "google_verify_sites" {
  comment         = null
  content         = "\"google-site-verification=_-rMJhu087xT8J8vXKREXuMmy7k-rbTnXBXKN7E0zjM\""
  data            = null
  name            = "zarobkilekarzy.pl"
  priority        = null
  private_routing = null
  proxied         = false
  settings = {
    flatten_cname = null
    ipv4_only     = null
    ipv6_only     = null
  }
  tags    = []
  ttl     = 3600
  type    = "TXT"
  zone_id = var.cloudflare_zone_id
}

resource "cloudflare_dns_record" "dmarc" {
  comment         = null
  content         = "\"v=DMARC1; p=none; rua=mailto:c1375c85c58e4d4e8b1b793ef55404be@dmarc-reports.cloudflare.net\""
  data            = null
  name            = "_dmarc.zarobkilekarzy.pl"
  priority        = null
  private_routing = null
  proxied         = false
  settings = {
    flatten_cname = null
    ipv4_only     = null
    ipv6_only     = null
  }
  tags    = []
  ttl     = 1
  type    = "TXT"
  zone_id = var.cloudflare_zone_id
}

resource "cloudflare_dns_record" "dkim" {
  comment         = null
  content         = "\"v=DKIM1; h=sha256; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAiweykoi+o48IOGuP7GR3X0MOExCUDY/BCRHoWBnh3rChl7WhdyCxW3jgq1daEjPPqoi7sJvdg5hEQVsgVRQP4DcnQDVjGMbASQtrY4WmB1VebF+RPJB2ECPsEDTpeiI5ZyUAwJaVX7r6bznU67g7LvFq35yIo4sdlmtZGV+i0H4cpYH9+3JJ78k\" \"m4KXwaf9xUJCWF6nxeD+qG6Fyruw1Qlbds2r85U9dkNDVAS3gioCvELryh1TxKGiVTkg4wqHTyHfWsp7KD3WQHYJn0RyfJJu6YEmL77zonn7p2SRMvTMP3ZEXibnC9gz3nnhR6wcYL8Q7zXypKTMD58bTixDSJwIDAQAB\""
  data            = null
  name            = "cf2024-1._domainkey.zarobkilekarzy.pl"
  priority        = null
  private_routing = null
  proxied         = false
  settings = {
    flatten_cname = null
    ipv4_only     = null
    ipv6_only     = null
  }
  tags    = []
  ttl     = 1
  type    = "TXT"
  zone_id = var.cloudflare_zone_id
}

resource "cloudflare_dns_record" "spf" {
  comment         = null
  content         = "\"v=spf1 include:_spf.mx.cloudflare.net ~all\""
  data            = null
  name            = "zarobkilekarzy.pl"
  priority        = null
  private_routing = null
  proxied         = false
  settings = {
    flatten_cname = null
    ipv4_only     = null
    ipv6_only     = null
  }
  tags    = []
  ttl     = 1
  type    = "TXT"
  zone_id = var.cloudflare_zone_id
}
