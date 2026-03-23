# MySQL Import Guide

These dumps are native MySQL exports. The fastest way to load all benchmark data is to run MySQL in Docker and import the files directly.

## What Gets Imported
- `exportedsql/keystone.sql`
- `exportedsql/csail_stata_glance.sql`
- `exportedsql/csail_stata_cinder.sql`
- `exportedsql/csail_stata_neutron.sql`
- `exportedsql/csail_stata_nova.sql`

`csail_stata_nova.sql` is about 1.9 GB, so the full import will take noticeably longer than the others.

## One-Time Setup
Start the database:

```bash
docker compose up -d mysql
```

Import everything:

```bash
bash scripts/import_all.sh
```

## Useful Commands
Open a MySQL shell:

```bash
docker exec -it sqlazy-mysql mysql -uroot -proot
```

List databases:

```bash
docker exec sqlazy-mysql mysql -uroot -proot -e "SHOW DATABASES;"
```

Reset and reimport from scratch:

```bash
docker compose down -v
bash scripts/import_all.sh
```

## Recommendation
For NL-to-SQL iteration, keep MySQL as the source-of-truth environment because the dumps are already in MySQL format. Build your schema introspection, benchmark queries, and agent prompts against this local instance first.
