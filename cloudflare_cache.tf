# cloudflare_cache.tf — reguły cache strefy (faza http_request_cache_settings).
#
# UWAGA: w Cloudflare wszystkie reguły cache strefy to JEDEN zestaw (ruleset), więc
# ten zasób przejmuje go w całości. Reguła dodana ręcznie w panelu zniknie przy
# najbliższym `apply` — nowe reguły dopisujemy tutaj.
#
# Po co: odpowiedzi Pages Functions (functions/api/*) NIE są domyślnie cache'owane na
# brzegu — sam nagłówek Cache-Control w odpowiedzi działa tylko na przeglądarkę. Ta
# reguła cache'uje GET-y liczników i statystyk egzaminu na brzegu, więc trafienie nie wywołuje Funkcji
# (nie liczy się do dziennego limitu) i nie czyta KV/D1. POST zawsze trafia do Funkcji.
resource "cloudflare_ruleset" "cache" {
  zone_id     = var.cloudflare_zone_id
  kind        = "zone"
  name        = "default"
  description = ""
  phase       = "http_request_cache_settings"

  rules = [
    {
      ref         = "826dc6db8ab64ecf97908904bdecae92" # stały identyfikator reguły — nie zmieniać
      description = "API GET -> edge cache"
      enabled     = true
      expression  = "(http.request.uri.path in {\"/api/clicks\" \"/api/sonda\" \"/api/egzamin\"} and http.request.method eq \"GET\")"
      action      = "set_cache_settings"
      action_parameters = {
        cache = true
        # Edge TTL nadpisuje max-age z odpowiedzi Funkcji; przeglądarka respektuje nagłówek.
        edge_ttl = {
          mode    = "override_origin"
          default = 300
        }
        browser_ttl = {
          mode = "respect_origin"
        }
      }
    },
  ]
}
