# Ontology Strategy Discussion

Date: 2026-03-22

## Model Recommendation
As of March 22, 2026, the best fit for the hardest ontology work is `gpt-5.4-pro` for the planning and audit stages, and `gpt-5.4` for most review and execution work.

OpenAI's current model docs describe:
- `gpt-5.4` as the flagship model for complex reasoning and coding
- `gpt-5.4-pro` as the version that thinks harder for tougher problems

Sources:
- <https://developers.openai.com/api/docs/models>
- <https://developers.openai.com/api/docs/models/gpt-5.4>
- <https://developers.openai.com/api/docs/models/gpt-5.4-pro>

## Imported Databases
- `keystone`
- `csail_stata_glance`
- `csail_stata_cinder`
- `csail_stata_neutron`
- `csail_stata_nova`

## Accuracy Target
`100% accuracy` is a valid program goal, but for NL-to-SQL over a live operational ontology the practical system target is:
- `100% correctness on answered queries`
- high coverage
- safe abstention when confidence is low

The system must be allowed to say:
- `I need clarification`
- `I cannot prove this mapping yet`

## Planning Framework

### 1. Plan
- Build a canonical metadata graph from all five databases: tables, columns, primary keys, foreign keys, indexes, enums, nullability, row counts, value distributions, and join evidence.
- Run `gpt-5.4-pro` over that metadata to propose a business ontology: entities, concepts, aliases, metrics, lifecycle states, and cross-database relationships.
- Require proactive questioning by the planner. It should explicitly emit:
  - unknown terms
  - ambiguous joins
  - overloaded fields
  - candidate business meanings needing confirmation
- Output artifacts:
  - physical schema catalog
  - business ontology draft
  - relationship hypotheses
  - open questions

### 2. Review
- Use `gpt-5.4` plus deterministic checks to review planner output against actual schema evidence.
- Separate:
  - proven relationships
  - inferred relationships
  - unsupported assumptions
- Every ontology edge must carry an evidence record:
  - source tables and columns
  - join path
  - confidence
  - rationale

### 3. Execute
- Materialize the ontology as a knowledge graph with typed nodes and edges.
- Build an NL-to-SQL pipeline with:
  - intent detection
  - ontology grounding
  - constrained join planning
  - SQL generation
  - SQL validation against schema
- Use smaller models only for repetitive extraction and normalization, not for final semantic mapping.

### 4. Audit
- Re-run `gpt-5.4-pro` as an adversarial auditor.
- Audit for:
  - impossible joins
  - cardinality mistakes
  - entity duplication
  - metric leakage
  - temporal inconsistency
  - identity confusion across databases
- Require the auditor to approve, reject, or request clarification for every high-impact relationship.

## Operating Model
Use a multi-agent structure:
- Planner: `gpt-5.4-pro`, `reasoning.effort=xhigh`
- Reviewer: `gpt-5.4`, `high`
- Executor: `gpt-5.4`, `medium` or `high`
- Auditor: `gpt-5.4-pro`, `xhigh`
