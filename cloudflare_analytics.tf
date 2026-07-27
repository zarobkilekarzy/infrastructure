# cloudflare_analytics.tf — Cloudflare Web Analytics (site).
#
# NIEZARZĄDZANE świadomie: API Web Analytics (RUM) Cloudflare nie akceptuje
# uwierzytelniania tokenem API — zwraca „Method not allowed for this authentication
# scheme" (działa tylko Global API Key / sesja panelu). To ograniczenie Cloudflare,
# nie brak uprawnienia, więc tego zasobu nie da się czysto zaadoptować w tym setupie.
# Beacon w BaseLayout (tryb ręczny) działa niezależnie od tofu.
#
# resource "cloudflare_web_analytics_site" "site" {
#   account_id   = var.cloudflare_account_id
#   zone_tag     = var.cloudflare_zone_id
#   host         = "zarobkilekarzy.pl"
#   auto_install = false
# }
