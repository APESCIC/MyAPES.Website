# APES CIC Agent Instructions for Codex and JetBrains

Use this file as the durable APES CIC repository guidance for Codex-first and
JetBrains-assisted local work. It is intentionally repository-safe: it contains
no credentials, private configuration, environment values, database dumps,
generated secrets, API keys, private keys, OAuth secrets, or production
operational values.

## 1. Instruction Priority

Load this file before work starts, then read any task-relevant local guidance:
root or nested `AGENTS.md`, `INSTRUCTIONS.md`, `README.md`, `CONTRIBUTING.md`,
issue text, package files, Composer files, build files, task files, and
configuration files.

Directory routing:

- Codex/JetBrains setup, scripts, prompts, and workflow docs live in
  `/.codex/`.
- GitHub files live in `/.github/`.
- Agent guidance, manifests, and skills live in `/.agents/`.

Priority order:

1. User-approved task scope and current user instructions.
2. Security, privacy, UK GDPR, branch protection, no-secrets, no-destructive
   actions, and no-deployment rules in this file.
3. Repository-specific guidance that does not weaken APES CIC safeguards.
4. Tool-specific Codex and JetBrains rules.
5. General preferences and templates in this file.

If local guidance conflicts with this file, follow the stricter APES CIC
safety, compliance, validation, documentation, versioning, changelog, Change
Log Hub, public-folder, SEO, sitemap, footer, error-page, and Cloudron LAMP
requirement unless the user explicitly approves a safe exception.

## 2. Core Rule

Use this rule for every APES CIC repository task:

```text
No issue decision, no branch decision, no direct work on main, no state changing Git action without approval.
```

Default base branch: `main`. New working and development branches must use
`codex/<short-description>` unless the user explicitly approves and records a
different base branch or branch name.

## 3. Non-Negotiable Safeguards

Before planning or editing, Codex and JetBrains-assisted workflows must:

1. Confirm the active repository or workspace.
2. Confirm the current branch.
3. Check whether the branch is `main`, legacy `master`, `production`,
   `staging`, a release branch, protected, shared, or long lived.
4. Check for uncommitted changes.
5. Never overwrite user work.
6. Read relevant repository guidance and relevant source files.
7. Use workspace, repository, or file search before editing.
8. Prefer documented scripts, package scripts, Composer scripts, Makefiles, and
   existing tooling over invented commands.
9. Keep implementation inside approved scope.
10. Stop and ask before expanding scope.
11. Never edit protected or shared branches directly.
12. Never deploy automatically.
13. Never install tools, extensions, packages, dependencies, formatters,
    linters, CLIs, or development servers without approval.
14. Never change workspace settings, recommended tools, task files, launch
    profiles, formatters, linters, or tool settings without approval.
15. Never reset, rebase, stash, force push, delete branches, delete files, run
    destructive database commands, close an issue, or enable auto-merge without
    explicit approval.
16. Keep private configuration, private data, generated credential files, local
    database dumps, secrets, and unrelated changes out of repository changes.
17. Show changed-file summaries, validation results, risks, and proposed next
    steps before state-changing Git actions or destructive operations.
18. Run `.codex/scripts/discover-local-dev-tools.ps1` where available before
    choosing validation commands, and record missing tools as blockers instead
    of installing them.
19. For UI, website, app, route, public-folder, or visual changes, use the
    approved local preview path where available, start it only when safe and in
    scope, inspect affected routes in the approved preview workflow (Codex browser
    when available), and record preview evidence or the exact blocker.

If safety is uncertain, pause and provide clear options.

## 4. Standard Flow

Default flow:

```text
Understand request -> Inspect repository -> Review Codex/JetBrains environment
guidance -> Ask grouped decisions -> Issue decision -> Branch decision -> Plan ->
User approval -> Implement -> Update issue where relevant -> Validate -> Review
diff -> Completion summary
```

Do not skip a stage unless the user explicitly approves the skip, or the task
is trivial and the safe assumption is recorded.

For multi-phase work, define named phases in the plan. At each phase boundary,
summarize completed phases, the current phase just completed, the next proposed
phase, upcoming phases, blockers or scope changes, and validation or
issue-update status where relevant. Ask before continuing if the next phase
changes scope or requires a separate approval.

## 5. Required Decisions for Non-Trivial Work

For non-trivial, public-facing, operational, compliance, security, hosting,
migration, release, data, or audit-relevant work, obtain or record these
decisions before implementation:

1. Update type: feature, bug fix, cleanup, migration, refactor, documentation,
   security, compliance, hosting, urgent hotfix, or custom.
2. Website type: static website, PHP website, MySQL database website, CMS,
   custom portal, small web application, migration, merge, documentation only,
   or custom.
3. Issue decision: create a new issue, use an existing issue, update an
   existing issue, or record no issue with reason.
4. Branch decision: create a new `codex/<short-description>` task branch from
   `main`, create a branch from another explicitly approved base, use an
   existing safe `codex/` task branch, or record no branch because the task is
   planning or text only.
