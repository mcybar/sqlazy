# Decisions Log

## Purpose
Record major technical and product decisions with enough context to understand why they were made and when they should be revisited.

## Template
### [Decision Title]
- Date: YYYY-MM-DD
- Status: proposed | accepted | superseded
- Context:
- Decision:
- Reasoning:
- Consequences:
- Revisit when:

## Accepted Decisions
### Local MySQL As Source Of Truth
- Date: 2026-03-22
- Status: accepted
- Context: Repository data is stored as native MySQL dumps and needs fast local iteration for ontology and NL-to-SQL work.
- Decision: Use a local Homebrew MySQL instance as the primary working database.
- Reasoning: It matches the dump format directly and avoids Docker overhead for day-to-day iteration.
- Consequences: Tooling and schema extraction should target MySQL first.
- Revisit when: A stronger need emerges for a second analytical store.

### Abstention Over Hallucination
- Date: 2026-03-22
- Status: accepted
- Context: The target system must be trusted for operational questions over complex infrastructure data.
- Decision: The agent must ask clarifying questions or abstain when it cannot justify an ontology mapping or SQL answer.
- Reasoning: Unsupported answers are more damaging than lower coverage.
- Consequences: Evaluation must score correctness and abstention, not only answer rate.
- Revisit when: Never as a principle; only refine thresholds and triggers.

### PLAN.md As Active Planning Surface
- Date: 2026-03-22
- Status: accepted
- Context: The project needs a single current planning location plus separate tracking of roadmap and past reasoning.
- Decision: Keep active execution planning in `PLAN.md`, forward-looking sequencing in `ROADMAP.md`, and historical rationale in `DECISIONS.md`.
- Reasoning: This separates current work from long-term direction and from historical context.
- Consequences: Future major project changes should update all three files where relevant.
- Revisit when: The repo grows enough to justify a dedicated `docs/` planning structure.

### Model Assignment For Ontology Workflow
- Date: 2026-03-22
- Status: accepted
- Context: The project needs a default model strategy for planning, review, execution, and audit in the ontology pipeline.
- Decision: Use `gpt-5.4-pro` for planning and audit, and `gpt-5.4` for most review and execution tasks.
- Reasoning: Planning and audit require the deepest reasoning and highest tolerance for ambiguity, while review and execution benefit from strong reasoning with lower cost and latency.
- Consequences: Prompts, agent roles, and evaluation flows should reflect this default model split.
- Revisit when: OpenAI releases a stronger model or benchmark results show a better assignment.

### Correctness Over Forced Answers
- Date: 2026-03-22
- Status: accepted
- Context: The project goal is extremely high NL-to-SQL reliability over a live operational ontology.
- Decision: Optimize for `100% correctness on answered queries`, high coverage, and safe abstention when confidence is low.
- Reasoning: Forced answers create silent failure modes that are worse than explicit clarification or abstention.
- Consequences: The system must support clarification prompts, abstention behavior, and evaluation metrics that separate correctness from coverage.
- Revisit when: Never as a principle; only refine policy thresholds and user experience.
