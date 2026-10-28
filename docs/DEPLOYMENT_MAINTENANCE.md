# Deployment maintenance notes

## Shoal / PHP 8.3 container

- Align the container PHP version with the repository deployment guide.
- Retain serial PHP extension compilation (`docker-php-ext-install -j1`) for reliable, resource-constrained builds.
- Add a lightweight `/healthz.php` endpoint for gateway/container liveness checks.
- Add CI syntax validation for PHP files on pushes and pull requests to `master`.
- Document database provisioning, environment settings, and production safety requirements.

Important: the health endpoint checks only the web process. It is not a database readiness probe and must not be used as proof that migrations completed.
