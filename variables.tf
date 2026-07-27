# variables.tf — wejścia. Wartości wrażliwe NIE mają default — podajesz je
# w secrets.auto.tfvars (gitignored). Zob. terraform.tfvars.example.

variable "cloudflare_account_id" {
  type        = string
  description = "ID konta Cloudflare — dla zasobów account-scoped (Pages, KV, D1, Turnstile, Web Analytics, adresy Email Routing). Nietajne (losowy identyfikator), ale trzymane w secrets.auto.tfvars poza repo. NIE sensitive — inaczej nie da się użyć w import.id."
}

variable "cloudflare_zone_id" {
  type        = string
  description = "ID strefy zarobkilekarzy.pl — dla zasobów zone-scoped (DNS, ustawienia strefy, reguły Email Routing)."
}

variable "email_forward_destination" {
  type        = string
  description = "Docelowy adres, na który Email Routing przekierowuje pocztę z domeny. Wartość prywatna — wyłącznie w secrets.auto.tfvars (gitignored), nigdy w kodzie."
  sensitive   = true
}

variable "turnstile_domains" {
  type        = list(string)
  description = "Domeny dozwolone dla widżetu Turnstile."
  default     = ["zarobkilekarzy.pl"]
}

# --- GitHub (bot GitHub App) ---

variable "github_owner" {
  type        = string
  description = "Organizacja GitHub."
  default     = "zarobkilekarzy"
}

variable "github_app_id" {
  type        = string
  description = "ID GitHub App używanej do automatyzacji (wartość w secrets.auto.tfvars)."
}

variable "github_app_installation_id" {
  type        = string
  description = "Installation ID App w organizacji (wartość w secrets.auto.tfvars)."
}

variable "github_app_pem_path" {
  type        = string
  description = "Ścieżka do klucza prywatnego .pem GitHub App (poza repo)."
}

# --- Opcjonalne: sekrety CI ---

variable "cloudflare_deploy_api_token" {
  type        = string
  description = "Wartość sekretu Actions CLOUDFLARE_API_TOKEN dla deployu Pages. Pusty ciąg = tofu NIE zarządza tym sekretem (count=0)."
  sensitive   = true
  default     = ""
}
