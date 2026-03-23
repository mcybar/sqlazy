# Project Plan

## Purpose
This file is the active planning surface for `sqlazy`. It should answer three questions at all times:
- What are we building now?
- Why is this the current priority?
- What evidence or blockers determine the next step?

## Operating Rules
- Plans must be grounded in repository evidence, benchmark results, or explicit product direction.
- The system must prefer abstention over hallucination. If the agent cannot justify an ontology mapping or SQL answer, it must ask for clarification or decline to answer.
- Every major plan item should name its expected artifact, owner, and exit criteria.
- Keep this file forward-looking. Historical rationale belongs in `DECISIONS.md`.

## Current Objective
Build a text-to-SQL ontology layer over the imported OpenStack-style MySQL datasets that maximizes correctness, supports clarification when confidence is low, and produces auditable relationship mappings.

## Phases
### 1. Metadata Inventory
- Extract schema, keys, indexes, row counts, value distributions, and candidate joins for `keystone`, `csail_stata_glance`, `csail_stata_cinder`, `csail_stata_neutron`, and `csail_stata_nova`.
- Output: machine-readable schema catalog.
- Exit criteria: complete inventory with validation against live MySQL.

### 2. Ontology Draft
- Use the schema catalog to propose business entities, aliases, lifecycle states, and cross-database relationships.
- Mark every relationship as `proven`, `inferred`, or `unknown`.
- Output: ontology draft with evidence references.

### 3. Review And Correction
- Review generated mappings against schema evidence and benchmark queries.
- Resolve ambiguous terms, overloaded columns, and weak joins.
- Output: corrected ontology and open-question list.

### 4. Execution Layer
- Build the grounding and SQL-generation pipeline using the ontology as a constraint layer.
- Add an escape hatch for clarification instead of forced answers.
- Output: query planner, SQL generator, and validation flow.

### 5. Audit
- Audit mappings and generated SQL for logical consistency, unsupported assumptions, and benchmark regressions.
- Output: audit report with pass/fail findings.

## Immediate Next Steps
- Generate the metadata extraction spec.
- Define the ontology artifact schema.
- Define clarification rules and abstention thresholds.
