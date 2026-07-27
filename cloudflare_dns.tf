# cloudflare_dns.tf — rekordy DNS strefy zarobkilekarzy.pl.
#
# CELOWO PUSTE. Nie znam bieżących rekordów bez tokenu, a zgadywanie groziłoby
# nadpisaniem krytycznych wpisów: MX Email Routing, SPF/DKIM/DMARC (TXT) oraz
# A/AAAA/CNAME kierujących na Pages. Rekordy DNS adoptujemy generatorem
# konfiguracji, gdy token jest już wgrany:
#
#   1. Wypisz rekordy strefy (README → „Adopcja e-mail / DNS przez generator").
#   2. Dla każdego dodaj tymczasowo blok:
#        import {
#          to = cloudflare_dns_record.<nazwa>
#          id = "${var.cloudflare_zone_id}/<record_id>"
#        }
#   3. tofu plan -generate-config-out=cloudflare_dns.generated.tf
#   4. Przenieś wygenerowane zasoby tutaj, usuń bloki import, `tofu plan` → brak zmian.
#
# Przykładowy docelowy kształt (v5 — cloudflare_dns_record):
#
# resource "cloudflare_dns_record" "root" {
#   zone_id = var.cloudflare_zone_id
#   name    = "zarobkilekarzy.pl"
#   type    = "CNAME"
#   content = "zarobkilekarzy.pages.dev"
#   proxied = true
#   ttl     = 1   # 1 = automatic
# }
