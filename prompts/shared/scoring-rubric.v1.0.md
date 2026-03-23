# Shared Scoring Rubric v1.0

## Scoring Method
- Score each dimension from 0-10.
- Weighted total = sum(score/10 * weight).
- Use evidence-backed scoring only; do not infer missing validation.

## Dimensions

1. **Completeness (20)**
   - Did the change fully satisfy requested scope?
   - Were all required artifacts updated?

2. **Correctness (25)**
   - Is behavior/schema/prompt logic technically correct?
   - Any factual or semantic errors?

3. **Reproducibility (20)**
   - Can reviewers reproduce outcomes from documented steps?
   - Are benchmark comparisons preserved?

4. **Validation Quality (15)**
   - Are checks appropriate, sufficient, and clearly evidenced?
   - Are regressions explicitly considered?

5. **Safety/Risk Control (10)**
   - Are rollback paths and failure handling clear?
   - Any operational or data integrity risks left unmanaged?

6. **Documentation Quality (4)**
   - Are rationale, constraints, and usage notes clear?

7. **Maintainability (3)**
   - Is structure modular and policy-aligned (including prompt architecture)?

8. **AI Slop / Busywork Risk (3)**
   - Does the change avoid boilerplate, speculative abstraction, and cosmetic churn?
   - Is there clear, measurable value in correctness, benchmark quality, reliability, or maintainability?

## Hard-Floor Rules
If any condition below is true, final verdict cannot be PASS:
1. SQL import validation fails for changed dump artifacts.
2. Critical claim lacks evidence.
3. Prompt architecture policy violated (e.g., hardcoded production prompts outside `prompts/`).

## Interpretation
- **90-100**: Strong approval quality
- **75-89**: Acceptable with minor fixes
- **60-74**: Significant issues; revise before merge
- **<60**: Not merge-ready
