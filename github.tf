# github.tf — repozytoria organizacji zarobkilekarzy (zaadoptowane).
# Config = bieżący stan repo (generate-config-out); tofu = źródło prawdy dla
# ustawień repo. Ochrona gałęzi main NIEzarządzana (patrz koniec pliku).


resource "github_repository" "fedrowanie" {
  allow_auto_merge            = false
  allow_forking               = true
  allow_merge_commit          = true
  allow_rebase_merge          = true
  allow_squash_merge          = true
  allow_update_branch         = false
  archive_on_destroy          = null
  archived                    = false
  auto_init                   = false
  delete_branch_on_merge      = false
  description                 = ""
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  homepage_url                = ""
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "fedrowanie"
  source_owner                = ""
  source_repo                 = ""
  squash_merge_commit_message = "COMMIT_MESSAGES"
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  topics                      = []
  visibility                  = "public"
  web_commit_signoff_required = false
  security_and_analysis {
    secret_scanning {
      status = "disabled"
    }
    secret_scanning_push_protection {
      status = "disabled"
    }
  }
}

resource "github_repository" "infrastructure" {
  allow_auto_merge            = false
  allow_forking               = true
  allow_merge_commit          = true
  allow_rebase_merge          = true
  allow_squash_merge          = true
  allow_update_branch         = false
  archive_on_destroy          = null
  archived                    = false
  auto_init                   = false
  delete_branch_on_merge      = false
  description                 = ""
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = true
  has_wiki                    = true
  homepage_url                = ""
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "infrastructure"
  source_owner                = ""
  source_repo                 = ""
  squash_merge_commit_message = "COMMIT_MESSAGES"
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  topics                      = []
  visibility                  = "public"
  web_commit_signoff_required = false
  security_and_analysis {
    secret_scanning {
      status = "disabled"
    }
    secret_scanning_push_protection {
      status = "disabled"
    }
  }
}

resource "github_repository" "site" {
  allow_auto_merge            = false
  allow_forking               = true
  allow_merge_commit          = true
  allow_rebase_merge          = true
  allow_squash_merge          = true
  allow_update_branch         = false
  archive_on_destroy          = null
  archived                    = false
  auto_init                   = false
  delete_branch_on_merge      = false
  description                 = ""
  gitignore_template          = null
  has_discussions             = false
  has_issues                  = true
  has_projects                = false
  has_wiki                    = false
  homepage_url                = ""
  is_template                 = false
  license_template            = null
  merge_commit_message        = "PR_TITLE"
  merge_commit_title          = "MERGE_MESSAGE"
  name                        = "zarobkilekarzy.pl"
  source_owner                = ""
  source_repo                 = ""
  squash_merge_commit_message = "COMMIT_MESSAGES"
  squash_merge_commit_title   = "COMMIT_OR_PR_TITLE"
  topics                      = []
  visibility                  = "public"
  web_commit_signoff_required = false
  security_and_analysis {
    secret_scanning {
      status = "disabled"
    }
    secret_scanning_push_protection {
      status = "disabled"
    }
  }
}

# Skill dla agentów AI: asystent autorów tekstów dla serwisu (pliki tekstowe + skrypt podglądu)
resource "github_repository" "writer_kit" {
  name          = "zarobkilekarzy-writer-kit"
  description   = "Skill dla Claude Code i Codex: asystent autora tekstów dla zarobkilekarzy.pl — zasady redakcyjne, styl, źródła"
  homepage_url  = "https://zarobkilekarzy.pl"
  visibility    = "public"
  has_issues    = true
  has_projects  = false
  has_wiki      = false
  allow_forking = true
  auto_init     = false
}

# --- Sekrety Actions (deploy Pages) ---
# Zarządzane tylko gdy podasz cloudflare_deploy_api_token w secrets.auto.tfvars
# (inaczej count=0 — tofu nie dotyka istniejących sekretów CI).
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

# --- Ochrona gałęzi main (NIEZARZĄDZANA) ---
# Bieżąca ochrona dopuszcza push automatyki (wyjątek od PR). Błędne odwzorowanie
# tego wyjątku zablokowałoby deploy — zaimportuj i odtwórz bypass (github_repository_ruleset
# z bypass_actors) zanim oddasz ochronę tofu.
