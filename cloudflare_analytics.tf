# cloudflare_analytics.tf — Cloudflare Web Analytics (site).
#
# Beacon jest wpięty RĘCZNIE w BaseLayout (tryb ręczny, nie auto-iniekcja),
# dlatego auto_install = false. site_token (używany w beaconie) jest read-only
# i stabilny po imporcie — nie regeneruj go bez potrzeby.
resource "cloudflare_web_analytics_site" "site" {
  account_id   = var.cloudflare_account_id
  zone_tag     = var.cloudflare_zone_id
  host         = "zarobkilekarzy.pl"
  auto_install = false
}
