# WORKFLOW

**Date:** 2026-03-22  
**POC:** AdaL Agent  
**TL;DR:** Use an evidence-first, abstention-first workflow: sync/import benchmark SQL, inspect schema before changes, make minimal scoped edits, validate via import/diff checks, and document decisions for reproducibility.

## 0) Canonical Guidance Source
- This repository uses **`AGENTS.md`** as the contributor/agent policy document.
- **`AGENT.md` is not present**.
- This workflow is aligned to `AGENTS.md`, with operational steps bridged from `PLAN.md`, `ROADMAP.md`, `DECISIONS.md`, and `docs/mysql-import.md`.

## 1) Operating Principles
1. **Reproducibility over convenience**  
   Preserve benchmark comparability and stable diffs.
2. **Evidence over assumption**  
   Verify schema/table/relationship claims from source artifacts before acting.
3. **Abstention over hallucination**  
   If mapping or joins are ambiguous, ask for clarification instead of guessing.
4. **Surgical changes only**  
   Keep diffs scoped to the requested outcome; avoid unrelated edits.
5. **Dynamic prompt architecture**  
   Prompts are runtime-loaded assets from `prompts/`, never hardcoded production strings.
6. **Value density over busywork**  
   Reject AI slop, placeholder abstractions, and cosmetic churn; each change must have clear, reviewable impact.

## 1.5) Slop Heuristics Checklist
Use this checklist before approving code/docs/prompt changes.

### Fast-fail indicators (likely AI slop / busywork)
- [ ] Adds boilerplate text or wrappers without changing behavior, reliability, or reproducibility.
- [ ] Introduces abstractions not used by current requirements.
- [ ] Splits files/functions without measurable readability or maintenance benefit.
- [ ] Rephrases documentation heavily without adding operational guidance.
- [ ] Adds “future-proofing” scaffolding with no concrete consumer.
- [ ] Expands prompt wording significantly without benchmark evidence of improvement.
- [ ] Produces large diffs with little or no user-visible impact.

### Value indicators (likely acceptable)
- [ ] Fixes a demonstrated bug or correctness issue.
- [ ] Improves import/validation reliability with reproducible evidence.
- [ ] Reduces benchmark risk (clearer checks, safer rollback, tighter constraints).
- [ ] Improves maintainability with concrete simplification (less duplication, clearer ownership).
- [ ] Updates prompts with versioned changes and benchmark-backed impact.

### Decision rule
- If **2+ fast-fail indicators** are checked and no strong value indicator is evidenced, request revision before merge.
- Require the PR to state the measurable outcome (correctness, benchmark quality, reliability, or maintainability).

## 2) Standard Execution Loop (for any task)
1. **Clarify scope**
   - Confirm deliverable, affected files, and validation criteria.
2. **Gather context**
   - Read only relevant docs/files first.
   - For schema/data tasks, inspect targeted SQL dumps in `exportedsql/`.
3. **Plan**
   - State concise steps before implementation (especially for multi-file work).
   - For non-trivial tasks, update `PLAN.md` with the expected artifact, owner, exit criteria, and blocker state before implementation.
4. **Implement**
   - Apply minimal, reversible changes.
   - Keep naming conventions consistent (lowercase, underscore-separated where applicable).
   - Save any agent prompts and prompt templates in `prompts/`.
   - Load prompts/templates dynamically from `prompts/` at runtime.
   - Never hardcode production prompt text in source code.
5. **Validate**
   - Run import/consistency checks appropriate to the change.
   - Review diffs for accidental churn.
   - Record concrete validation evidence: commands run, files or schemas inspected, and the result that justifies completion.
6. **Document**
   - Record key decisions/rationale when direction or assumptions change.
   - If a correction, audit finding, or repeated mistake exposed a durable pattern, add or update an entry in `LESSONS.md`.
7. **Handoff**
   - Summarize what changed, validation evidence, known limitations, and any remaining unverified assumptions.

## 2.2) Autonomous Debugging Rule
When a task involves a bug, failed import, incorrect SQL, broken prompt behavior, or review finding:
- Inspect the nearest evidence first: logs, diffs, schema definitions, failing commands, prompt versions, and benchmark artifacts.
- Attempt the smallest grounded fix before asking the user for steering.
- Ask for clarification only when ambiguity is material and repository evidence cannot resolve it safely.

## 2.3) Subagent Operating Rules
- Use delegation only when work is separable, bounded, and independently verifiable.
- Recommended role split:
  - `planner`: decomposes multi-step work and updates `PLAN.md`.
  - `schema-evidence`: gathers facts from SQL dumps or MySQL.
  - `execution`: makes the scoped implementation change.
  - `review-agent`: performs adversarial review.
  - `audit`: validates claims, evidence, and benchmark impact before sign-off.
- Each subagent should own one artifact or one question at a time.
- Treat subagent outputs as drafts until checked against repository evidence and the required review flow.
- Subagents must not convert `unknown` mappings into asserted facts.

