/// The single place the app's backend URL is configured.
///
/// Point this at your deployed Laravel API (e.g. your shared hosting
/// domain). No trailing slash.
///
/// Testing against a *local* Laravel dev server (`php artisan serve`) from
/// a physical phone won't work with `localhost` — the phone would look for
/// the server on itself. Either deploy to your shared hosting and use that
/// domain (simplest), or use your computer's LAN IP (e.g.
/// `http://192.168.1.23:8000`) with the phone on the same Wi-Fi network.
const String apiBaseUrl = 'https://yourdomain.com';
