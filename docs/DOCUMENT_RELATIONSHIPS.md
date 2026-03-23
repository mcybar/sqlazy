# Repository Document Relationships

**Date:** 2026-03-22  
**POC:** AdaL Agent  
**TL;DR:** This document defines documentation authority levels, cross-document dependencies, and change triggers so agents keep all docs/prompts synchronized.

## 1) Taxonomy and Authority

| Category | Files | Authority | Role |
|---|---|---|---|
| Governance | `AGENTS.md`, `WORKFLOW.md` | L1 (Primary) | Policy and operating procedure source of truth |
| Strategy | `docs/rivy-vision-mission.md` | L1 (Primary) | Product mission and long-term intent |
| Planning | `PLAN.md`, `ROADMAP.md`, `DECISIONS.md` | L2 (Operational) | Active execution, sequencing, and decision history |
| Learning | `LESSONS.md` | L2 (Operational) | Durable corrections, guardrails, and repeated failure patterns |
| Technical Ops | `docs/mysql-import.md` | L2 (Operational) | Environment setup and import/validation procedure |
| Prompt Assets | `prompts/**/*.md` | L3 (Runtime Assets) | Dynamically loaded agent behavior/instructions |

## 2) Synchronization Relationships

| If this changes... | Then review/sync... | Why |
|---|---|---|
| `AGENTS.md` | `WORKFLOW.md`, `LESSONS.md`, `prompts/shared/scoring-rubric.v1.0.md` | Procedure, durable guardrails, and review criteria must enforce policy |
| `WORKFLOW.md` | `AGENTS.md`, `prompts/review-agent/*` | Workflow and review protocol must remain aligned |
| `DECISIONS.md` | `PLAN.md`, `AGENTS.md` (if policy-impacting) | Accepted decisions affect execution and governance |
| `LESSONS.md` | `AGENTS.md`, `WORKFLOW.md`, relevant `prompts/**` | Durable lessons must become policy or prompt changes when they affect repeat behavior |
| `PLAN.md` | `ROADMAP.md` (phase sequencing) | Plan state and roadmap ordering must match |
| `docs/mysql-import.md` | `WORKFLOW.md`, `prompts/review-agent/sql-benchmark-review.v1.0.md` | Validation steps must match operational instructions |
| `prompts/shared/scoring-rubric.v1.0.md` | `prompts/review-agent/report-template.v1.0.md` | Score dimensions/weights must match report table |
| `prompts/review-agent/role-definition.v1.0.md` | `prompts/shared/scoring-rubric.v1.0.md` | Non-negotiables and hard-floor rules must not conflict |

## 3) Change Trigger Rules

1. **Policy Trigger**  
   Any change to prompt policy in `AGENTS.md` (dynamic loading, naming, hardcoding ban) requires review of:
   - `WORKFLOW.md`
   - `LESSONS.md` if the policy change came from a repeated failure pattern
   - `prompts/review-agent/*`
   - `prompts/shared/*` policy references

1a. **Lessons Trigger**  
   Any new active lesson in `LESSONS.md` that changes repeated agent behavior requires review of:
   - `AGENTS.md` if the lesson is durable policy
   - `WORKFLOW.md` if the lesson changes execution procedure
   - relevant prompt files under `prompts/` if the lesson changes runtime instructions

2. **Benchmark Trigger**  
   Any change to `exportedsql/*.sql` or `docs/mysql-import.md` requires adversarial review using:
   - `prompts/review-agent/sql-benchmark-review.v1.0.md`
   - report output formatted by `prompts/review-agent/report-template.v1.0.md`

3. **Prompt Version Trigger**  
   Any **major** prompt version bump (e.g., `v1.x` → `v2.x`) requires:
   - benchmark/evaluation note in PR
   - corresponding update in `PLAN.md` if execution behavior changes materially

4. **Rubric Trigger**  
   Any change to `prompts/shared/scoring-rubric.v1.0.md` requires:
   - synchronized scoring table update in `prompts/review-agent/report-template.v1.0.md`
   - explicit mention in PR validation notes

5. **Decision Trigger**  
   Any accepted decision in `DECISIONS.md` that changes agent behavior must be reflected in either:
   - `AGENTS.md` (policy)
   - relevant prompt files under `prompts/` (runtime behavior)

## 4) Prompt Suite Dependency Contract (`prompts/review-agent/`)

- `role-definition.v1.0.md` defines reviewer posture and non-negotiables (**Who**).
- `sql-benchmark-review.v1.0.md` defines procedural audit flow (**How**).
- `report-template.v1.0.md` defines required output shape (**Output**).
- `prompts/shared/scoring-rubric.v1.0.md` defines scoring dimensions and hard-floor gates (**Scoring**).

**Consistency Contract**
- Hard-floor conditions in the shared rubric must never be weaker than role non-negotiables.
- Report template dimensions and weights must always match the shared rubric.
- Workflow/PR requirements must require the review template and benchmark review procedure.

## 5) Agent Reminder Checklist (Use on Every Doc/Prompt PR)

- [ ] Did policy changes in `AGENTS.md` propagate to `WORKFLOW.md`?
- [ ] Did correction-driven changes propagate to `LESSONS.md` or a conscious no-entry decision?
- [ ] Did prompt/rubric changes propagate to report template?
- [ ] Did benchmark-related changes include review-agent audit evidence?
- [ ] Are naming/versioning rules under `prompts/` still satisfied?
- [ ] Are any docs now contradicting each other?

If any checkbox is "no", do not finalize the PR until synchronization is complete.