## 2.5) Prompt Naming & Improvement Workflow
### Prompt folder structure and naming convention
- Organize prompt assets under `prompts/` by agent role.
- Recommended structure:
  - `prompts/router/`
  - `prompts/sql-agent/`
  - `prompts/retriever/`
  - `prompts/shared/` for reusable prompt fragments/templates
- Use lowercase, hyphen-separated versioned filenames:
  - `prompts/{agent-role}/{task-name}.v{major}.{minor}.md`
- Keep one task intent per file and increment version for material behavior changes.
- Examples:
  - `prompts/router/intent-classification.v1.0.md`
  - `prompts/sql-agent/query-generation.v2.1.md`

### Agent-driven prompt improvements
When agents identify a prompt optimization opportunity:
1. **Draft a new version**
   - Create a new versioned prompt file in `prompts/` (avoid destructive overwrite for material behavior changes).
2. **Record rationale**
   - Document the observed failure/limitation and expected benefit in task notes or PR notes.
3. **Validate**
   - Compare old vs new prompt behavior on representative benchmark queries; confirm no regression in trustworthiness/correctness.
4. **Promote**
   - Switch active reference only after validation passes.
5. **Rollback-ready**
   - Retain prior versions in Git history and keep promotion changes small for fast revert.

## 3) Environment & Data Handling
### 3.1 Benchmark fixtures
- Treat `exportedsql/*.sql` as benchmark fixtures; avoid unnecessary reformatting.
- One database per file; preserve generated dump style unless change is intentional.

### 3.2 Import/verification workflow
- Use documented import path (`docs/mysql-import.md`) for environment parity.
- Validate changed dumps by importing into disposable/local MySQL and checking:
  - `CREATE DATABASE`
  - `USE`
  - table definitions and basic execution success

### 3.3 Large artifacts
- Call out large binary/archive changes explicitly (e.g., `nw_mysql_dump.zip`) in review notes.

## 4) Abstention-First Query/Ontology Workflow
When handling retrieval, ontology mapping, or SQL generation tasks:
1. **Entity mapping check**
   - Mark mappings as: `proven`, `inferred`, or `unknown`.
2. **Ambiguity gate**
   - If critical links remain `unknown` or multiple plausible mappings exist, **stop and request clarification**.
3. **Grounded generation**
   - Produce SQL or ontology updates only from `proven`/well-justified `inferred` relationships.
4. **Audit**
   - If an audit finds unsupported mappings/joins, roll back or revise draft before merge.

## 5) Validation Checklist by Change Type
### 5.1 SQL dump updates
- [ ] Import succeeds in MySQL
- [ ] `git diff -- exportedsql/<name>.sql` reviewed
- [ ] No accidental formatting/data churn
- [ ] Manual validation notes prepared

### 5.2 Docs/process updates
- [ ] Consistent with `AGENTS.md`
- [ ] Synced against `docs/DOCUMENT_RELATIONSHIPS.md` (dependencies + trigger rules)
- [ ] Any directional change reflected in `PLAN.md` / `DECISIONS.md` as needed
- [ ] Any durable correction reflected in `LESSONS.md` or explicitly deemed unnecessary
- [ ] Commands/paths are reproducible

### 5.3 Future code modules (retrieval/ontology/eval)
- [ ] Tests added/updated
- [ ] Edge cases covered
- [ ] No dead code or unused imports
- [ ] Prompts are runtime-loaded from `prompts/` (no hardcoded production prompt strings)
- [ ] Prompt naming follows `prompts/{agent-role}/{task-name}.v{major}.{minor}.md`
- [ ] Benchmark impact of prompt changes recorded
- [ ] Manual benchmark impact noted

### 5.4 Definition of done
- [ ] Completion claim is backed by concrete validation evidence
- [ ] Residual risks or unverified assumptions are stated explicitly
- [ ] Required review-agent or audit steps completed for significant changes
- [ ] No unsupported `proven` claim is based only on inference

## 6) Commit & PR Hygiene
- Use clear imperative commit messages (e.g., `Add keystone schema export`, `Define ontology mapping draft`).
- Keep commits scoped to one dataset/feature/evaluation change where possible.
- PRs should include:
  1. Purpose and impact
  2. Affected files
  3. Validation results, including a `review-agent` report formatted with `prompts/review-agent/report-template.v1.0.md`
  4. Adversarial audit summary using `prompts/review-agent/sql-benchmark-review.v1.0.md`
  5. Notes on benchmark comparability risks

## 7) Suggested Clarification Template (Abstention Path)
Use this when ambiguity blocks safe execution:

> I found multiple plausible mappings for this request and cannot verify a trustworthy join path from current evidence.  
> Please confirm:
> 1) intended entity/table,  
> 2) required time/window filters,  
> 3) acceptable fallback assumptions (if any).  
> I’ll proceed immediately once confirmed.

## 8) Alignment Note
- `WORKFLOW.md` is intentionally procedural and complements `AGENTS.md` (policy/conventions), not replaces it.
- If conflict appears, **`AGENTS.md` takes precedence**.
