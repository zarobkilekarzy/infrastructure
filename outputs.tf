# outputs.tf — przydatne identyfikatory.

output "pages_project_name" {
  description = "Nazwa projektu Cloudflare Pages."
  value       = cloudflare_pages_project.site.name
}

output "kv_namespace_id" {
  description = "ID namespace KV (SONDA_KV) — publiczne."
  value       = cloudflare_workers_kv_namespace.sonda.id
}

output "d1_database_id" {
  description = "ID bazy D1 (zarobki-clicks) — publiczne."
  value       = cloudflare_d1_database.clicks.id
}

output "d1_egzamin_database_id" {
  description = "ID bazy D1 (zarobki-egzamin) — publiczne."
  value       = cloudflare_d1_database.egzamin.id
}

output "d1_sor_database_id" {
  description = "ID bazy D1 (zarobki-sor, kolejki na SOR) — publiczne; wpisywane w workers/sor/wrangler.jsonc repo strony."
  value       = cloudflare_d1_database.sor.id
}

output "turnstile_egzamin_sitekey" {
  description = "Publiczny klucz niewidocznego widżetu Turnstile modułu egzaminu."
  value       = cloudflare_turnstile_widget.egzamin.sitekey
}

output "turnstile_egzamin_secret" {
  description = "Sekret widżetu Turnstile modułu egzaminu (sekret Workera TURNSTILE_EGZAMIN_SECRET_KEY)."
  value       = cloudflare_turnstile_widget.egzamin.secret
  sensitive   = true
}

output "turnstile_sitekey" {
  description = "Publiczny klucz widżetu Turnstile (TURNSTILE_SITE_KEY)."
  value       = cloudflare_turnstile_widget.site.sitekey
}

# web_analytics_site_token — ODROCZONE razem z zasobem (patrz cloudflare_analytics.tf).
