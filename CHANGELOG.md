# Changelog

This changelog records repository, continuous-integration and hosting changes
for the MyAPES Website. Public-facing release details are maintained separately
in [`public/CHANGELOG.md`](public/CHANGELOG.md) and presented through the
[Change Log Hub](https://myapes.me.uk/change-log-hub/).

## [3.2.4] - 2026-11-14

Status: Beta (carried by the milestone title, `v3.2.4 Patch: Deploy and 404 fixes`)

Change type: Patch

Summary: Deploy and 404 fixes. Laravel Herd replaces Laragon for local
development, missing pages return a real 404 status, and the deploy script
reads the live version correctly.

Repository changes:

- Laravel Herd is the only local set-up (#18): `LocalValetDriver.php` and
  `scripts/herd/router.php` copy the `public/.htaccess` clean URLs, 404 status
  and security headers for Herd's nginx; `scripts/herd-setup.ps1` replaces
  `scripts/laragon-setup.ps1`; `scripts/preview.ps1` checks Herd; `docs/herd/`
  replaces `docs/laragon/`; `.cursor/rules/herd-local-dev.mdc` replaces
  `laragon-local-dev.mdc`; Laragon is removed from the docs, skills and notes.
- `AGENTS.md` follows the repo agent template, with Cursor's precedence
  paragraph, workflow slots, deploy and health details, and gotchas.
- `public/.htaccess` ends with `RewriteRule ^ - [R=404,L]` so `ErrorDocument`
  serves the branded page with status 404; `public/404.html` uses root-relative
  links and assets; `scripts/check-site.php` guards both (#17).
- `deploy/cloudron/deploy.ps1` decodes the `/VERSION` byte body and adds
  `-KeepLiveFiles` (#16).

Release records:

- Repository and public version: `3.2.4` (shown as `v3.2.4` in footers).

Validation:

- `php scripts/check-site.php`, CI on the milestone PR, and the Herd preview at
  `http://myapes-website.test` (Browsersync on `http://localhost:3101`).
- After the deploy: `https://myapes.me.uk/VERSION` shows `3.2.4` and a missing
  page returns 404.

## [3.2.3] - 2026-11-10

Status: Beta (carried by the milestone title, `v3.2.3 Beta: Repo standards`)

Change type: Patch

Summary: Repository standards. Laragon is the only local set-up, versions come
from the milestone version, each version ships once, and security checks use
GitHub's free features only.

Repository changes:

- Laragon profile (`docs/laragon/`), `scripts/laragon-setup.ps1` and the live
  preview gate `scripts/preview.ps1`, with Browsersync live reload on port 3101.
  The `php -S` instructions are gone.
- `scripts/milestone-version` (`next`, `bump`, `check-title`, `check-branch`,
  `check-release`); `VERSION` is now plain semver (`3.2.3`).
- `.cursor/rules/version-shipping.mdc`, the `complete-next-version` and
  `release-version` skills, and a shorter `AGENTS.md`.
- `deploy/cloudron/deploy.ps1 -Tag` with backup, swap, `/VERSION` check and
  rollback; `release.yml` publishes the Release from the tag.
- CI: site checks, PHP lint, PR title and branch checks, dependency review,
  CodeQL and Dependabot into the `dependencies` branch.

Release records:

- Repository and public version: `3.2.3` (shown as `v3.2.3` in footers).

Validation:

- `php scripts/check-site.php`, CI on the milestone PR, and the Laragon preview
  at `http://myapes-website.test`.
## v3.2.2b - 2026-08-19

Status: Beta

Change type: Patch

Summary: Updated public contact details on the MyAPES website and added
client-side protection so the public email is not harvestable from page source.

Repository changes:

- Added root `VERSION` aligned with the public website patch `v3.2.2b`.
- Documented the postal address and new telephone in `README.md`, and pointed
  readers to the Contact page for the protected public email.

Public site changes:

- See [`public/CHANGELOG.md`](public/CHANGELOG.md) for the public contact,
  footer, harvest-protection and sitemap details.

Release records:

- Repository version: `v3.2.2b`.
- Public version and history: [`public/VERSION`](public/VERSION) and
  [`public/CHANGELOG.md`](public/CHANGELOG.md).

Validation:

- `php -l public/template/layout.php`
- Source assertions for the new address and telephone, absence of the old 0300
  number, and absence of a concatenated public email in `public/`
- Local preview of `/contact/`, `/` and `/privacy/`

## v3.2.0b - 2026-07-01

Status: Beta

Change type: Minor beta update

Summary: Public website theme, support routing and version records for
`v3.2.0b` are recorded in [`public/CHANGELOG.md`](public/CHANGELOG.md).