5. Scope and non-scope.
6. Environment concerns: Cloudron, MySQL, Redis, LDAP, email, rewrite rules,
   private configuration, Windows, Linux, local execution, deployment, or
   hosting.
7. Local execution environment or blocker.
8. Route preview (Codex browser or equivalent) requirement or blocker for UI,
   website, app, route, public-folder, or visual changes.
9. Validation required before handoff.

## 6. Required Planning Response

Before editing files, answer in this structure:

```text
Issue decision:
Branch decision:
Current repository and branch:
Working tree state:
Update type:
Website type:
Hosting target:
Local execution environment:
Local validation status:
Route preview evidence (Codex browser or equivalent):
Environment notes:
Files likely to change:
Implementation plan:
Work update plan:
Risks:
Validation:
Questions before implementation:
```

The plan must confirm protected branch status, default base branch `main`,
`codex/<short-description>` branch naming, private configuration protection,
expected files to change, checks to run, release-record impact, README impact,
changelog impact, Change Log Hub impact, public-folder impact, SEO impact,
sitemap impact, footer impact, error-page impact, issue status, pull-request
update expectations, branch expectations, merge expectations, issue-closure
prompt expectations, and cleanup expectations where relevant.

For UI, website, app, route, public-folder, or visual changes, the plan must
also state the approved local preview command, expected route inspection method
(Codex browser when available), and fallback wording if preview cannot start or
open safely.

Do not implement until the user approves the plan or explicitly says to start
implementation.

## 7. Issue Handling

Create, link, update, or explicitly defer a GitHub issue before real work when
the task is non-trivial, public-facing, operationally relevant, compliance
relevant, security relevant, release relevant, hosting relevant, migration
relevant, or likely to need an audit trail.

Issue options:

```text
1. Recommended for non-trivial work: create a new GitHub issue.
2. Use an existing issue and provide the issue number.
3. Update an existing issue and provide the issue number.
4. Do not record an issue for this task, with a short reason.
5. Custom: tell me another issue process.
```

Issue bodies must include summary, reason, update type, website type or
documentation-only status, scope and non-scope, requirements, acceptance
criteria, testing required, release impact, hosting impact, local execution
impact, public-folder impact where relevant, and metadata where available.

Creating or drafting an issue is not approval to implement, branch, assign,
post work-started updates, edit files, push, or merge.

When using an issue, update it at approved-scope, branch, meaningful progress or
blockers, changed-files and validation, and completion checkpoints. If an open
pull request exists, keep it aligned with the issue.

Do not post secrets, private data, protected service details, sensitive case
information, or confidential operational notes in public issues or pull
request comments.

## 8. Branch Handling

Create a task branch for repository changes unless the task is planning only,
issue text only, or the user explicitly chooses no repository changes.

Branch options:

```text
1. Recommended for repository changes: create a new `codex/<short-description>` task branch from `main`.
2. Create a new `codex/<short-description>` task branch from another explicitly approved base branch.
3. Use an existing `codex/` task branch after confirming it is safe.
4. Do not create a branch because this is planning, review, or text only.
5. Custom: provide a branch name and base branch.
```

Before creating, publishing, deleting, or switching branches, check current
branch, working tree state, base branch, local and remote branch existence, and
uncommitted changes.

## 9. Local Execution and Validation

Read `.codex/CODEX_ENVIRONMENT_SETUP.md` where it exists before repository
work. Use documented setup scripts, task definitions, CI-style commands, or
repository guidance before inventing commands.

Run `.codex/scripts/discover-local-dev-tools.ps1` where present to identify
existing local tools such as Git, GitHub CLI, Node.js, PHP, Laravel Herd and
browsers. Treat the inventory as read-only evidence, not permission to install
missing tools, change settings, alter PATH or connect to protected services.

Laravel Herd is the only supported local set-up. Run the live preview gate,
`scripts\preview.ps1`, before any change: it checks Herd serves
`http://myapes-website.test` from `public/` and starts Browsersync on
`http://localhost:3101`. Inspect
affected routes there (Codex browser when available) and record route notes,
screenshot status, and console or visible errors. If the preview cannot run,
record the exact blocker. The root `AGENTS.md` and `.cursor/rules/` take
precedence over this file.

Common Node checks:

```bash
npm run lint
npm run typecheck
npm run test
npm run test:e2e
npm run build
```

Common PHP and Cloudron LAMP checks:

```bash
php -l path/to/file.php
```

Documentation-only validation may be limited to Markdown review, link review
where links exist, scope review, and secret inspection.

## 10. Documentation, Version, and Release Records

During planning for repository work, verify these files or records where they
exist and are relevant:

- `README.md`
- root `VERSION`
- `public/VERSION`
- root `CHANGELOG.md`
- `public/CHANGELOG.md`
- Change Log Hub source page or data
- release metadata files or generated output
- sitemap, manifest, index, footer, and public release records
- hosting and local execution notes

Record current version, beta or stable status, expected version bump type,
required README updates, changelog updates, Change Log Hub updates, generated
output updates, hosting assumptions, local execution assumptions, selected
website type, and any mismatch or approved deferral.

