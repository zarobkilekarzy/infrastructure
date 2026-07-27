# cloudflare_email.tf — Email Routing domeny.
#
# Docelowy adres przekierowania (var.email_forward_destination) to wartość
# wrażliwa — pochodzi z secrets.auto.tfvars (gitignored) i trafia tylko do
# lokalnego stanu, nigdy do repo.
#
# Adres docelowy i reguły JUŻ istnieją (odbierasz pocztę) i wymagają weryfikacji
# mailowej przy tworzeniu — dlatego ADOPTUJEMY je przez import, nie tworzymy od
# nowa. ID adresu/reguły odczytasz dopiero z tokenem (patrz imports.tf + README).

# Włączenie Email Routing dla strefy.
resource "cloudflare_email_routing_settings" "this" {
  zone_id = var.cloudflare_zone_id
}

# Zweryfikowany adres docelowy (na koncie).
resource "cloudflare_email_routing_address" "destination" {
  account_id = var.cloudflare_account_id
  email      = var.email_forward_destination
}

# Reguła: cała poczta z domeny → adres docelowy.
# Zakładam catch-all (najczęstszy układ dla pojedynczego przekierowania). Jeśli
# masz zamiast tego reguły na konkretne adresy (np. kontakt@), zamień ten zasób
# na cloudflare_email_routing_rule i wygeneruj go z istniejącego stanu (README →
# „Adopcja e-mail / DNS przez generator").
resource "cloudflare_email_routing_catch_all" "this" {
  zone_id = var.cloudflare_zone_id
  enabled = true
  name    = "catch-all -> destination"

  matchers = [{
    type = "all"
  }]

  actions = [{
    type  = "forward"
    value = [var.email_forward_destination]
  }]
}
