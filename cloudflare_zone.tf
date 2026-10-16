# cloudflare_zone.tf — ustawienia strefy (bezpieczeństwo transportu).
#
# Wartości USTAWIONE = BIEŻĄCA rzeczywistość (adopcja bez zmian). Hardening jest
# świadomą decyzją na później — zmień wartość, a plan pokaże diff:
#   min_tls "1.0" -> "1.2" | ssl "full" -> "strict" (wymaga certu origin) |
#   HSTS nosniff false -> true.

resource "cloudflare_zone_setting" "hsts" {
  zone_id    = var.cloudflare_zone_id
  setting_id = "security_header"
  value = {
    strict_transport_security = {
      enabled            = true
      max_age            = 15552000 # 6 miesięcy
      include_subdomains = true
      preload            = false
      nosniff            = false # stan bieżący; hardening: true
    }
  }
}

resource "cloudflare_zone_setting" "ssl" {
  zone_id    = var.cloudflare_zone_id
  setting_id = "ssl"
  value      = "full" # stan bieżący; hardening: "strict"
}

resource "cloudflare_zone_setting" "always_use_https" {
  zone_id    = var.cloudflare_zone_id
  setting_id = "always_use_https"
  value      = "on"
}

resource "cloudflare_zone_setting" "min_tls" {
  zone_id    = var.cloudflare_zone_id
  setting_id = "min_tls_version"
  value      = "1.0" # stan bieżący; hardening: "1.2"
}

resource "cloudflare_zone_setting" "auto_https_rewrites" {
  zone_id    = var.cloudflare_zone_id
  setting_id = "automatic_https_rewrites"
  value      = "on"
}

# Browser Cache TTL: 0 = „Respect Existing Headers” — przeglądarka dostaje Cache-Control
# ustawiony przez serwis (generowane _headers, Worker). Domyślne 4 h (14400) nadpisywało
# max-age trafień z cache Workera (GET /api/egzamin: 300 s → 4 h).
resource "cloudflare_zone_setting" "browser_cache_ttl" {
  zone_id    = var.cloudflare_zone_id
  setting_id = "browser_cache_ttl"
  value      = 0
}
