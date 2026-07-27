# github.tf — zasoby GitHub organizacji. Provider uwierzytelnia się przez
# GitHub App (patrz providers.tf).

# --- Repozytoria ---
# zarobkilekarzy.pl i fedrowanie JUŻ istnieją → adoptujemy przez import (imports.tf).
# Pola opisowe (description/topics/homepage/pages) IGNOROWANE: nie znam ich
# bieżących wartości, a nie chcę ich nadpisać pustką.

resource "github_repository" "site" {
  name       = "zarobkilekarzy.pl"
  visibility = "public"

  lifecycle {
    ignore_changes = [description, topics, homepage_url, pages]
  }
}

resource "github_repository" "fedrowanie" {
  name       = "fedrowanie"
  visibility = "public"

  lifecycle {
    ignore_changes = [description, topics, homepage_url]
  }
}

# To repo. Jeśli jeszcze nie istnieje na GitHubie, tofu utworzy je przy pierwszym
# apply (wymaga uprawnienia App „Administration" na poziomie ORG — patrz README).
# Alternatywa bez tego uprawnienia: utwórz puste repo osobno i zaimportuj
# (odkomentuj wpis w imports.tf).
resource "github_repository" "infrastructure" {
  name                   = "infrastructure"
  description            = "OpenTofu — infrastruktura zarobkilekarzy.pl (Cloudflare + GitHub)."
  visibility             = "public"
  auto_init              = false
  has_issues             = true
  has_wiki               = false
  has_projects           = false
  delete_branch_on_merge = true
}

# --- Sekrety Actions (deploy Pages) ---
# Zarządzane TYLKO gdy podasz wartość w secrets.auto.tfvars. Domyślnie count=0 —
# tofu nie dotyka istniejących sekretów CI.
resource "github_actions_secret" "cf_api_token" {
  count           = var.cloudflare_deploy_api_token != "" ? 1 : 0
  repository      = github_repository.site.name
  secret_name     = "CLOUDFLARE_API_TOKEN"
  plaintext_value = var.cloudflare_deploy_api_token
}

resource "github_actions_secret" "cf_account_id" {
  count           = var.cloudflare_deploy_api_token != "" ? 1 : 0
  repository      = github_repository.site.name
  secret_name     = "CLOUDFLARE_ACCOUNT_ID"
  plaintext_value = var.cloudflare_account_id
}

# --- Ochrona gałęzi main (NIEZARZĄDZANA domyślnie) ---
# Bieżąca ochrona `main` w zarobkilekarzy.pl dopuszcza bezpośredni push przez
# używaną automatyzację (wyjątek od wymogu PR). Błędne odwzorowanie tego wyjątku
# przez tofu ZABLOKOWAŁOBY deploy, dlatego świadomie tego nie modelujemy w ciemno.
# Aby oddać ochronę pod tofu:
#   1. Zaimportuj istniejącą regułę i zobacz realny kształt:
#        tofu import github_repository_ruleset.main "zarobkilekarzy.pl:<ruleset_id>"
#      (lub github_branch_protection, jeśli to klasyczna ochrona)
#   2. Odtwórz wyjątek (bypass_actors) i dopiero wtedy zarządzaj deklaratywnie.
