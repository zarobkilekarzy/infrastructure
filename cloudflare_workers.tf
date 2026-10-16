# cloudflare_workers.tf — strona działa jako Worker ze statycznymi plikami (następca projektu Pages).
# Kod i assety wgrywa CI repo strony (`wrangler deploy`, konfiguracja w wrangler.jsonc).
# Tu zarządzamy tylko przypięciem domeny — DNS jest po stronie infrastruktury, nie kodu.
#
# Custom Domain sam tworzy rekord DNS dla zarobkilekarzy.pl i nie powstanie, dopóki istnieje
# stary CNAME na zarobkilekarzy.pages.dev — dlatego przełączenie w dwóch krokach:
#   1. ./tofu-env.sh apply -target=cloudflare_dns_record.root   (usuwa stary CNAME)
#   2. ./tofu-env.sh apply                                      (przypina domenę do Workera)
# Między krokami strona nie odpowiada (zwykle < 1 min). Worker `zarobkilekarzy` musi już istnieć
# (pierwszy deploy z CI) i mieć sekret TURNSTILE_EGZAMIN_SECRET_KEY.
# Powrót na Pages: usuń ten zasób i przywróć rekord root z historii pliku cloudflare_dns.tf.
resource "cloudflare_workers_custom_domain" "site" {
  account_id = var.cloudflare_account_id
  zone_id    = var.cloudflare_zone_id
  hostname   = "zarobkilekarzy.pl"
  service    = "zarobkilekarzy"
}
