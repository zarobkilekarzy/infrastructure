# imports.tf — adopcja istniejących zasobów, żeby tofu nimi ZARZĄDZAŁ zamiast
# tworzyć od nowa. Bloki import są deklaratywne: po udanym apply można je usunąć.
# Alternatywa proceduralna: `tofu import ...` (README → „Import ręczny").
#
# ID zasobów, których nie znam bez tokenu, są zakomentowane — uzupełnij po
# pierwszym odczycie (README → „Adopcja e-mail / DNS przez generator").

# --- Cloudflare: znane ID (KV/D1 publiczne w wrangler.toml repo strony) ---

import {
  to = cloudflare_workers_kv_namespace.sonda
  id = "${var.cloudflare_account_id}/e25a5a621f954438aec987306b069f1e"
}

import {
  to = cloudflare_d1_database.clicks
  id = "${var.cloudflare_account_id}/88106ccf-6291-4736-a4bd-37cb3cf3b692"
}

import {
  to = cloudflare_pages_project.site
  id = "${var.cloudflare_account_id}/zarobkilekarzy"
}

import {
  to = cloudflare_email_routing_settings.this
  id = var.cloudflare_zone_id
}

# --- Cloudflare: ustawienia strefy (import id: "<zone_id>/<setting_id>") ---

import {
  to = cloudflare_zone_setting.hsts
  id = "${var.cloudflare_zone_id}/security_header"
}

import {
  to = cloudflare_zone_setting.ssl
  id = "${var.cloudflare_zone_id}/ssl"
}

import {
  to = cloudflare_zone_setting.always_use_https
  id = "${var.cloudflare_zone_id}/always_use_https"
}

import {
  to = cloudflare_zone_setting.min_tls
  id = "${var.cloudflare_zone_id}/min_tls_version"
}

import {
  to = cloudflare_zone_setting.auto_https_rewrites
  id = "${var.cloudflare_zone_id}/automatic_https_rewrites"
}

# --- GitHub: istniejące repozytoria (import id = nazwa repo) ---

import {
  to = github_repository.site
  id = "zarobkilekarzy.pl"
}

import {
  to = github_repository.fedrowanie
  id = "fedrowanie"
}

# --- Do uzupełnienia po odczycie z tokenem (ID nieznane offline) ---
#
# import {
#   to = cloudflare_email_routing_address.destination
#   id = "${var.cloudflare_account_id}/<address_id>"
# }
#
# import {
#   to = cloudflare_email_routing_catch_all.this
#   id = var.cloudflare_zone_id
# }
#
# import {
#   to = cloudflare_turnstile_widget.site
#   id = "${var.cloudflare_account_id}/<sitekey>"   # sitekey = publiczny TURNSTILE_SITE_KEY
# }
#
# import {
#   to = cloudflare_web_analytics_site.site
#   id = "${var.cloudflare_account_id}/<site_id>"
# }
#
# Jeśli repo `infrastructure` już istnieje na GitHubie (utworzone wcześniej):
# import {
#   to = github_repository.infrastructure
#   id = "infrastructure"
# }
