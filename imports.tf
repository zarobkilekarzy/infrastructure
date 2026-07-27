# imports.tf — adopcja istniejących zasobów (ID odczytane z Cloudflare).
# Po udanym apply bloki można usunąć. GitHub i Web Analytics: patrz „ODROCZONE".

# --- Cloudflare Pages + magazyny ---
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

# --- Email Routing ---
import {
  to = cloudflare_email_routing_settings.this
  id = var.cloudflare_zone_id
}

import {
  to = cloudflare_email_routing_address.destination
  id = "${var.cloudflare_account_id}/840f19b2d83742b68c32de7a8f96b7b7"
}

import {
  to = cloudflare_email_routing_rule.fwd["social"]
  id = "${var.cloudflare_zone_id}/7b8249d12acf4fa490318ec7ecd4c9a0"
}

import {
  to = cloudflare_email_routing_rule.fwd["zglos"]
  id = "${var.cloudflare_zone_id}/a71bbf97336d4009a03fc8a02caf2817"
}

import {
  to = cloudflare_email_routing_rule.fwd["sprostowania"]
  id = "${var.cloudflare_zone_id}/7ab90748d9d0429d8d0cb4e2897bae49"
}

import {
  to = cloudflare_email_routing_rule.fwd["kontakt"]
  id = "${var.cloudflare_zone_id}/a669bb4ea28b401e83f992f9ca3fac07"
}

# --- Ustawienia strefy (id: "<zone_id>/<setting_id>") ---
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

# --- Turnstile ---
import {
  to = cloudflare_turnstile_widget.site
  id = "${var.cloudflare_account_id}/0x4AAAAAADnUz5UDjEbs9pOx"
}

# --- ODROCZONE ---
# Web Analytics: brak site_id (token bez „Account Analytics: Read").
# GitHub: repo istnieją, ale App bez „Administration" — po rozszerzeniu:
#   import { to = github_repository.site           id = "zarobkilekarzy.pl" }
#   import { to = github_repository.fedrowanie     id = "fedrowanie" }
#   import { to = github_repository.infrastructure id = "infrastructure" }
