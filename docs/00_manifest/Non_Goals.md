# Non-Goals

## Purpose

This document prevents scope creep while the Vanta documentation system is still converting theory into testable specs.

## Non-Goals For MVP

- Proving that Vanta is a validated next-generation agent theory.
- Building a general-purpose autonomous agent across arbitrary domains.
- Supporting irreversible real-world side effects without explicit escalation.
- Treating memory append as learning.
- Treating tool traces as canonical reasoning state.
- Treating Evidence Packet content as explanation instead of structured evidence.
- Treating Episode Journal as durable memory.
- Treating Context OS as long-context stuffing.
- Treating Verifier Runtime as final-answer-only judging.
- Assuming rollback is available for all side effects.
- Optimizing only final task success while ignoring process integrity.
- Replacing external policy engines or human approval in high-risk settings.
- Implementing full long-term memory governance before the minimal closed loop is measured.

## Deferred Areas

- Training a model on runtime feedback.
- Full Context OS optimization.
- Full skill library management.
- Public benchmark publication.
- Production deployment.

## Related Documents

- [Project Manifest](Project_Manifest.md)
- [MVP Architecture](../06_engineering/MVP_Architecture.md)
- [Ablation Plan](../04_experiments/Ablation_Plan.md)