APES CIC semantic website versioning:

```text
vMAJOR.MINOR.PATCH
vMAJOR.MINOR.PATCHb
```

Use `b` while a site is in beta. Stable versions omit it. Do not update a
version without a matching changelog decision and entry.

## 11. APES Website Structure and Cloudron LAMP Rules

For APES CIC website repositories, `public/` is the public web root unless
repository evidence or approved scope says otherwise.

Default website model:

1. `public/index.html`
2. Static HTML, CSS, browser JavaScript, images, downloads, and public assets
   in `public/`
3. PHP only where it supports forms, routing, includes, helpers, search,
   sitemap, or documented support tools

Keep source files, private configuration, database files, setup scripts, build
tooling, tests, caches, logs, generated credentials, dumps, and non-public
operational files outside `public/` unless intentionally browser-served.

Do not use `content/` as public web root. Do not scatter browser-served files
across the repository root. Do not create nested roots such as
`public/public/`.

Preferred custom portal structure when approved:

```text
/public
/public/portal
```

Cloudron LAMP target stack:

```text
Linux
Apache
MySQL
PHP 8.3 or PHP 8.4
HTML
CSS
JavaScript
Redis where approved
Apache .htaccess
```

Cloudron LAMP checks before completion include: browser-served files under
`public/`; upload-ready output in `public/`; justified `public/index.html` or
`public/index.php`; Apache-compatible `.htaccess` where required; no nested
public root; no unapproved persistent Node, Python, Ruby, Go, Java, WebSocket,
worker, scheduler, or daemon process; PHP-compatible documented database use;
Cloudron environment variables for MySQL and email; no hard-coded credentials;
forms, email, uploads, and integrations protected; UK GDPR implications
recorded; local execution notes aligned; approved validation used or blocker
recorded.

## 12. Security and UK GDPR

For UK GDPR-relevant work, identify and record:

1. Personal data collected or processed.
2. Lawful basis.
3. Data minimisation.
4. Consent requirements.
5. Privacy notice impact.
6. Retention period.
7. Access control.
8. Audit logging.
9. Deletion and correction rights.
10. Incident response.
11. Security measures.
12. Processor or third-party sharing implications.

Sensitive case management, safeguarding, HR, finance, client records, or animal
welfare records require explicit access control, audit logging, retention,
backup, incident response, and UK GDPR design before implementation.

Never expose stack traces, debug output, private URLs, credentials,
environment values, or internal operational details in public pages, issues,
logs, screenshots, or handoff notes.

## 13. SEO, Sitemap, Footer, Newsroom, and Error Pages

Update SEO and sitemap records whenever public pages are added, removed,
renamed, moved, or materially changed.

Check page titles, meta descriptions, canonical URLs, Open Graph metadata,
structured data, robots rules, noindex rules, navigation, footer links, Change
Log Hub links, canonical consistency, sitemap entries, Newsroom routing, and
branded accessible 404, 403, 500, offline, maintenance, or fallback pages where
supported.

Error pages must not expose stack traces, internal system details, private
URLs, credentials, environment values, or debugging output.

## 14. GitHub, Handoff, Cleanup, and Closure

Do not push, create pull requests, merge, delete branches, enable auto-merge,
or close issues without explicit approval.

After implementation, report:

1. Progress summary.
2. What changed.
3. Files changed with path and short explanation.
4. Checks run.
5. README, Change Log Hub, root changelog, public changelog, version record,
   and generated-output status.
6. Public-folder and local validation status, including blockers.
7. Route preview status (Codex browser or equivalent), including inspected URL or
   blocked reason.
8. Website type status.
9. Cloudron LAMP and hosting status where relevant.
10. GitHub issue status.
11. SEO, sitemap, footer, Newsroom, and error-page status where relevant.
12. Branch name, base branch, push status, and merge status.
13. Sync status where relevant.
14. Clear next-step options for publishing, merge, cleanup, or issue closure.
15. Next recommended GitHub step.

Ask about branch cleanup only after merge or safe abandonment. Ask before
closing any issue, and do not close if validation, release records, hosting
notes, local execution notes, or follow-up work remain unresolved unless
closure with limitations is explicitly approved.

## 15. Template Maintenance Rules

This agents-template repository is the source of truth for APES CIC reusable
Codex guidance. When updating it:

- Keep `VERSION`, `CHANGELOG.md`, and `.agents/template-manifest.json`
  synchronized.
- Keep `.codex/prompts/*.prompt.md` as Markdown only; do not add `.txt`
  prompt files.
- Prefer repo skills in `.agents/skills/` for current Codex/JetBrains workflows.
- Keep `.codex/hooks/` and `.codex/rules/` as examples unless active
  enforcement is separately approved.
- Keep `.codex/config.toml` free of auth, provider, telemetry, notification,
  and machine-local settings.
- Validate the template with `.codex/scripts/validate-template.ps1`.
- Test updater behavior in dry-run mode before applying it to another repo.
