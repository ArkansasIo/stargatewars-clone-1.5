# Deploy Stargate Wars on Shoal

This repository is a PHP application with a MySQL/MariaDB database. Deploy it on Shoal as a **container connected to a gateway**; GitHub Pages alone cannot run its PHP backend.

## 1. Connect the repository in Shoal

1. Sign in to Shoal and create/open a project.
2. Add a **Container** node and a **Gateway** node, then connect the gateway to the container.
3. In the container's **Source** settings, select GitHub and authorize access to `ArkansasIo/stargatewars-clone-1.5`.
4. Select the `master` branch. Shoal should detect the root `Dockerfile` and build the image.
5. In the gateway's **Domain** settings, choose an available Shoal hostname (for example, `stargatewars` if available).
6. Deploy and inspect the build/runtime logs before sharing the URL.

Shoal's gateway routes public HTTP traffic to the container. The Docker image serves Apache on port **80**.

## 2. Provision a persistent database

Provision a reachable MySQL or MariaDB instance separately. Do not rely on a database inside the web container's filesystem: container filesystems may be replaced during redeploys.

Import the schema using the project's existing instructions in [BACKEND_SETUP.md](BACKEND_SETUP.md). For a new database, review the bootstrap SQL and scripts before running them against production.

Configure these environment variables in Shoal's container settings:

| Variable | Required | Description |
| --- | --- | --- |
| `SGW_DB_HOST` | Yes | Database hostname reachable from the container |
| `SGW_DB_NAME` | Yes | Database name, typically `sgw` |
| `SGW_DB_USER` | Yes | Least-privilege database user |
| `SGW_DB_PASS` | Yes | Database password; store as a secret |
| `SGW_TITLE` | No | Game/site title |
| `SGW_SUBTITLE` | No | Site subtitle |
| `SGW_ADMIN_EMAIL` | No | Administrator contact email |

Use the database provider's TLS requirements and allowlist/network settings. Never use the example credentials from `.env.example` in production.

## 3. Verify deployment

After deploying:

- Open the Shoal gateway URL and confirm the PHP front page loads.
- Open `/healthz.php`; it should return `ok`. This confirms Apache/PHP is responding, **not** that the database is healthy.
- Test login, registration, game pages, and database-backed actions.
- Review Shoal logs for PHP errors and database connection failures.
- Confirm HTTPS is enabled at the gateway before using real accounts.

## 4. Security checklist

- Set strong, unique database credentials and keep them only in Shoal's secret/environment settings.
- Do not commit `.env`, `config.local.php`, production dumps, backups, or real credentials.
- Keep `SGW_BYPASS_LOGIN=0`; do not enable login bypass on a public deployment.
- Configure a verified SMTP provider before relying on outbound email.
- Create a backup and restore procedure for the production database.
- Test legacy PHP code on the selected PHP image before treating the deployment as production-ready.

## 5. Troubleshooting

- **Container fails to build:** inspect Shoal's build logs and confirm the root `Dockerfile` is selected.
- **Gateway returns an error:** verify the gateway is connected to the container and forwards traffic to port `80`.
- **Database connection fails:** verify `SGW_DB_HOST`, database name/user/password, network access, and provider TLS requirements.
- **Page loads but game data is missing:** follow [BACKEND_SETUP.md](BACKEND_SETUP.md) and verify the schema/migrations.
- **Legacy PHP incompatibility:** check the PHP error logs. The included image uses PHP 8.2; adjust the image version only after testing the application against that PHP release.

## Related documentation

- [Backend setup](BACKEND_SETUP.md)
- [Main README](README.md)
- [Shoal deployment guide](https://docs.shoalstack.com/deploy-app/)
