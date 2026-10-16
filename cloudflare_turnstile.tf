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

# Widżet NIEWIDOCZNY dla zapisu wyniku modułu /egzamin-lek: wynik wysyła się
# automatycznie po zakończeniu testu, więc weryfikacja nie może wymagać kliknięcia.
# Tryb jest cechą widżetu (nie wywołania), stąd osobny widżet. Klucz publiczny jest
# zmienną Workera (wrangler.jsonc), sekretny — sekretem Workera TURNSTILE_EGZAMIN_SECRET_KEY.
resource "cloudflare_turnstile_widget" "egzamin" {
  account_id = var.cloudflare_account_id
  name       = "zarobkilekarzy.pl — egzamin"
  domains    = var.turnstile_domains
  mode       = "invisible"
}
