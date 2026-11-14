# Laravel Herd profile

This website is linked in Laravel Herd (Pro, Windows) as its own site. The values below are in `profile.json`, which `scripts/herd-setup.ps1` and `scripts/preview.ps1` read. Herd is the only supported local set-up.

| Item | Value |
| --- | --- |
| Site | `http://myapes-website.test`, a Herd link (`herd link myapes-website`) to this clone |
| Document root | `public/` |
| Web server | Herd's nginx. Every request goes through Herd's `server.php` and this repo's `LocalValetDriver.php` |
| PHP | Herd's PHP 8.4 through PHP-FPM, isolated to this site (`herd isolate 8.4`), as on Cloudron (8.4) |
| Database | None |
| Node | Herd's Node (22 or later), for Browsersync only. The deployed site needs no Node |
| Live reload | `npm run dev`: Browsersync on `http://localhost:3101` (UI on 3111), proxying the Herd site |

## Why there is a local driver

Cloudron serves the site with Apache, which reads `public/.htaccess`. Herd's nginx does not, and Herd's built-in static driver would send a missing page to `/index.html` with status 200. `LocalValetDriver.php` (repo root) and `scripts/herd/router.php` copy the `.htaccess` rules:

1. An existing file is served as it is.
2. A folder without a trailing slash gets a 301 to the slash form; a folder serves `index.html`, then `index.php`; a folder with neither is 403.
3. Otherwise `<path>.html`, then `<path>.php`.
4. Anything else returns 404 with the body of `public/404.html`.
5. Pages, `.php` files, redirects and errors carry the three security headers from `.htaccess`.

Neither file is in `public/`, so neither is deployed. When you change the rewrite rules or headers in `public/.htaccess`, change the driver to match.

## Differences from Cloudron

- `.htaccess` is never read locally. The driver above copies its behaviour, not its syntax.
- Assets (CSS, JavaScript, images) are handed to nginx directly and carry no security headers locally.
- PHP runs as PHP-FPM, so `public/.user.ini` applies locally. `php_value` lines in `.htaccess` stay inside `<IfModule php_module>` for Cloudron.
- Herd adds its developer tools loader script to HTML pages locally. It is not part of the site.

## Set up or repair

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\herd-setup.ps1
```

It is safe to run twice and only touches this site: it links the clone as `myapes-website` if it is not linked (and stops if that name points at another folder), isolates it to PHP 8.4, runs `npm ci` if `node_modules/` is missing, then checks that `/VERSION` matches this clone and that a missing page returns 404.
