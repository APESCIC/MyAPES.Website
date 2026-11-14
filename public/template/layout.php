<?php

declare(strict_types=1);

function template_e(string $value): string
{
    return htmlspecialchars($value, ENT_QUOTES, 'UTF-8');
}

function template_defaults(array $page): array
{
    return array_merge([
        'title' => 'MyAPES | APES CIC',
        'description' => 'MyAPES public website.',
        'canonical' => '',
        'robots' => 'index, follow',
        'themeColor' => '#075b5b',
        'bodyClass' => '',
        'currentPath' => '/',
    ], $page);
}

function template_is_current(string $currentPath, string $href): bool
{
    if ($href === '/') {
        return $currentPath === '/';
    }

    return rtrim($currentPath, '/') . '/' === rtrim($href, '/') . '/';
}

function template_nav_link(string $href, string $label, string $currentPath): string
{
    $current = template_is_current($currentPath, $href) ? ' aria-current="page"' : '';

    return '<a href="' . template_e($href) . '"' . $current . '>' . template_e($label) . '</a>';
}

function template_primary_navigation(): array
{
    return [
        ['href' => '/', 'label' => 'Home'],
        ['href' => '/services/', 'label' => 'Services'],
        ['href' => '/resource-hub/', 'label' => 'Resource Hub'],
        ['href' => '/fun-zone/', 'label' => 'Fun Zone'],
        ['href' => '/support/', 'label' => 'Support'],
        ['href' => '/change-log-hub/', 'label' => 'Updates'],
    ];
}

function template_external_nav_link(string $href, string $label): string
{
    return '<a class="nav-account-link" href="' . template_e($href) . '" target="_blank" rel="noopener noreferrer">'
        . template_e($label)
        . '<span class="sr-only">, opens external website</span></a>';
}

function template_render_page_start(array $page): void
{
    $page = template_defaults($page);

    $bodyClass = trim((string) $page['bodyClass']);
    $bodyClassAttr = $bodyClass !== '' ? ' class="' . template_e($bodyClass) . '"' : '';

    echo '<!DOCTYPE html>';
    echo '<html lang="en-GB">';
    echo '<head>';
    echo '<meta charset="utf-8" />';
    echo '<meta name="viewport" content="width=device-width, initial-scale=1" />';
    echo '<meta name="theme-color" content="' . template_e((string) $page['themeColor']) . '" />';
    echo '<title>' . template_e((string) $page['title']) . '</title>';
    echo '<meta name="description" content="' . template_e((string) $page['description']) . '" />';
    echo '<meta name="robots" content="' . template_e((string) $page['robots']) . '" />';

    if ((string) $page['canonical'] !== '') {
        echo '<link rel="canonical" href="' . template_e((string) $page['canonical']) . '" />';
    }

    echo '<link rel="stylesheet" href="/assets/css/site.css" />';
    echo '<script defer src="/assets/js/site.js"></script>';
    echo '</head>';
    echo '<body' . $bodyClassAttr . '>';
    echo '<a class="skip-link" href="#main-content">Skip to main content</a>';
    echo '<div class="site-shell">';
    echo '<header class="header-shell" data-shared-header>';
    echo '<div class="topbar" data-shared-topbar>';
    echo '<div class="wrap topbar-inner">';
    echo '<div>MyAPES CIC public resource and tool hub</div>';
    echo '<div><a href="/support/">Get support</a></div>';
    echo '</div>';
    echo '</div>';

    echo '<div class="wrap header-inner">';
    echo '<a class="brand" href="/" aria-label="MyAPES home">';
    echo '<img src="/assets/apes-logo-navbar-72h-C6PH2zPj.png" alt="MyAPES logo" />';
    echo '<div class="brand-copy">';
    echo '<strong>MyAPES</strong>';
    echo '<span>Association of Protecting Exotic Species CIC</span>';
    echo '</div>';
    echo '</a>';

    echo '<nav class="site-nav site-nav-desktop" aria-label="Primary navigation" data-desktop-nav>';
    foreach (template_primary_navigation() as $link) {
        echo template_nav_link($link['href'], $link['label'], (string) $page['currentPath']);
    }
    echo template_external_nav_link('https://account.myapes.me.uk/', 'MyAPES Account');

    echo '</nav>';
    echo '<button class="menu-toggle" type="button" data-menu-toggle aria-expanded="false" aria-controls="mobile-nav">Menu</button>';
    echo '<nav id="mobile-nav" class="site-nav site-nav-mobile" aria-label="Mobile navigation" data-mobile-nav>';
    foreach (template_primary_navigation() as $link) {
        echo template_nav_link($link['href'], $link['label'], (string) $page['currentPath']);
    }
    echo template_external_nav_link('https://account.myapes.me.uk/', 'MyAPES Account');

    echo '</nav>';
    echo '</div>';
    echo '</header>';
    echo '<main id="main-content">';
}

function template_render_page_end(): void
{
    echo '</main>';
    echo '<footer class="site-footer">';
    echo '<div class="wrap footer-shell">';
    echo '<div class="footer-grid">';

    echo '<section class="footer-card">';
    echo '<h2>Public hub</h2>';
    echo '<ul class="clean-list">';
    echo '<li><a href="/resource-hub/">Resource Hub</a></li>';
    echo '<li><a href="/fun-zone/">Fun Zone</a></li>';
    echo '<li><a href="/services/">Services</a></li>';
    echo '<li><a href="/support/">Support</a></li>';
    echo '</ul>';
    echo '</section>';

    echo '<section class="footer-card">';
    echo '<h2>Tools &amp; community</h2>';
    echo '<ul class="clean-list">';
    echo '<li><a href="https://carebase.apes.org.uk/" target="_blank" rel="noopener noreferrer">APES CareBase <span class="sr-only">, opens external website</span></a></li>';
    echo '<li><a href="https://apestube.apes.org.uk/" target="_blank" rel="noopener noreferrer">APES Tube <span class="sr-only">, opens external website</span></a></li>';
    echo '<li><a href="/apes-communities/">APES Communities</a></li>';
    echo '<li><a href="https://account.myapes.me.uk/" target="_blank" rel="noopener noreferrer">MyAPES Account <span class="sr-only">, opens external website</span></a></li>';
    echo '</ul>';
    echo '</section>';

    echo '<section class="footer-card">';
    echo '<h2>Policies &amp; updates</h2>';
    echo '<ul class="clean-list">';
    echo '<li><a href="/privacy/">Privacy Notice</a></li>';
    echo '<li><a href="/terms/">Terms of Service</a></li>';
    echo '<li><a href="/accessibility/">Accessibility</a></li>';
    echo '<li><a href="/change-log-hub/">Change Log Hub</a></li>';
    echo '</ul>';
    echo '</section>';

    echo '</div>';
    echo '<div class="footer-bar">';
    echo '<p>Association of Protecting Exotic Species CIC · CIC No: 16253848</p>';
    echo '<p>40 Morris Street, St Helens, Merseyside, WA9 3EN</p>';
    echo '<p>Public contact: <a class="js-protected-email" href="/contact/" data-user="info" data-domain="apes.org.uk" data-show-address="true" rel="nofollow">Email APES</a> · <a href="tel:01744374015">01744 374 015</a></p>';
    echo '<p>Website version: <a href="/change-log-hub/">MyAPES v3.2.4</a></p>';
    echo '</div>';
    echo '</div>';
    echo '</footer>';
    echo '</div>';
    echo '</body>';
    echo '</html>';
}
