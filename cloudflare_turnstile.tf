# cloudflare_turnstile.tf — widżet Turnstile (antybot sondy i licznika petycji).
#
# Klucze publiczny/sekret widżetu (TURNSTILE_SITE_KEY / TURNSTILE_SECRET_KEY)
# ustawiane są w panelu Pages jako zmienne środowiskowe — tofu ich TAM nie
# dotyka (Pages: ignore_changes na deployment_configs). Tu zarządzamy samą
# konfiguracją widżetu (nazwa, domeny, tryb). sitekey/secret są read-only i
# stabilne po imporcie.
resource "cloudflare_turnstile_widget" "site" {
  account_id = var.cloudflare_account_id
  name       = "zarobkilekarzy.pl"
  domains    = var.turnstile_domains
  mode       = "managed" # dopasuj do istniejącego trybu po imporcie
}
