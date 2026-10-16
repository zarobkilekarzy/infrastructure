# infrastructure

Infrastruktura zarobkilekarzy.pl jako kod — [OpenTofu](https://opentofu.org).
Jedno źródło prawdy dla zasobów Cloudflare i GitHub. Sekrety i stan **nie trafiają
do repo** — wartości wrażliwe (docelowy adres e-mail, ID konta, tokeny) podajesz
w gitignorowanym `secrets.auto.tfvars`, a stan żyje lokalnie (poza gitem).

## Co jest zarządzane

| Obszar | Zasoby |
|---|---|
| **Cloudflare Workers** | domena `zarobkilekarzy.pl` przypięta do Workera `zarobkilekarzy` (Custom Domain); kod i pliki wgrywa CI repo strony |
| **Cloudflare Pages** | projekt `zarobkilekarzy` (poprzedni hosting), KV `SONDA_KV`, D1 `zarobki-clicks` i `zarobki-egzamin` |
| **Cloudflare zona** | ustawienia bezpieczeństwa (HSTS, SSL, min TLS, always-HTTPS), rekordy DNS (reguł cache strefy brak — `/api/egzamin` cache'uje sam Worker, Cache API) |
| **Cloudflare Email Routing** | włączenie, adres docelowy, reguła przekierowania |
| **Cloudflare** | widżety Turnstile (sonda/petycja i niewidoczny dla modułu egzaminu) |
| **GitHub** | repozytoria orgu, (opcjonalnie) sekrety Actions |

Świadomie **poza** kodem (patrz komentarze w plikach):
- **rekordy DNS** i dokładne reguły e-mail — adoptowane generatorem po wgraniu tokenu,
- **bindingi i sekrety Pages** (np. klucz sekretny Turnstile) — `ignore_changes`, żeby tofu ich nie skasował,
- **ochrona `main`** — niezarządzana domyślnie, by nie zepsuć bieżącego wyjątku dla automatyki.

## Higiena sekretów

- **Stan lokalny**, `*.tfstate` w `.gitignore`. Stan zawiera wartości wrażliwe —
  trzymaj go poza repo i rób backup lokalnie.
- Wartości wrażliwe tylko w `secrets.auto.tfvars` (gitignored) i przez zmienne
  środowiskowe — nigdy w kodzie ani w commitach.

---

## Tokeny i uprawnienia

Przy stanie lokalnym potrzebujesz **jednego nowego tokenu** (Cloudflare) i
odpowiednich uprawnień **GitHub App** używanej przez providera.

### 1. Token API Cloudflare  — **wymagany, nowy**

Utwórz w panelu: **My Profile → API Tokens → Create Token → Create Custom Token**.
Ustaw dokładnie te uprawnienia (grupa „Edit" zawiera odczyt):

**Permissions — Account** (Account Resources → *Include → konkretne konto*):
| Grupa | Poziom | Po co |
|---|---|---|
| Account Settings | Read | odczyt konta przez provider |
| Turnstile | Edit | widżety Turnstile |
| Workers KV Storage | Edit | namespace `SONDA_KV` |
| D1 | Edit | bazy `zarobki-clicks`, `zarobki-egzamin` |
| Cloudflare Pages | Edit | projekt Pages, sekrety Pages (`wrangler pages secret put`) |
| Workers (dawniej Workers Scripts) | Editor (dawniej Edit) | Custom Domain Workera, sekrety Workera (`wrangler secret put`) |
| Email Routing Addresses | Edit | adres docelowy |

**Permissions — Zone** (Zone Resources → *Include → Specific zone → zarobkilekarzy.pl*):
| Grupa | Poziom | Po co |
|---|---|---|
| DNS | Edit | rekordy DNS |
| Zone Settings | Edit | HSTS/SSL/TLS + włączenie Email Routing |
| Email Routing Rules | Edit | reguła/catch-all |
| Workers Routes | Edit | Custom Domain `zarobkilekarzy.pl` → Worker |
| Zone | Read | odczyt strefy |

Podajesz go przez środowisko (nie do tfvars):
```sh
export CLOUDFLARE_API_TOKEN="..."
```

> Osobno: jeśli włączysz zarządzanie sekretem CI (`cloudflare_deploy_api_token`),
> to **wartość** sekretu Actions do deployu — może być węższa: Workers **Admin**
> (pierwszy `wrangler deploy` tworzy Workera; później wystarczy Editor). Uprawnień
> do D1 deploy z bindingiem nie potrzebuje.

### 2. GitHub — uprawnienia App

Provider GitHub uwierzytelnia się przez **GitHub App** (identyfikatory i ścieżkę
klucza podajesz w `secrets.auto.tfvars`). Żeby tofu mógł zarządzać repami/sekretami,
App potrzebuje więcej uprawnień niż do samego deployu:

**Repository permissions:**
| Uprawnienie | Poziom | Po co |
|---|---|---|
| Administration | Read & write | ustawienia repo (+ tworzenie repo `infrastructure`, jeśli przez tofu) |
| Secrets | Read & write | `github_actions_secret` (opcjonalne) |
| Metadata | Read | wymagane bazowo |
| Contents | Read & write | (typowo już nadane) |
| Workflows | Read & write | (typowo już nadane) |

**Organization permissions** — tylko jeśli chcesz, by **tofu tworzył** repo `infrastructure`:
| Uprawnienie | Poziom |
|---|---|
| Administration | Read & write |

**Instalacja** — App musi być zainstalowana na wszystkich zarządzanych repach
(`zarobkilekarzy.pl`, `fedrowanie`, `infrastructure`) albo na „All repositories".

> Bez org-Administration: utwórz puste repo `infrastructure` osobno i odkomentuj
> jego blok `import` w `imports.tf` — wtedy wystarczy repo-Administration.

### 3. Stan (R2) — **niepotrzebny**

Stan jest lokalny, więc żadne poświadczenia R2 ani bucket nie są potrzebne.

---

## Bootstrap

```sh
cd infrastructure

# 1. Zmienne (wartości wrażliwe — plik zostaje lokalnie)
cp terraform.tfvars.example secrets.auto.tfvars
$EDITOR secrets.auto.tfvars

# 2. Token Cloudflare do środowiska
export CLOUDFLARE_API_TOKEN="..."

# 3. Init
tofu init

# 4. Plan — bloki `import` z imports.tf ZAADOPTUJĄ istniejące zasoby.
#    Przeczytaj plan uważnie: ma pokazać importy + minimalne różnice, NIE tworzenie
#    od nowa czy niszczenie. Zreconciliuj rozbieżności (tytuł KV, wartości strefy).
tofu plan

# 5. Apply
tofu apply
```

### Adopcja e-mail / DNS przez generator

Rekordów DNS i dokładnych reguł e-mail nie zapisano w kodzie (żeby nie nadpisać
w ciemno). Po wgraniu tokenu:

1. Odczytaj istniejące zasoby (tymczasowy blok `import` po ID z panelu/API Cloudflare).
2. Wygeneruj konfigurację:
   ```sh
   tofu plan -generate-config-out=cloudflare_dns.generated.tf
   ```
3. Zrewiduj `*.generated.tf`, przenieś zasoby do `cloudflare_dns.tf` /
   `cloudflare_email.tf`, usuń bloki `import`, `tofu plan` → **brak zmian**.

### Import ręczny (fallback)

Zamiast bloków `import` możesz zaadoptować proceduralnie, np.:
```sh
tofu import cloudflare_workers_kv_namespace.sonda "<account_id>/e25a5a621f954438aec987306b069f1e"
tofu import github_repository.site "zarobkilekarzy.pl"
```

---

## Bezpieczeństwo / „do no harm"

- **Nigdy** nie commituj `*.tfstate`, `secrets.auto.tfvars`, `*.pem` — pilnuje tego `.gitignore`.
- Pierwszy `tofu apply` czytaj jak minę: ma **adoptować**, nie **odtwarzać**.
  Zniszczenie D1 = utrata danych; wymiana KV = utrata wyników sondy.
- `ignore_changes` na Pages `deployment_configs` chroni panelowe sekrety
  (Turnstile) przed skasowaniem — nie usuwaj tego bez powodu.
- Ochronę `main` oddaj tofu dopiero po zaimportowaniu i potwierdzeniu bieżącego
  wyjątku dla automatyki (inaczej zablokujesz deploy).
