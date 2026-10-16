# cloudflare_pages.tf — hosting strony: projekt Pages + jego magazyny (KV, D1).
# Wszystkie trzy zasoby JUŻ istnieją — adoptujemy je przez import (imports.tf),
# nie tworzymy od nowa.

# Workers KV — wyniki sondy (binding SONDA_KV). ID jest publiczne (widnieje też
# w wrangler.toml repo strony), więc nie jest sekretem.
resource "cloudflare_workers_kv_namespace" "sonda" {
  account_id = var.cloudflare_account_id
  title      = "zarobkilekarzy-SONDA_KV" # dopasuj do faktycznego tytułu po imporcie (tofu plan pokaże ewentualną różnicę)
}

# D1 — liczniki przejść do źródeł (binding CLICKS_DB).
resource "cloudflare_d1_database" "clicks" {
  account_id = var.cloudflare_account_id
  name       = "zarobki-clicks"
  read_replication = {
    mode = "disabled" # stan bieżący — bez replik
  }
}

# D1 — anonimowe, zbiorcze wyniki modułu /egzamin-lek (binding EGZAMIN_DB).
# Jeden wiersz na ukończony test: sesja, tryb, punkty, czas, dzień — bez IP,
# bez identyfikatorów. Osobna baza, żeby liczniki przejść i wyniki egzaminu
# miały niezależny cykl życia (czyszczenie/eksport jednej nie dotyka drugiej).
resource "cloudflare_d1_database" "egzamin" {
  account_id = var.cloudflare_account_id
  name       = "zarobki-egzamin"
  read_replication = {
    mode = "disabled"
  }
}

# Pages — projekt hostujący stronę. Assety wgrywa CI (`wrangler pages deploy`),
# więc tofu pilnuje wyłącznie ISTNIENIA projektu i gałęzi produkcyjnej.
#
# deployment_configs / build_config są CELOWO ignorowane: niosą bindingi
# dopisywane przez CI oraz sekrety ustawiane w panelu (TURNSTILE_SECRET_KEY itp.).
# Gdyby tofu nimi zarządzał, mógłby skasować sekrety spoza swojego zasięgu.
resource "cloudflare_pages_project" "site" {
  account_id        = var.cloudflare_account_id
  name              = "zarobkilekarzy"
  production_branch = "main"

  lifecycle {
    ignore_changes = [deployment_configs, build_config]
  }
}
