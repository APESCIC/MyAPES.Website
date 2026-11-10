# myapes.me.uk

## Runtime and deployment target

MyAPES public site is delivered as a **static HTML/CSS/JS website served from `public/`**.

- Primary web root: `public/` (served locally from `C:\laragon\www\myapes-website\public`)
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

Laragon is the only supported local set-up. Its Apache serves `public/` with the same `.htaccess` rules as Cloudron.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\laragon-setup.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\preview.ps1
```

The first links `C:\laragon\www\myapes-website` to your clone so Laragon serves `http://myapes-website.test`. The second pulls the latest changes and starts Browsersync on `http://localhost:3101/`, which reloads on save. Then check:

- `http://localhost:3101/`
- `http://localhost:3101/support/`
- `http://localhost:3101/sitemap.xml`
- `http://localhost:3101/does-not-exist` (should resolve to the branded 404)

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
- Site version: `public/VERSION` (`v3.2.2b`)
- Repository version: `VERSION` (`v3.2.2b`)

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
