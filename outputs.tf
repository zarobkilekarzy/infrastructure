# outputs.tf — przydatne identyfikatory. Wartości mogące być wrażliwe oznaczone
# sensitive (nie pokażą się w logu planu/apply).

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

output "turnstile_sitekey" {
  description = "Publiczny klucz widżetu Turnstile (TURNSTILE_SITE_KEY)."
  value       = cloudflare_turnstile_widget.site.sitekey
}

output "web_analytics_site_token" {
  description = "Token beacona Web Analytics."
  value       = cloudflare_web_analytics_site.site.site_token
  sensitive   = true
}
