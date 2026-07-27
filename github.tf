# github.tf — zasoby GitHub organizacji (provider = GitHub App, patrz providers.tf).
#
# ODROCZONE do czasu rozszerzenia uprawnień App. Obecnie App ma tylko
# actions/contents/workflows=write + metadata=read — BEZ „Administration" i
# „Secrets", więc nie może zarządzać ustawieniami repo, ochroną gałęzi ani
# sekretami Actions. Po nadaniu App: Repository Administration RW + Secrets RW
# (i ewentualnie Organization Administration RW do tworzenia repo) — odkomentuj
# poniższe i dodaj wpisy `import` w imports.tf (repo istnieją → adopcja).

/*
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

resource "github_repository" "infrastructure" {
  name                   = "infrastructure"
  description            = "OpenTofu — infrastruktura zarobkilekarzy.pl (Cloudflare + GitHub)."
  visibility             = "public"
  has_issues             = true
  has_wiki               = false
  has_projects           = false
  delete_branch_on_merge = true
}

# Sekrety Actions (deploy Pages) — zarządzane tylko gdy podasz wartość w
# secrets.auto.tfvars (cloudflare_deploy_api_token).
resource "github_actions_secret" "cf_api_token" {
  count           = var.cloudflare_deploy_api_token != "" ? 1 : 0
  repository      = "zarobkilekarzy.pl"
  secret_name     = "CLOUDFLARE_API_TOKEN"
  plaintext_value = var.cloudflare_deploy_api_token
}

resource "github_actions_secret" "cf_account_id" {
  count           = var.cloudflare_deploy_api_token != "" ? 1 : 0
  repository      = "zarobkilekarzy.pl"
  secret_name     = "CLOUDFLARE_ACCOUNT_ID"
  plaintext_value = var.cloudflare_account_id
}

# Ochrona gałęzi main — NIE modelować w ciemno: bieżąca ochrona dopuszcza push
# automatyki (wyjątek od PR). Zaimportuj istniejącą regułę i odtwórz bypass,
# zanim oddasz ją tofu, inaczej zablokujesz deploy.
*/
