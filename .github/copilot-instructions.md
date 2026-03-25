# Agent Architect

This is a **project planning repository**, not a code repository. It contains business context, specifications, and agent skills that drive the development of a multi-service system.

## How This Repo Works

### Sequential Mode (default)
1. **Setup Agent** interviews the human and populates manifest, standards, and project context (Phase 0)
2. **Spec Agents** read everything and generate detailed specs + test plans in `services/<name>/specs/`
3. **Contract Agents** ensure cross-service APIs are consistent in `contracts/`
4. **Builder Agents** take specs to separate code repos and build the services
5. **Validation Agents** verify cross-service integration

### Team Mode (optional — requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`)
Run `/project:team-start` after Phase 0 to spawn a 5-agent team that orchestrates Phases 1-7 automatically:
- **Team Lead / Product Owner** (opus) — orchestrates phases, enforces quality gates, human liaison
- **Sr. Solutions Architect** (opus) — discovery, architecture, contracts, cross-service review
- **Sr. Lead Engineer** (opus) — specs, test plans, builds services
- **Sr. QA & Security Engineer** (sonnet) — test augmentation, validation, security review
- **Sr. DevOps Engineer** (sonnet) — infrastructure, CI/CD, docker-compose, deployment review

Agents challenge each other's work and coordinate via task dependencies. The human approves at quality gates.

## Key Files

- `manifest.yaml` — Single source of truth. Defines all services, tech stack, build targets, and framework version
- `context/` — Business requirements, designs, references (human-maintained)
- `services/` — Per-service context and generated specs
  - `services/<name>/specs/SPEC.md` — Implementation specification (Phase 3)
  - `services/<name>/specs/TEST-PLAN.md` — Test cases with traceability (Phase 3)
  - `services/<name>/specs/BUILD-REPORT.md` — Build results (Phase 5)
  - `services/<name>/specs/TEST-REPORT.md` — Test execution results (Phase 5)
- `contracts/` — Shared API contracts between services
  - `contracts/CONTRACT-MATRIX.md` — Cross-service interface overview (Phase 4)
  - `contracts/INTEGRATION-TEST-PLAN.md` — Cross-service test scenarios (Phase 4)
- `standards/` — Coding standards, API design, and testing standards agents must follow
- `phases/` — Phase completion tracking

## Phase Workflow

Run phases in order using slash commands:

```
/project:0-setup       → Interactive project setup (run this first!)
/project:1-discover    → Analyze all context, ask clarifying questions
/project:2-architect   → Define service boundaries, data flow, tech decisions
/project:3-specify     → Generate detailed SPEC.md + TEST-PLAN.md per service
/project:4-contract    → Generate API contracts + INTEGRATION-TEST-PLAN.md
/project:5-build       → Build services with test traceability (per service)
/project:6-validate    → Cross-service integration validation
/project:7-review      → Code quality, security, test completeness review
```

### Team Orchestration Commands

```
/project:team-start    → Spawn 5-agent team, auto-orchestrate Phases 1-7
/project:team-migrate  → Upgrade v1 repo to team-capable (v2.0)
/project:team-status   → Enhanced dashboard with agent assignments & test coverage
```

## Ask & Remember Principle

When an agent needs information that isn't configured yet, it should:
1. **ASK** the human in a clear, guided way (offer options, suggest defaults)
2. **WRITE** the answer to the correct file immediately (manifest.yaml, CONTEXT.md, standards, etc.)
3. **NEVER** ask the same question twice — check what's already configured first

This applies to: project setup, build paths, service configuration, standards, and any other configuration that can be persisted. If the human says "not sure yet" or "defaults are fine", record a sensible default and move on.

## Rules for All Agents

- ALWAYS read `manifest.yaml` first — it drives everything
- NEVER modify files in `context/references/` — that's human-provided input
- `context/PROJECT.md` can be written by the setup agent (Phase 0) and read by all other agents
- `context/decisions/` can be written by the architect agent (Phase 2)
- ALWAYS write specs and test plans to `services/<name>/specs/` — never inline in other files
- ALWAYS generate TEST-PLAN.md alongside SPEC.md in Phase 3 — follow `standards/testing-standards.md`
- ALWAYS generate TEST-REPORT.md alongside BUILD-REPORT.md in Phase 5 — map tests to test case IDs
- ALWAYS generate contracts to `contracts/` — shared across services
- ALWAYS build code to the service's `local_path` defined in `manifest.yaml` — if not set, ASK the human for the path and save it back to the manifest. NEVER write service code inside this planning repo
- Respect `status` field: skip services marked `skip`, reference `existing` services, only build `new` and `enrich`
- Respect `build_targets` in manifest — if set, only work on listed services
- Follow standards in `standards/` for all generated code
- Write phase completion markers to `phases/` after each phase
- Check prerequisites before running any phase — read the required phase files in `phases/` first
- When a slash command receives arguments (available as `$ARGUMENTS`), parse them to determine the target service or options
- For large reference files (PDFs > 10 pages, long confluence docs), summarize key points rather than trying to read everything — prioritize business rules, API specs, and data models over general prose
- When reading `manifest.local.yaml` for local_path overrides, fall back to `manifest.yaml` if the local file doesn't exist
