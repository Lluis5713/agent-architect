# Agent Orchestration Framework

This is a **project planning repository**, not a code repository. It contains business context, specifications, and agent skills that drive the development of a multi-service system.

## How This Repo Works

1. **Setup Agent** interviews the human and populates manifest, standards, and project context (Phase 0)
2. **Spec Agents** read everything and generate detailed specs in `services/<name>/specs/`
3. **Contract Agents** ensure cross-service APIs are consistent in `contracts/`
4. **Builder Agents** take specs to separate code repos and build the services
5. **Validation Agents** verify cross-service integration

## Key Files

- `manifest.yaml` — Single source of truth. Defines all services, tech stack, and build targets
- `context/` — Business requirements, designs, references (human-maintained)
- `services/` — Per-service context and generated specs
- `contracts/` — Shared API contracts between services
- `standards/` — Coding standards, patterns, and rules agents must follow
- `phases/` — Phase completion tracking

## Phase Workflow

Run phases in order using slash commands:

```
/project:0-setup       → Interactive project setup (run this first!)
/project:1-discover    → Analyze all context, ask clarifying questions
/project:2-architect   → Define service boundaries, data flow, tech decisions
/project:3-specify     → Generate detailed SPEC.md per service
/project:4-contract    → Generate and validate cross-service API contracts
/project:5-build       → Build services (runs per service, respects build_targets)
/project:6-validate    → Cross-service integration validation
/project:7-review      → Code quality, security, best practices review
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
- ALWAYS write specs to `services/<name>/specs/` — never inline in other files
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
