<?php

/**
 * Herd front controller for pages, folder redirects and misses (see LocalValetDriver.php).
 * Local preview only.
 */
$route = $_SERVER['MYAPES_HERD_ROUTE'] ?? ['type' => 'missing'];
$public = $_SERVER['DOCUMENT_ROOT'];

switch ($route['type']) {
    case 'file':
        header('Content-Type: text/html; charset=utf-8');
        readfile($route['path']);
        break;

    case 'redirect':
        $query = $_SERVER['QUERY_STRING'] ?? '';
        header('Location: '.$route['location'].($query !== '' ? '?'.$query : ''), true, 301);
        break;

    case 'forbidden':
        http_response_code(403);
        header('Content-Type: text/plain; charset=utf-8');
        echo 'Forbidden';
        break;

    default:
        http_response_code(404);
        header('Content-Type: text/html; charset=utf-8');
        readfile($public.'/404.html');
}
