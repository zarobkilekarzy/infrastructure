# cloudflare_sor.tf — dane o kolejkach na SOR (szpitalnych oddziałach ratunkowych).
#
# Worker zarobkilekarzy-sor (repo strony, katalog workers/sor/) co 2 minuty pobiera kolejki
# z pacjent.gov.pl i zapisuje je do bazy D1, a pod https://dane.zarobkilekarzy.pl/sor/teraz.json
# podaje stronie ostatnią migawkę (z minutowym cache Workera). Kod wgrywa repo strony
# (`wrangler deploy -c workers/sor/wrangler.jsonc`); tu tylko baza i przypięcie domeny.
#
# Pierwsze wdrożenie w trzech krokach (Custom Domain wymaga istniejącego Workera):
#   1. ./tofu-env.sh apply -target=cloudflare_d1_database.sor    (baza; ID: tofu output d1_sor_database_id)
#   2. wpisać ID do workers/sor/wrangler.jsonc i wdrożyć Workera (crony puste — niczego nie odpytuje)
#   3. ./tofu-env.sh apply                                       (domena dane.zarobkilekarzy.pl → Worker)

# Migawka i archiwum pomiarów. Odtworzenie bazy = utrata archiwum, więc tylko adopcja/zmiany w miejscu.
resource "cloudflare_d1_database" "sor" {
  account_id = var.cloudflare_account_id
  name       = "zarobki-sor"
  read_replication = {
    mode = "disabled"
  }
}

# Publiczny adres danych. Custom Domain sam zakłada rekord DNS i certyfikat (rekordu
# dane.zarobkilekarzy.pl nie ma w cloudflare_dns.tf i nie może go tam być).
resource "cloudflare_workers_custom_domain" "sor" {
  account_id = var.cloudflare_account_id
  zone_id    = var.cloudflare_zone_id
  hostname   = "dane.zarobkilekarzy.pl"
  service    = "zarobkilekarzy-sor"
}
