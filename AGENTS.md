# Agent instructions for MyAPES Website

Cursor's user rules and skills set how work is done here (branches, issues, pull requests, merge, release, deploy, ship gate, decisions and safety). This file describes this repository and fills the named slots below. If anything here disagrees with them, Cursor's rules win and this file is corrected in the same milestone.

Cursor/agent layout standard: https://github.com/apescic-director/Cursor/blob/main/docs/cursor-agent-standards.md

The owner is Bambie Murphy, Director. Write UK English (organisation, behaviour, colour, licence) in the site, docs, issues and pull requests. Never print, paste or commit secrets.

## About the app

MyAPES Website (`https://myapes.me.uk`) is the public resource and tool hub of the Association of Protecting Exotic Species CIC (APES CIC). It signposts support, care resources, community spaces, updates and the separate MyAPES Account portal.

- Repository: `APESCIC/MyAPES.Website`. Work only in this repository.

## Stack and architecture

- Static HTML, CSS and browser JavaScript served from `public/`, with one PHP page template (`public/template/layout.php`). No database and no build step for the deployed site.
- `public/.htaccess` (Apache on Cloudron) handles clean URLs, the branded 404 page and security headers. Locally, `LocalValetDriver.php` and `scripts/herd/router.php` copy those rules for Herd's nginx (see Decisions and gotchas).
- Node is used only for Browsersync live reload (`package.json`). Selected website type: static HTML, with PHP for support tooling only.

## Local development and preview

| Item | Value |
| --- | --- |
| Clone | `C:\Users\BambieMurphy\Documents\GitHub\MyAPES.Website` |
| Herd site | `myapes-website` (linked; PHP 8.4 isolated, as on Cloudron) |
| Preview URL | `http://myapes-website.test` (HTTP, not secured) |
| Preview command | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\preview.ps1` |
| HMR port | None; Browsersync live reload on `http://localhost:3101` (UI 3111) |
| Env file | None |
| Database | None (no demo seeder) |
| Mail | None |
| Set up or repair | `powershell -NoProfile -ExecutionPolicy Bypass -File scripts\herd-setup.ps1` |
| Profile | [docs/herd/profile.md](docs/herd/profile.md) (values in `docs/herd/profile.json`) |

Laravel Herd is the only local stack. Use fake demo data only (this site has none). Repo preview values: [`.cursor/rules/herd-local-dev.mdc`](.cursor/rules/herd-local-dev.mdc). Cursor's `live-preview-gate` skill owns the gate steps.

### Local development with Laravel Herd

This project runs on Laravel Herd. Run `herd site:info myapes-website` for the URL, PHP version and connected services.

