<?php

/**
 * Laravel Herd driver for the local preview. Never deployed: deploy.ps1 ships public/ only.
 *
 * Herd serves sites with nginx, which does not read public/.htaccess. This driver and
 * scripts/herd/router.php give the local site the same behaviour as Cloudron's Apache:
 * clean URLs, a 301 to the trailing slash for folders, a real 404 status with the branded
 * page, and the security headers on pages. Keep it in step with public/.htaccess.
 */
class LocalValetDriver extends \Valet\Drivers\ValetDriver
{
    public const HEADERS = [
        'X-Content-Type-Options' => 'nosniff',
        'X-Frame-Options' => 'SAMEORIGIN',
        'Referrer-Policy' => 'strict-origin-when-cross-origin',
    ];

    public function serves(string $sitePath, string $siteName, string $uri): bool
    {
        return is_file($sitePath.'/public/index.html');
    }

    public function isStaticFile(string $sitePath, string $siteName, string $uri)
    {
        $route = self::resolve($sitePath.'/public', $uri);

        if ($route['type'] === 'file' && ! in_array(strtolower(pathinfo($route['path'], PATHINFO_EXTENSION)), ['html', 'php'], true)) {
            return $route['path'];
        }

        return false;
    }

    public function frontControllerPath(string $sitePath, string $siteName, string $uri): ?string
    {
        $public = $sitePath.'/public';
        $route = self::resolve($public, $uri);

        foreach (self::HEADERS as $name => $value) {
            header("$name: $value");
        }

        $_SERVER['DOCUMENT_ROOT'] = $public;
        $_SERVER['SERVER_NAME'] = $_SERVER['HTTP_HOST'];

        if ($route['type'] === 'file' && strtolower(pathinfo($route['path'], PATHINFO_EXTENSION)) === 'php') {
            $_SERVER['SCRIPT_FILENAME'] = $route['path'];
            $_SERVER['SCRIPT_NAME'] = substr($route['path'], strlen($public));
            $_SERVER['PHP_SELF'] = $_SERVER['SCRIPT_NAME'];

            return $route['path'];
        }

        $_SERVER['MYAPES_HERD_ROUTE'] = $route;

        return $sitePath.'/scripts/herd/router.php';
    }

    /**
     * Resolves a request path the way public/.htaccess does on Apache.
     *
     * @return array{type: 'file'|'redirect'|'forbidden'|'missing', path?: string, location?: string}
     */
    public static function resolve(string $public, string $uri): array
    {
        $root = realpath($public);
        $relative = '/'.ltrim($uri, '/');

        if (preg_match('#(^|/)\.ht|\.user\.ini$#i', $relative)) {
            return ['type' => 'missing'];
        }

        $inside = static function (string $path) use ($root): ?string {
            $real = realpath($path);

            return $real !== false && ($real === $root || str_starts_with($real, $root.DIRECTORY_SEPARATOR)) ? $real : null;
        };

        $target = $inside($root.$relative);

        if ($target !== null && is_file($target)) {
            return ['type' => 'file', 'path' => $target];
        }

        if ($target !== null && is_dir($target)) {
            if (! str_ends_with($relative, '/')) {
                return ['type' => 'redirect', 'location' => $relative.'/'];
            }

            foreach (['index.html', 'index.php'] as $index) {
                if (is_file($target.DIRECTORY_SEPARATOR.$index)) {
                    return ['type' => 'file', 'path' => $target.DIRECTORY_SEPARATOR.$index];
                }
            }

            return ['type' => 'forbidden'];
        }

        $trimmed = rtrim($relative, '/');

        foreach (['.html', '.php'] as $extension) {
            $candidate = $inside($root.$trimmed.$extension);

            if ($candidate !== null && is_file($candidate)) {
                return ['type' => 'file', 'path' => $candidate];
            }
        }

        return ['type' => 'missing'];
    }
}
