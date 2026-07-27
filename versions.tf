# versions.tf — wersje OpenTofu i providerów + backend stanu.

terraform {
  required_version = ">= 1.9.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.22"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }

  # Stan LOKALNY, poza gitem (patrz .gitignore). Stan zawiera rozwinięte wartości
  # wrażliwe (m.in. adres docelowy Email Routing i sekrety) — więc NIGDY nie
  # trafia do repo. Utrata pliku = tofu zapomina, czym zarządza; odzysk przez
  # `import` (patrz imports.tf / README). Backup pliku stanu rób poza repo.
  backend "local" {
    path = "terraform.tfstate"
  }
}
