# Stargate Wars — GitHub Pages Edition

This folder contains a playable, static browser edition of the Stargate Wars strategy game. It uses plain HTML, CSS, and JavaScript; no build step or external JavaScript package is required.

## Play

After GitHub Pages is configured to deploy from the repository's **GitHub Actions** workflow, open:

`https://arkansasio.github.io/stargatewars-clone-1.5/play/`

## Included playable systems

- Four selectable race doctrines (Tau'ri, Asgard, Goa'uld, Replicator) — choose the race when starting a fresh save by editing the initial prompt/selection in a future update; the default prototype starts as Tau'ri.
- Naquadah, Energy, and Science economy with turn-based production.
- Building upgrades, scaling costs, and production modifiers.
- Six technology tracks with per-level bonuses.
- Five unit types, recruitment, fleet power, and combat doctrine bonuses.
- Galaxy destinations, exploration, raids, colonization, and patrol missions.
- Mission travel and randomized outcomes resolved when the player advances turns.
- Stargate facility status, intelligence scans, local alliance designation, simulated sector rankings.
- Local browser save, JSON export/import, reset, event log, responsive command interface.

## Persistence and multiplayer boundary

The game state is saved to the browser's `localStorage`. It does not create online accounts or sync progress between devices. Because GitHub Pages only serves static assets, it cannot execute PHP, authenticate players securely, run authoritative 30-minute turns, or connect directly to MySQL. Those features must use the PHP/MySQL application hosted on Shoal or another PHP-capable host. Never place database credentials in JavaScript or static files.

## Repository structure

- `index.html` — game interface.
- `game.css` — responsive command-centre theme.
- `game.js` — local simulation and persistence.

The PHP application at the repository root remains the server-backed game implementation; this static edition is a separate browser-playable prototype.