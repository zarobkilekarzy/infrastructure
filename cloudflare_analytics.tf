# cloudflare_analytics.tf — Cloudflare Web Analytics (site).
#
# ODROCZONE: odczyt listy RUM (site_id do importu) wymaga uprawnienia tokenu
# „Account Analytics: Read", którego obecny token nie ma. Do czasu rozszerzenia
# tokenu NIE zarządzamy — beacon w BaseLayout działa jak dotąd (tryb ręczny).
# Po nadaniu uprawnienia: odkomentuj i dodaj import w imports.tf
# (id = "<account_id>/<site_id>").
#
# resource "cloudflare_web_analytics_site" "site" {
#   account_id   = var.cloudflare_account_id
#   zone_tag     = var.cloudflare_zone_id
#   host         = "zarobkilekarzy.pl"
#   auto_install = false
# }
