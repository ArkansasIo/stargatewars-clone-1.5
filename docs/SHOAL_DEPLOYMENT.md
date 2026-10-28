# Shoal deployment and verification

This repository is a PHP 8.3 + MySQL/MariaDB application. Deploy the web service as a container connected to a Shoal gateway; GitHub Pages cannot execute its PHP backend.

## Container build

The root `Dockerfile` builds from `php:8.3-apache` and installs the PHP extensions used by the application (`mysqli`, `pdo_mysql`, `gd`, `mbstring`, and `zip`). Apache listens on port 80. The `/healthz.php` endpoint returns `ok` if Apache/PHP is responding; it does not confirm database connectivity.

## Shoal setup

1. Connect this GitHub repository to a Shoal project.
2. Add a container node and a gateway, then connect the gateway to the container.
3. Configure the container to build using the repository root `Dockerfile` and branch `master`.
4. Configure a persistent MySQL/MariaDB database reachable from the container.
5. Set the database and optional display variables listed below in the container's environment/secret settings.
6. Deploy, inspect logs, and test both the health endpoint and actual game flows.

## Required environment

- `SGW_DB_HOST`
- `SGW_DB_NAME`
- `SGW_DB_USER`
- `SGW_DB_PASS`

Optional display settings: `SGW_TITLE`, `SGW_SUBTITLE`, and `SGW_ADMIN_EMAIL`.

Do not use the sample values from `.env.example` in a public deployment. Keep real secrets out of Git, leave `SGW_BYPASS_LOGIN=0`, and use a least-privilege database account.

## Database setup

Read [BACKEND_SETUP.md](../BACKEND_SETUP.md). For a new environment, review the SQL bootstrap and import scripts before applying them to a production database. Use a persistent managed database rather than relying on the container's writable filesystem.

## Local verification

Install PHP 8.3 with the required extensions and MySQL client tools, then run:

```bash
find . -type f -name '*.php' -print0 | xargs -0 -r -n1 php -l
./scripts/backend/healthcheck.sh
php tests/progression_caps_test.php
git diff --check
```

The database health check requires correctly configured database credentials and a provisioned schema. GitHub Actions runs syntax and whitespace checks without production credentials.

## Production checklist

- HTTPS enabled at the gateway.
- Strong unique database credentials stored as deployment secrets.
- Database network access restricted to the app.
- Login bypass disabled.
- Administrator access reviewed and restricted as appropriate.
- SMTP configured only with verified provider credentials.
- Backups, restore testing, migrations, logs, and rollback plan established.
- Exercise registration, login, account settings, and database-backed game actions after deployment.
