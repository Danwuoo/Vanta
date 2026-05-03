# Experiment 002: Evidence Verifier

## Research question

Does structured Evidence Packet input improve verifier reliability compared with final-answer judging or raw trace judging?

## Hypothesis tested

H2: Evidence Packet can significantly improve verifier reliability.

## Baseline

Verifier sees only final answer or unstructured execution trace.

For the implemented local runner, the two baseline arms are:

- `final_answer`
- `raw_trace`

## Treatment

Verifier consumes structured Evidence Packet fields including pre-state, action reference, observation, post-state, constraints, and provenance.

For the implemented local runner, the treatment arm is:

- `structured_evidence_packet`

The LLM verifier path is OpenClaw local harness and must be labeled as
`openclaw_agent_local/<model>_verifier`. It is not a pure model-only result.

Action sequences are fixed from fixture `expected/acceptance.json` recipes so
planner variation is not mixed into the verifier comparison.

## Metrics

- `verifier_false_accept_rate`
- `verifier_false_reject_rate`
- `evidence_sufficiency_score`
- `verifier_brier_score`
- `request_evidence_rate`
- `abstain_rate`

For this local runner, `reject`, `abstain`, and `request_evidence` all count as
false reject when the fixture oracle label is valid.

## Required logs

- Evidence packets.
- Verifier decisions.
- Fixture oracle accept/reject labels.
- Provenance source records.

Human labels are deferred for this local smoke configuration.

## Success criteria

- Treatment reduces false accept rate under matched task distribution.
- Treatment does not create an unacceptable false reject increase.
- Evidence sufficiency labels correlate with verifier decisions.

## Failure criteria

- Evidence Packet increases false confidence.
- Verifier accepts invalid actions because model-generated explanations are treated as evidence.
- Provenance is missing or not externally grounded.

## Status

Runner implemented; latest OpenClaw measured run completed on 2026-05-03.

Latest measured result:

- Path: `docs/04_experiments/results/experiment_002/20260503_235319/`
- Model: `openai-codex/gpt-5.4`
- Status: `completed`
- Report: `docs/05_evaluation/Experiment_002_Local_Run_Report.md`

The completed run does not support H2. The structured Evidence Packet arm
avoided false accepts only by abstaining on every item, with OpenClaw context
overflow normalized to schema-valid `abstain` outputs.

An earlier `openai-codex/gpt-5.4` attempt at
`docs/04_experiments/results/experiment_002/20260503_234357/` was `partial`
because OpenClaw agent `main` did not allow that model override. The OpenClaw
local allowlist was updated before the latest completed run.

Implemented entrypoint:

```powershell
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$out = "docs/04_experiments/results/experiment_002/$timestamp"
mix vanta.experiment002 --verifier openclaw --model openai-codex/gpt-5.4 --out $out
```

Results must be written under
`docs/04_experiments/results/experiment_002/<timestamp>/` and reported as
`completed` only after the OpenClaw verifier run finishes. If OpenClaw preflight
fails, no completed result may be recorded.
