# cloudflare_email.tf — Email Routing domeny zarobkilekarzy.pl.
#
# Docelowy adres przekierowania (var.email_forward_destination) to wartość
# wrażliwa — z secrets.auto.tfvars (gitignored), tylko w lokalnym stanie.
# UWAGA: konto Cloudflare jest współdzielone z innymi projektami — tu zarządzamy
# WYŁĄCZNIE regułami domeny zarobkilekarzy.pl i jej adresem docelowym.

resource "cloudflare_email_routing_settings" "this" {
  zone_id = var.cloudflare_zone_id
}

# Zweryfikowany adres docelowy (konto-level), na który kierują reguły poniżej.
resource "cloudflare_email_routing_address" "destination" {
  account_id = var.cloudflare_account_id
  email      = var.email_forward_destination
}

# Reguły: konkretne adresy @zarobkilekarzy.pl -> adres docelowy.
# Catch-all w CF jest wyłączony/drop — świadomie nim nie zarządzamy.
locals {
  email_forward_sources = {
    social       = "social@zarobkilekarzy.pl"
    zglos        = "zglos@zarobkilekarzy.pl"
    sprostowania = "sprostowania@zarobkilekarzy.pl"
    kontakt      = "kontakt@zarobkilekarzy.pl"
  }
}

resource "cloudflare_email_routing_rule" "fwd" {
  for_each = local.email_forward_sources

  zone_id = var.cloudflare_zone_id
  enabled = true
  name    = ""

  matchers = [{
    type  = "literal"
    field = "to"
    value = each.value
  }]

  actions = [{
    type  = "forward"
    value = [var.email_forward_destination]
  }]
}
