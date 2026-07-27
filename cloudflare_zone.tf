# cloudflare_zone.tf — ustawienia strefy (bezpieczeństwo transportu).
#
# W v5 każde ustawienie to osobny zasób cloudflare_zone_setting (setting_id).
# Adoptujemy istniejące wartości przez import; PIERWSZY `tofu plan` pokaże, czy
# zadeklarowane wartości zgadzają się z rzeczywistością — zreconciliuj różnice.

# HSTS — Strict-Transport-Security. Wg CLAUDE.md: 6 mies., includeSubDomains,
# bez preload (dotąd trzymane w panelu; tofu staje się jedynym źródłem prawdy).
# UWAGA: dokładny kształt obiektu `value` potwierdź na pierwszym planie.
resource "cloudflare_zone_setting" "hsts" {
  zone_id    = var.cloudflare_zone_id
  setting_id = "security_header"
  value = {
    strict_transport_security = {
      enabled            = true
      max_age            = 15552000 # 6 miesięcy
      include_subdomains = true
      preload            = false
      nosniff            = true
    }
  }
}

resource "cloudflare_zone_setting" "ssl" {
  zone_id    = var.cloudflare_zone_id
  setting_id = "ssl"
  value      = "strict" # potwierdź: "full" vs "strict"
}

resource "cloudflare_zone_setting" "always_use_https" {
  zone_id    = var.cloudflare_zone_id
  setting_id = "always_use_https"
  value      = "on"
}

resource "cloudflare_zone_setting" "min_tls" {
  zone_id    = var.cloudflare_zone_id
  setting_id = "min_tls_version"
  value      = "1.2"
}

resource "cloudflare_zone_setting" "auto_https_rewrites" {
  zone_id    = var.cloudflare_zone_id
  setting_id = "automatic_https_rewrites"
  value      = "on"
}
