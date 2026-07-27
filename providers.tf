# providers.tf — konfiguracja providerów.

# Cloudflare — token podawany przez zmienną środowiskową CLOUDFLARE_API_TOKEN,
# a NIE przez tfvars, żeby nie leżał na dysku w pliku konfiguracji. Zakres
# uprawnień tokenu opisany w README (sekcja „Token Cloudflare").
provider "cloudflare" {}

# GitHub — uwierzytelnianie przez GitHub App (app_auth). Identyfikatory App oraz
# ścieżka do klucza .pem pochodzą z secrets.auto.tfvars; klucz leży poza repo,
# a provider czyta jego treść (nie ścieżkę) przez file().
provider "github" {
  owner = var.github_owner

  app_auth {
    id              = var.github_app_id
    installation_id = var.github_app_installation_id
    pem_file        = file(pathexpand(var.github_app_pem_path))
  }
}
