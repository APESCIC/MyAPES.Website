# myapes.me.uk

## Runtime and deployment target

MyAPES public site is delivered as a **static HTML/CSS/JS website served from `public/`**.

- Primary web root: `public/` (served locally by Laravel Herd as `http://myapes-website.test`)
- Public routes are static files (`index.html` and folder `index.html` pages).
- `.htaccess` in `public/` keeps clean URLs and fallback 404 behavior for Apache.
- No private application runtime is required for the public site in this repository snapshot.

## Cloudron LAMP notes

The expected deployment target is the existing Cloudron LAMP pattern:

- Linux + Apache + PHP 8.3/8.4
- Document root set to `<app_root>/public`
- URL handling managed by `public/.htaccess`
- No custom Cloudron manifest was added in this change (platform-side app config is expected to already exist).
- No MySQL-backed runtime behavior is required for the public front door.

## Local preview and validation workflow

Laravel Herd (Pro, Windows) is the only supported local set-up. Herd serves `public/` with nginx on PHP 8.4. nginx does not read `.htaccess`, so `LocalValetDriver.php` at the repo root (never deployed) copies its clean URLs, 404 page and security headers. Details: [docs/herd/profile.md](docs/herd/profile.md).

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\herd-setup.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\preview.ps1
```

The first links your clone in Herd as `http://myapes-website.test` and isolates it to PHP 8.4. The second pulls the latest changes, checks the site serves this clone, and starts Browsersync on `http://localhost:3101/`, which reloads on save. Then check:

- `http://localhost:3101/`
- `http://localhost:3101/support/`
- `http://localhost:3101/sitemap.xml`
- `http://localhost:3101/does-not-exist` (should return the branded 404 page with status 404)

### Quick checks

- `php scripts/check-site.php` (also run by CI)
- `rg -n "https://beta\.apes\.me\.uk" public` (should return no results after domain migration)
- `php -l public/template/layout.php`

### How work ships

Once per milestone, by the milestone's version: see `CONTRIBUTING.md` and `.cursor/rules/version-shipping.mdc`. After the ship gate, the release tag is deployed with `deploy/cloudron/deploy.ps1 -Tag vX.Y.Z`.

## JetBrains setup notes

For PHP/HTML editing in JetBrains IDEs:

- Open repository root as the project root.
- Set project PHP SDK to a PHP 8.3+ interpreter.
- Keep project files and shared run configs inside `.idea` (only existing tracked entries are expected for this repo).
- Ensure preview and static-path workflows reference `public/` as the web server docroot.

## Release records

- Public release records: `public/CHANGELOG.md`
- Change log hub page: `public/change-log-hub/index.html`
- Site version: `public/VERSION` (`3.2.3`, shown as `v3.2.3`)
- Repository version: `VERSION` (`3.2.3`)

## Support and community

- Public website help: [MyAPES Support](https://myapes.me.uk/support/)
- Public postal address: 40 Morris Street, St Helens, Merseyside, WA9 3EN
- Public telephone: [01744 374 015](tel:01744374015)
- Public email: shown on the [Contact](https://myapes.me.uk/contact/) page after the page loads, with harvest protection and `rel="nofollow"`
- Maintainers: [APES CIC](https://github.com/APESCIC)

Do not include credentials, private service details, personal data,
safeguarding information or confidential case material in a public issue.

## Notes

External service links, account links and production credentials are intentionally kept out of this repository scope.
