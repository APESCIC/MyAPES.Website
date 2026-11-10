# Codex Environment Setup

Use this file before running local commands for APES CIC repository work in
Codex or JetBrains workflows.

## Baseline Rules

- Do not install dependencies, CLIs, extensions, formatters, linters, package
  managers, or development servers without approval.
- Do not change workspace settings, task files, launch profiles, formatters,
  linters, or tool settings without approval.
- Do not deploy, push, merge, reset, rebase, stash, force push, delete
  branches, delete files, or run destructive database commands without explicit
  approval.
- Keep private configuration, secrets, local dumps, generated credentials, and
  private data out of repository changes.

## Tool Discovery (Codex and JetBrains)

Run the read-only discovery script before choosing validation commands (works from
Codex shell sessions and JetBrains terminals):

```powershell
pwsh .\.codex\scripts\discover-local-dev-tools.ps1
```

If `pwsh` is unavailable, use Windows PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\.codex\scripts\discover-local-dev-tools.ps1
```

Record missing tools as blockers. Do not install missing tools unless the user
explicitly approves installation.

## Validation Selection

Prefer repository-documented commands first:

- package scripts in `package.json`
- Composer scripts in `composer.json`
- Makefile targets
- CI-style commands documented in README or `.codex/`
- existing local validation scripts

Common Node checks:

```powershell
npm run lint
npm run typecheck
npm run test
npm run test:e2e
npm run build
```

Common PHP and Cloudron LAMP checks:

```powershell
php -l path\to\file.php
```

Documentation-only tasks may use Markdown review, manifest review, link review
where links exist, no-secret checks, and scope review.

## Browser Preview

For UI, website, app, route, public-folder, or visual changes:

1. Confirm the approved local preview command or local preview blocker.
2. Start the preview only when safe and in scope.
3. Open the affected route in the approved preview mechanism (Codex browser
   when available).
4. Record local URL, route notes, screenshot status, visible errors, and console
   blockers.

If no safe preview path exists, state the exact blocked-preview reason. Do not
imply visual validation passed.

## Cloudron LAMP Defaults

For APES CIC Cloudron LAMP work, assume:

- Linux
- Apache
- MySQL
- PHP 8.3 or PHP 8.4
- HTML, CSS, JavaScript
- Redis only where approved
- Apache `.htaccess`

Laragon is the only supported local set-up for this site. Run
`scripts\preview.ps1` for the live preview gate (see
`.cursor/rules/laragon-local-dev.mdc` and `docs/laragon/profile.md`).

## Template Repository Note

This `agents-template` repository is documentation/tooling only. It has no
runtime app, no public web root, no local preview route, and no deployment path.
