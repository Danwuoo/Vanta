# Experiment 002 Local Run Report

## Experiment

- Experiment ID: `experiment_002_evidence_verifier`
- Date: 2026-05-03
- Runtime version: local `vanta` workspace, Mix project version `0.1.0`
- Evaluator: fixture oracle
- Dataset or benchmark: seven Document Ops fixtures
- Status: `Completed OpenClaw harness run`
- Result path:
  `docs/04_experiments/results/experiment_002/20260503_235319/`

## Setup

- Baseline: `final_answer` and `raw_trace` LLM verifier arms.
- Treatment: `structured_evidence_packet` LLM verifier arm.
- Backbone model: OpenClaw `openai-codex/gpt-5.4`.
- Tool interface: OpenClaw local harness through WSL.
- Action source: fixture `expected/acceptance.json` action sequences.
- Side-effect classes: `READ_ONLY`, `SIMULATED`, and `REVERSIBLE`.

## Metrics

| Metric | Final Answer | Raw Trace | Structured Evidence Packet | Notes |
| --- | --- | --- | --- | --- |
| `verifier_false_accept_rate` | `0.6666666666666666` | `1.0` | `0.0` | Invalid oracle item accepted by LLM verifier. |
| `verifier_false_reject_rate` | `1.0` | `0.25` | `1.0` | Valid oracle item not accepted by LLM verifier. |
| `evidence_sufficiency_score` | `0.0` | `0.0` | `1.0` | Structured packet complete and provenance-grounded. |
| `verifier_brier_score` | `0.7829` | `0.5327857142857143` | `0.42857142857142855` | Mean squared error between confidence and strict correctness. |
| `request_evidence_rate` | `0.42857142857142855` | `0.14285714285714285` | `0.0` | Reported separately from false reject. |
| `abstain_rate` | `0.2857142857142857` | `0.0` | `1.0` | Reported separately from false reject. |

## Run Command

Command run on 2026-05-03:

```powershell
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$out = "docs/04_experiments/results/experiment_002/$timestamp"
mix vanta.experiment002 --verifier openclaw --model openai-codex/gpt-5.4 --out $out
```

Observed result path:

```text
docs/04_experiments/results/experiment_002/20260503_235319/
```

`run.json` and `summary.md` were produced.

## Findings

- The run status is `completed`; `run.json` validates against
  `experiment_run.schema.json`.
- The OpenClaw `main` agent allowlist was updated to include
  `openai-codex/gpt-5.4`; primary default model remains unchanged.
- The final-answer arm produced decisions `accept=2`, `request_evidence=3`,
  and `abstain=2`.
- The raw-trace arm produced decisions `accept=6` and `request_evidence=1`.
- The structured Evidence Packet arm produced `abstain=7`. It had
  `evidence_sufficiency_score == 1.0` and `verifier_false_accept_rate == 0.0`,
  but this came with `verifier_false_reject_rate == 1.0` because every valid
  structured item was not accepted.
- This completed local harness run does not support H2. It records that the
  structured arm avoided false accepts only by abstaining on every item.

## Additional Runs

- The previous completed `openai-codex/gpt-5.4-mini` run is retained at
  `docs/04_experiments/results/experiment_002/20260503_231430/`.
- An earlier `openai-codex/gpt-5.4` attempt before the allowlist change is
  retained at
  `docs/04_experiments/results/experiment_002/20260503_234357/`.
- Status: `partial`.
- `run.json` validates against `experiment_run.schema.json`, but all 21 verifier
  calls have `verifier_error` entries.
- Failure reason: OpenClaw agent `main` rejects the model override:
  `Model override "openai-codex/gpt-5.4" is not allowed for agent "main"`.
- This earlier attempt is superseded by the completed
  `docs/04_experiments/results/experiment_002/20260503_235319/` run.

## Failures And Risks

- The previous path-escape shell quoting failure was fixed before this completed
  run; the completed run contains no `verifier_error` entries.
- The completed status should be interpreted narrowly. Seven structured-arm
  outputs and two final-answer outputs were normalized to `abstain` after
  OpenClaw returned `Context overflow: prompt too large for the model`.
- Adapter parse-failure-to-abstain normalization produces schema-valid verifier
  outputs, so it does not mark the run `partial`; the report must still treat
  these as harness/model failures for interpreting H2.
- OpenClaw results include local harness effects and are not pure model-only
  verifier results.
- Fixture oracle labels are deterministic but are not a substitute for human
  labels in broader verifier evaluation.

## Next Steps

- Decide whether parse-failure-to-abstain should keep `status == "completed"`
  or mark the run `partial` for Experiment 002 reporting.
- Try a larger-context OpenClaw verifier model or shrink structured prompts
  further before treating the structured-arm result as a meaningful verifier
  comparison.
- Decide whether a direct Responses verifier arm is needed before broader MVP
  comparison.
