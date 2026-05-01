# Decision Log

## Purpose

Record documentation and research decisions that materially affect scope, interfaces, or interpretation.

| Date | Decision | Rationale | Status |
| --- | --- | --- | --- |
| 2026-05-01 | Use a 7-directory documentation tree with `00_manifest` as governance/meta layer. | The requested system is sometimes described as 6 layers, but the actual tree includes the manifest layer. | Accepted |
| 2026-05-01 | Preserve original Chinese source files unchanged. | They are canonical source material for translation and future comparison. | Accepted |
| 2026-05-01 | Treat theory as research basis, not implementation authority. | Implementation must pass through specs, schemas, experiments, and evaluation. | Accepted |
| 2026-05-01 | Use JSON Schema draft-07 skeletons with `schema_version` as the only required field initially. | The runtime fields are not yet empirically validated or fully specified. | Accepted |

## Open Decisions

- First MVP vertical domain.
- Verifier architecture.
- Minimum benchmark size.
- Human labeling budget.
- Side-effect classes allowed in the first runtime.
