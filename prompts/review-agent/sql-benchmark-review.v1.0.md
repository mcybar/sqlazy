# SQL Benchmark Review Procedure v1.0

## Inputs
- Change diff and touched files
- Relevant docs (`AGENTS.md`, `WORKFLOW.md`, `PLAN.md`, `DECISIONS.md` if applicable)
- Validation outputs (import logs, command outputs, test results)

## Phase 1 — Intent & Scope Check
1. Summarize intended change in 2-4 bullets.
2. Confirm touched assets are in expected areas (`exportedsql/`, `prompts/`, docs, scripts).
3. Flag out-of-scope edits.

## Phase 2 — Change Audit
1. Review file diffs for unintended churn.
2. For SQL dumps, verify changes appear intentional and localized.
3. For prompt changes, verify:
   - file path under `prompts/`
   - naming follows `prompts/{agent-role}/{task-name}.v{major}.{minor}.md`
   - no hardcoded production prompt introduced elsewhere
4. For code/docs changes, flag AI slop or busywork:
   - low-information boilerplate with no measurable effect
   - unnecessary abstractions, wrappers, or file churn
   - generated content not tied to a concrete requirement or validation outcome

## Phase 3 — Validation Evidence Check
1. Confirm SQL validation evidence exists when SQL changed:
   - import execution success (`CREATE DATABASE`, `USE`, schema load)
   - diff review evidence (`git diff -- exportedsql/<name>.sql`)
2. Confirm benchmark/regression notes are present for ontology/retrieval/prompt behavior changes.
3. Mark missing evidence as findings (severity S2+).

## Phase 4 — Risk & Reproducibility
1. Identify rollback path.
2. Assess benchmark comparability impact.
3. Call out hidden coupling, migration risks, or ambiguity requiring abstention.

## Phase 5 — Score & Verdict
1. Score using `prompts/shared/scoring-rubric.v1.0.md`.
2. Apply hard floor rules:
   - Any import failure => overall verdict cannot be PASS.
   - Unverifiable critical claim => overall verdict cannot be PASS.
3. Produce report using `prompts/review-agent/report-template.v1.0.md`.

## Output Requirement
Return only the structured review report with:
- scope summary
- prioritized findings
- rubric scores
- pass/fail verdict
- required remediation steps
