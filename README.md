# sqlazy

`sqlazy` is a benchmark-first repository for building an agent-facing SQL intelligence layer over data-center and infrastructure data.

The current repository is centered on large MySQL schema exports that act as benchmark fixtures for:
- schema understanding
- ontology mapping
- retrieval quality
- trustworthy SQL generation for operational questions

Project intent is summarized in `docs/rivy-vision-mission.md`.

## Repository Layout

- `exportedsql/`: benchmark SQL dumps, one database per file
- `prompts/`: governed prompts and prompt templates
- `docs/`: project context, workflow references, and validation notes
- `scripts/`: helper scripts for import and local validation

## Quick Start

Download and unzip the SQL dump archive from the command line:

```bash
curl -L "https://drive.usercontent.google.com/download?id=1KJWdSGJ67DCwuxcWepZM2jJXXTphTnuw&export=download&confirm=t" -o nw_mysql_dump.zip && unzip -l nw_mysql_dump.zip && unzip nw_mysql_dump.zip
```

If you prefer to download it manually, use the Google Drive file:
- <https://drive.google.com/file/d/1KJWdSGJ67DCwuxcWepZM2jJXXTphTnuw/view?usp=drive_link>

If the archive extracts into a different folder name, rename it to `exportedsql/` so the repository scripts and examples match the expected layout.

Inspect available benchmark dumps:

```bash
ls exportedsql/
```

Preview a dump header:

```bash
sed -n '1,40p' exportedsql/keystone.sql
```

Import a dump into local MySQL:

```bash
mysql -u <user> -p < exportedsql/keystone.sql
```

Run the local helper import script:

```bash
./scripts/import_all_local.sh
```

## Working Conventions

- Keep prompts and prompt templates under `prompts/`.
- Do not hardcode production prompt bodies in application code.
- Preserve generated SQL formatting unless a change is needed for correctness or review.
- Prefer reproducible validation steps and concrete evidence over informal claims.

## Validation

There is no automated test suite yet. Current validation is manual and import-based:

- load changed dumps into a disposable MySQL database
- confirm `CREATE DATABASE`, `USE`, and table definitions execute cleanly
- review schema or dump changes with `git diff -- exportedsql/<name>.sql`

For additional project policy and workflow details, see `AGENTS.md`.
