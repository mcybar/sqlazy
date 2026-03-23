# Repository Guidelines

## Project Structure & Module Organization
This repository supports an intelligent SQL retrieval layer for AI agents operating in data-center environments. Right now it is benchmark-data heavy: SQL dumps live in `exportedsql/` and are named by database, for example `exportedsql/keystone.sql` and `exportedsql/csail_stata_nova.sql`. `nw_mysql_dump.zip` is a larger source artifact. Project mission context is tracked in [docs/rivy-vision-mission.md](/Users/ming/Code/sqlazy/docs/rivy-vision-mission.md). Keep benchmark inputs, transformed exports, and future ontology or retrieval-layer assets separated by directory so evaluation stays reproducible. Store all agent prompts and prompt templates in `prompts/`.

## Build, Test, and Development Commands
There is no application build system checked in yet. Current work centers on inspecting and validating benchmark SQL artifacts:

- `ls exportedsql/` lists available database exports.
- `sed -n '1,40p' exportedsql/keystone.sql` previews dump headers and table definitions.
- `mysql -u <user> -p < exportedsql/keystone.sql` imports a dump into a local MySQL instance for validation.
- `git diff -- exportedsql/keystone.sql` reviews schema or data changes before benchmarking.
- `unzip -l nw_mysql_dump.zip` inspects the root archive without extracting it.

When adding data or retrieval-layer code, prefer workflows that keep schema inspection and regression review easy to reproduce.

## Coding Style & Naming Conventions
Preserve the existing dump-oriented format for generated SQL. Keep SQL files as plain ASCII/UTF-8 text with one database per file. Use lowercase, underscore-separated filenames that match the database name, such as `csail_stata_glance.sql`. For future code modules, prefer descriptive names tied to retrieval, ontology mapping, or evaluation. Do not hand-reformat generated SQL unless needed for review; stable output keeps diffs audit-friendly. Avoid AI slop and busywork code: every change should provide measurable product, benchmark, reliability, or maintainability value.

Slop heuristic (quick gate): if a change introduces boilerplate, speculative abstractions, or large cosmetic diffs without measurable impact—and cannot show clear value in correctness, benchmark quality, reliability, or maintainability—send it back for revision before merge.

Prefer the simplest robust fix. Broaden scope only when the extra complexity clearly improves correctness, reproducibility, maintainability, or benchmark trustworthiness.

## Planning Discipline
- Use `PLAN.md` as the active planning surface for non-trivial work.
- Multi-step tasks should record the target artifact, owner, exit criteria, and current blocker state in `PLAN.md`.
- Keep plans checkable and forward-looking. Historical rationale belongs in `DECISIONS.md`.

## Prompt Management & Dynamic Loading
All agent prompts and prompt templates are treated as governed assets and must follow these rules:

- **Storage**: Store all prompts/templates under `prompts/`.
- **Runtime loading**: Agents must load prompts dynamically from `prompts/` at runtime.
- **No hardcoded production prompts**: Do not hardcode prompt bodies in application code.  
  Exception: tiny test fixtures in unit tests are allowed when they do not control production behavior.
- **Prompt folder structure**:
  - Organize prompts by agent role under `prompts/`.
  - Recommended layout:
    - `prompts/router/`
    - `prompts/sql-agent/`
    - `prompts/retriever/`
    - `prompts/shared/` (reusable fragments/templates)
- **Naming convention**:
  - Use lowercase, hyphen-separated paths: `prompts/{agent-role}/{task-name}.v{major}.{minor}.md`
  - Keep one task intent per file; bump version when behavior changes materially.
  - Examples: `prompts/router/intent-classification.v1.0.md`, `prompts/sql-agent/query-generation.v2.1.md`
- **Change safety**:
  - Prompt edits must include rationale and expected impact in commit/PR notes.
  - Prefer additive versioning (new version file) over in-place overwrite when behavior changes materially.
  - Keep rollback straightforward by preserving prior prompt versions in Git history.

## Subagent Strategy
- Delegation is allowed only for bounded work that can be verified independently from primary repository evidence.
- Default subagent roles are:
  - `planner`: decomposes non-trivial work and updates `PLAN.md`.
  - `schema-evidence`: extracts grounded facts from SQL dumps or live MySQL without making policy decisions.
  - `execution`: implements a scoped change against an agreed artifact.
  - `review-agent`: performs adversarial review against the review prompts under `prompts/review-agent/`.
  - `audit`: checks claims, mappings, joins, and benchmark evidence before sign-off.
- Assign one subagent one clear question or owned artifact at a time.
- Any ontology mapping or SQL claim produced by a subagent must be labeled `proven`, `inferred`, or `unknown` and tied back to evidence.
- Subagent output is advisory until verified by the main agent or the required review/audit flow.
- Do not use delegation to bypass ambiguity handling. If critical mappings remain uncertain, stop and ask for clarification.

## Testing Guidelines
No automated test suite exists yet. Current validation is import-based and benchmark-driven:

- Load changed dumps into a disposable local MySQL database.
- Check that `CREATE DATABASE`, `USE`, and table definitions execute successfully.
- If a dump was regenerated, compare it against the previous version with `git diff -- exportedsql/<name>.sql`.
- For future retrieval or ontology changes, record the benchmark query set, expected SQL behavior, and any observed regressions.

- **Adversarial Review**: All significant changes must be audited using the `review-agent` protocol (see `prompts/review-agent/`).
  - Use `prompts/review-agent/role-definition.v1.0.md` for reviewer posture and `prompts/shared/scoring-rubric.v1.0.md` for scoring.
  - A hard-floor policy applies via `prompts/shared/scoring-rubric.v1.0.md`: verdict cannot be PASS if SQL import validation fails, critical claims lack evidence, or prompt architecture policy is violated.

Definition of done for any material change:
- Validation must be described with concrete evidence, not only claimed. Include commands run, artifacts checked, and important outcomes.
- Handoffs and PRs must state any unverified assumptions or residual risk explicitly.
- If validation could not be completed, say so directly and do not imply completion.

Document manual verification steps and the `review-agent` score in the pull request, especially when a change may affect benchmark comparability.

## Lessons And Self-Improvement
- Use `LESSONS.md` to capture meaningful corrections, repeated mistakes, failed assumptions, or audit findings that should change future agent behavior.
- Record only operational lessons with a concrete trigger, guardrail, and verification method. Do not use `LESSONS.md` as a diary.
- When a lesson changes durable repository policy, propagate it into `AGENTS.md`, `WORKFLOW.md`, or prompts as appropriate.
- Review relevant lessons before repeating similar ontology, prompt, or validation work.

## Documentation Synchronization
Use `docs/DOCUMENT_RELATIONSHIPS.md` as the cross-document sync map and trigger reference for policy, workflow, planning, prompt, and lessons updates.

## Architecture Intent
Contributions should move the repository toward an agent-facing SQL intelligence layer that can interpret operational questions, map them onto a data ontology, and retrieve or generate trustworthy SQL over infrastructure data. Treat the SQL dumps as benchmark fixtures for measuring retrieval quality, schema understanding, and ontology coverage.

## Commit & Pull Request Guidelines
This repository currently has no meaningful commit history, so use clear imperative commit subjects such as `Add keystone schema export`, `Define ontology mapping draft`, or `Refresh nova benchmark dump`. Keep commits scoped to one dataset, feature, or evaluation change when possible.

Pull requests should explain why the change improves the benchmark corpus, retrieval layer, or ontology work; list affected files; note validation performed; and call out large binary changes such as updates to `nw_mysql_dump.zip`. Include import or evaluation commands when reviewers need to reproduce results.