- Put Herd first on `PATH` in agent shells: `$env:Path = "$env:USERPROFILE\.config\herd\bin;C:\Program Files\nodejs;$env:Path"`.
- Run checks with `php84` (Herd's PHP 8.4 shim, for example `php84 scripts/check-site.php`). `herd php` uses 8.4 but always exits 0; plain `php` is Herd's global default (8.5).
- `herd which` (in the repo root) should show `LocalValetDriver`.
- Use `herd status` if something doesn't respond; `herd list` shows every command (`--json` for structured output).

## Tests and checks

| Check | Command |
| --- | --- |
| Site checks | `php84 scripts/check-site.php` locally, `php scripts/check-site.php` in CI (VERSION, page language/title, sitemap, robots, 404 rules and root-relative `404.html` links) |
| PHP lint | `php -l public/template/layout.php` |
| Local routes | `scripts\herd-setup.ps1` checks `/VERSION` and that a missing page is 404 |
| CI workflows | `.github/workflows/` (`ci`, `milestone-version-check`, `dependency-review`, CodeQL, `release.yml`) |

## Workflow slots

Shipping follows Cursor's `github-milestone-completion` and `ship-gate` skills. This repo fills these slots:

| Slot | Value |
| --- | --- |
| Milestone branch pattern | `milestone/v<MAJOR>-<MINOR>-<PATCH>-<slug>`, printed by `php scripts/milestone-version next` |
| Version files | `VERSION`, `public/VERSION` and the footers in `scripts/MilestoneVersion/fields.json`, set by `php scripts/milestone-version bump vX.Y.Z` |
| Release tooling | Push the `vX.Y.Z` tag; `release.yml` publishes the Release |
| Release history | `CHANGELOG.md`, `public/CHANGELOG.md` and `public/change-log-hub/index.html` |
| Area labels | None |
| Issue title prefix | `[Type] Short title` |

Development is tracked only in GitHub issues, sub-issues and `vMAJOR.MINOR.PATCH` milestones — never Linear. Secrets live in APES Vault (never commit secrets).

Repo shipping rule: [`.cursor/rules/version-shipping.mdc`](.cursor/rules/version-shipping.mdc). Skills: [`complete-next-version`](.cursor/skills/complete-next-version/SKILL.md), [`release-version`](.cursor/skills/release-version/SKILL.md). Command: `/complete-next-version`.

- Work ships once per milestone by its version: one milestone branch, one draft PR into `main` with `Closes #<n>` for every issue, one merge commit, one `vX.Y.Z` tag and Release, one Cloudron deploy of that tag.
- An issue is done when its acceptance criteria are committed on the milestone branch; it closes when the milestone PR merges. Post progress with `github-closeout` (`Add-IssueUpdate.ps1`).
- Assignee `apescic-director`. Title `[Type] Short title` (`Epic`, `Story`, `Task`, `Bug`, `Chore`, `Spike`). Every issue has a milestone; ask before creating one.
- Hotfixes only with Bambie's written approval on the issue (see the shipping rule).

## Deploy and health

| Item | Value |
| --- | --- |
| Target | Cloudron LAMP app |
| Cloudron app ID | `f2c75d19-8d3b-4206-a4f5-93f4a21caad9` |
| Domain | `https://myapes.me.uk` |
| Web root | `/app/data/public` (PHP 8.4, set by `/app/data/PHP_VERSION`) |
| Deploy command | `gh workflow run deploy-cloudron.yml -f tag=vX.Y.Z` (break-glass: `deploy/cloudron/deploy.ps1 -Tag vX.Y.Z`) |
| Deploys | The release tag (never a branch) |
| Auto-deploy couplings | None: merging or releasing does not deploy |
| Health URL | `https://myapes.me.uk/VERSION` |
| Version field | The whole body, for example `3.2.4` (served as `application/octet-stream`, so decode bytes) |
| Secrets live in | APES Vault (Bitwarden); local `cloudron` CLI login for deploy |

Every Cloudron app is production. Read-only commands (status, logs) run freely. Mutating or deploy actions follow Cursor's `cloudron-ops` / `cloudron-deploy` skills and the ship gate. Don't change DNS or Cloudflare.

Security checks use GitHub's free features only: Dependabot (into the `dependencies` branch), dependency review and CodeQL. Don't add paid or third-party scanners.

## Website standards (this site)

For every public change: keep `VERSION` / `public/VERSION`, `CHANGELOG.md`, `public/CHANGELOG.md` and the Change Log Hub aligned; keep the APES footer (donation, Privacy Policy, Terms of Service, Change Log Hub, CIC No `16253848`, current version); update SEO, sitemap and Newsroom routing when pages move; keep branded accessible error pages without leaking internals. Browser-served files live under `public/`. Versions are `MAJOR.MINOR.PATCH` from the milestone title (beta status in the title, not a `b` suffix).

## Decisions and gotchas

- 2026-11-14: Laravel Herd became the only local set-up, decided by Bambie ([#18](https://github.com/APESCIC/MyAPES.Website/issues/18)).
- Herd serves with nginx, which ignores `public/.htaccess`, and its built-in static driver answers a missing page with `/index.html` and status 200. `LocalValetDriver.php` (repo root, never deployed) copies the `.htaccess` rules. Change both together.
- `public/404.html` is served at the missing URL (Apache `ErrorDocument`, and the Herd driver), so its links and assets must be root-relative (`/assets/...`), unlike the other pages ([#17](https://github.com/APESCIC/MyAPES.Website/issues/17)).
- `/VERSION` has no file extension, so `Invoke-WebRequest` returns its body as bytes; decode it before comparing ([#16](https://github.com/APESCIC/MyAPES.Website/issues/16)).
- Quick check after domain changes: `rg -n "https://beta\.apes\.me\.uk" public` should return nothing.

## Where to find things

- Most pages are static `index.html` folders; `public/template/layout.php` is the PHP page template; `public/404.html` is the branded error page.
- Local set-up: [docs/herd/profile.md](docs/herd/profile.md). Deploy: [deploy/cloudron/deploy.ps1](deploy/cloudron/deploy.ps1). Version helper: `php scripts/milestone-version help`.
- Contributing: [CONTRIBUTING.md](CONTRIBUTING.md).
- `.agents/` and `.codex/` hold Codex prompts and skills (left as-is; this file and `.cursor/` take precedence for Cursor).
