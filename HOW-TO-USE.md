# How To Use — Agent Orchestration Framework

A step-by-step guide for team members using this framework to plan and build microservices projects.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Getting Started (New Project)](#getting-started-new-project)
- [Phase-by-Phase Walkthrough](#phase-by-phase-walkthrough)
- [Common Workflows](#common-workflows)
- [Using with Claude Code](#using-with-claude-code)
- [Using with GitHub Copilot](#using-with-github-copilot)
- [Team Collaboration](#team-collaboration)
- [Troubleshooting](#troubleshooting)
- [Reference: All Commands](#reference-all-commands)

---

## Prerequisites

You need ONE of the following AI coding tools:

| Tool | Install | Minimum Version |
|------|---------|----------------|
| **Claude Code** (recommended) | `npm install -g @anthropic-ai/claude-code` | Any |
| **GitHub Copilot** | VS Code extension + Copilot subscription | Agent mode (GA) |

No other dependencies. The framework is just markdown files and folders.

---

## Getting Started (New Project)

### Step 1: Create your project repo from this template

```bash
# Option A: GitHub template (recommended)
gh repo create my-project-plan --template your-org/agent-orch --private
cd my-project-plan

# Option B: Manual copy
cp -r agent-orch/ my-project-plan/
cd my-project-plan
git init && git add -A && git commit -m "feat: initialize from agent-orch template"
```

### Step 2: Run Phase 0 — Interactive Setup

This is the **only step that requires human input**. The agent interviews you and configures everything.

**With Claude Code:**
```bash
claude
/project:0-setup
```

**With Copilot (VS Code):**
```
# Open Copilot Chat → select "Agent" mode → type:
/0-setup
```

The agent will ask you about (one topic at a time):

```
1. Project name and description          → saves to manifest.yaml
2. Tech stack (language, framework, DB)   → saves to manifest.yaml + standards/
3. Coding conventions and team rules      → saves to standards/coding-standards.md
4. What you're building and for whom      → saves to context/PROJECT.md
5. Each service and its details           → saves to manifest.yaml + services/*/CONTEXT.md
6. Quality gate preferences               → saves to manifest.yaml
```

**Tips:**
- Say **"defaults are fine"** for any section to accept sensible defaults
- Say **"not sure yet"** for anything — the discovery phase will flag it later
- If you get interrupted, re-run `/project:0-setup` — it detects what's already configured and picks up where you left off

### Step 3: Drop in reference materials (optional but recommended)

```bash
# Existing requirements docs
cp ~/Documents/PRD.pdf context/references/requirements/

# UI designs / wireframes
cp ~/Downloads/mockups.png context/references/designs/

# Existing API specs (OpenAPI, Swagger, Postman)
cp ~/projects/payment-api/swagger.yaml context/references/existing-apis/

# Confluence exports
cp ~/Downloads/arch-overview.pdf context/references/confluence/

# Data models / ERDs
cp ~/Documents/data-model.png context/references/data-models/
```

The discovery agent will read all of these in Phase 1.

### Step 4: You're ready — run the phases

Continue to the [Phase-by-Phase Walkthrough](#phase-by-phase-walkthrough) below.

---

## Phase-by-Phase Walkthrough

### Phase 1: Discovery

**What it does:** Reads ALL your context and produces a gap analysis.

```bash
/project:1-discover
```

**Output:** `phases/1-discover.md` containing:
- System understanding (agent's interpretation of what you're building)
- Service map (each service's role and boundaries)
- Gap analysis (what's missing or unclear)
- Risk assessment (where things could go wrong)
- Questions for you (specific, with default assumptions)

**What you do next:**
1. Read `phases/1-discover.md`
2. Answer the questions — edit the file directly, or answer in chat
3. If the agent misunderstood something, clarify in `context/PROJECT.md`
4. Move to Phase 2 when satisfied

**Time:** 2-5 minutes (agent), 10-30 minutes (your review)

---

### Phase 2: Architecture

**What it does:** Makes system-level design decisions based on your context + answers.

```bash
/project:2-architect
```

**Output:**
- `phases/2-architect.md` — architecture document with diagrams, service boundaries, cross-cutting concerns
- `context/decisions/ADR-*.md` — architecture decision records (database strategy, auth, communication patterns)
- Dependency graph showing build order

**What you do next:**
1. Review the architecture document — does the service decomposition make sense?
2. Review ADRs — do you agree with the decisions?
3. If the agent suggests manifest changes, review and confirm
4. Move to Phase 3 when satisfied

**Time:** 3-10 minutes (agent), 15-30 minutes (your review)

---

### Phase 3: Specification

**What it does:** Writes detailed, buildable specs for each service.

```bash
# All services at once (for small projects, < 5 services)
/project:3-specify

# One service at a time (recommended for larger projects)
/project:3-specify order-service
/project:3-specify bff-gateway
/project:3-specify web-ui
```

**Output:** `services/<name>/specs/SPEC.md` for each service, containing:
- API endpoints with exact request/response schemas
- Data models with field types and constraints
- Business logic with preconditions, flows, and error cases
- Events published/subscribed with schemas
- Integration points with failure handling
- Testing strategy with specific test cases
- Implementation sequence (step-by-step build order)
- Dependencies and package versions
- Environment configuration

**What you do next:**
1. **This is the most important review.** Read each SPEC.md carefully
2. Check: Do the API designs make sense? Are business rules correct?
3. Check: Are there missing endpoints or edge cases?
4. Edit SPEC.md directly if you want changes — the builder follows it exactly
5. Move to Phase 4 when all specs are reviewed

**Time:** 5-15 minutes per service (agent), 20-60 minutes per service (your review)

> **Note:** If you re-run this phase, the previous spec is saved as `SPEC.prev.md` so you can diff changes.

---

### Phase 4: Contracts

**What it does:** Extracts all cross-service interfaces into shared contract files.

```bash
/project:4-contract
```

**Output:**
- `contracts/api/<consumer>-to-<provider>.yaml` — OpenAPI specs for each service-to-service call
- `contracts/events/<event-name>.json` — JSON schemas for each async event
- `contracts/shared-models/<model>.json` — shared data types
- `contracts/CONTRACT-MATRIX.md` — overview of all interfaces

**What you do next:**
1. Review `CONTRACT-MATRIX.md` — does every service-to-service interaction have a contract?
2. Spot-check a few contract files — are the schemas correct?
3. These contracts become the source of truth during building
4. Move to Phase 5

**Time:** 3-5 minutes (agent), 5-15 minutes (your review)

---

### HUMAN REVIEW GATE

Before building, ensure specs and contracts are approved:

```bash
# Check status — are all specs and contracts done?
/project:status
```

The builder agent will ask for approval sign-off when you start Phase 5. This records who reviewed what in `manifest.yaml` under `approvals`.

---

### Phase 5: Build

**What it does:** Implements a single service from its spec.

```bash
# Build one service (recommended)
/project:5-build order-service

# Or let the agent pick from build_targets in manifest
/project:5-build
```

**First time — the agent asks where the code goes:**
```
I'm ready to build order-service. Where should the code live?

Options:
1. Enter an absolute path (e.g., /Users/you/projects/order-service)
2. Enter a relative path from this planning repo (e.g., ../order-service)
3. If this is an existing repo, I can clone from: [repo URL]
```

The path is saved to `manifest.local.yaml` (gitignored) — it never asks again.

**What the agent does:**
1. Scaffolds the project (framework, config, health check, Dockerfile)
2. Implements features in the spec's exact order
3. Writes tests alongside every feature
4. Runs tests after each step
5. Commits after each step
6. Creates build report at `services/<name>/specs/BUILD-REPORT.md`

**What you do next:**
1. Read the BUILD-REPORT.md — any gaps or deviations?
2. Run the service locally — does it start?
3. Review the code if desired
4. Repeat for the next service, or move to Phase 6

**Time:** 10-30 minutes per service (agent)

**Building multiple services in parallel:**
```bash
# Terminal 1
claude -p "/project:5-build order-service"

# Terminal 2
claude -p "/project:5-build bff-gateway"
```

---

### Phase 6: Validation

**What it does:** Verifies that built services work together.

```bash
/project:6-validate
```

**Output:** `phases/6-validate.md` containing:
- Contract compliance results (pass/fail per service)
- Cross-service integration test scenarios
- Docker compose for running all services together
- Issues found with recommended fixes

**What you do next:**
1. Review issues found
2. Run `/project:rebuild-service <name>` for any service that needs fixes
3. Move to Phase 7

**Time:** 5-15 minutes (agent), varies (fixing issues)

---

### Phase 7: Review

**What it does:** Reviews all generated code for production readiness.

```bash
/project:7-review
```

**Output:** `phases/7-review.md` — code review report with:
- Critical issues (must fix before production)
- Warnings (should fix)
- Suggestions (nice to have)
- Per-service scorecard (Security, Reliability, Performance, Maintainability, Testing)

**What you do next:**
1. Fix critical issues using `/project:rebuild-service <name>`
2. Address warnings as appropriate
3. Your services are ready for deployment

**Time:** 5-10 minutes (agent), varies (fixing issues)

---

## Common Workflows

### Adding a new service mid-project

```bash
/project:add-service notification-service domain

# Then fill in the context
vim services/notification-service/CONTEXT.md

# Re-run spec for just this service
/project:3-specify notification-service

# Re-run contracts to include new service interfaces
/project:4-contract

# Build it
/project:5-build notification-service
```

### Changing requirements after specs are written

```bash
# 1. Update the context
vim context/PROJECT.md                           # or service CONTEXT.md

# 2. Re-run spec for affected services
/project:3-specify order-service                 # previous spec saved as SPEC.prev.md

# 3. Review what changed
diff services/order-service/specs/SPEC.prev.md services/order-service/specs/SPEC.md

# 4. Re-run contracts if APIs changed
/project:4-contract

# 5. Rebuild the service
/project:rebuild-service order-service
```

### Enriching an existing service (adding features)

```bash
# 1. Set status to "enrich" in manifest.yaml
# 2. Put existing API spec in services/<name>/references/
# 3. Describe new features in services/<name>/CONTEXT.md
# 4. Run spec phase — it writes specs for NEW/CHANGED parts only
/project:3-specify payment-service

# 5. Build — agent modifies existing code, doesn't rebuild from scratch
/project:5-build payment-service
```

### Checking project progress

```bash
/project:status
```

Shows a dashboard with:
- Which phases are complete
- Which services have specs / are built
- Current build targets
- Recommended next action

### Fixing issues from code review

```bash
# After Phase 7 flags issues:
/project:rebuild-service order-service
# Agent reads the review report and fixes flagged issues
```

---

## Using with Claude Code

### Setup

```bash
# Install Claude Code (if not already installed)
npm install -g @anthropic-ai/claude-code

# Navigate to the planning repo
cd my-project-plan

# Start Claude Code
claude
```

### Running phases

All phases are slash commands prefixed with `/project:`:

```bash
/project:0-setup                    # Interactive setup
/project:1-discover                 # Discovery
/project:2-architect                # Architecture
/project:3-specify                  # Specs (all services)
/project:3-specify order-service    # Spec (one service)
/project:4-contract                 # Contracts
/project:5-build order-service      # Build one service
/project:6-validate                 # Cross-service validation
/project:7-review                   # Code review

/project:status                     # Progress dashboard
/project:add-service name type      # Add new service
/project:rebuild-service name       # Rebuild after changes
```

### Running headless (CI/automation)

```bash
# Run a phase non-interactively
claude -p "/project:3-specify order-service"

# Run build in background
claude -p "/project:5-build order-service" --allowedTools "Read,Edit,Write,Bash,Glob,Grep"
```

### Using with Agent Teams (experimental)

```bash
# Enable agent teams
# In settings: CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1

# Ask Claude to coordinate multiple builders
# "Build order-service and bff-gateway in parallel using agent teams"
```

---

## Using with GitHub Copilot

### Setup

1. Open the planning repo in VS Code
2. Ensure Copilot extension is installed and signed in
3. Copilot automatically reads `.github/copilot-instructions.md`

### Running phases

Open Copilot Chat in **Agent mode** (select "Agent" from the dropdown):

```
# Type / to see all available prompts:
/0-setup
/1-discover
/2-architect
/3-specify
/5-build
...

# Or describe what you want naturally:
"Run the discovery phase and analyze all context in this repo"
"Generate a spec for the order-service based on the architecture"
"Build the bff-gateway service following its SPEC.md"
```

### Using with Copilot Coding Agent (autonomous)

For autonomous execution via GitHub Issues:

1. Create a GitHub issue:
   ```
   Title: Build order-service from spec

   Follow the instructions in .github/prompts/5-build.prompt.md
   to build the order-service. The spec is at
   services/order-service/specs/SPEC.md.
   ```

2. Assign the issue to **Copilot**
3. Copilot creates a branch, builds the code, runs tests, opens a PR
4. Review the PR and provide feedback — Copilot iterates

### Keeping prompts in sync

After editing any `.claude/commands/*.md` file:

```bash
./scripts/sync-prompts.sh
```

This copies all Claude commands to `.github/prompts/` as Copilot prompt files.

---

## Team Collaboration

### Initial setup for each developer

When a new team member clones the planning repo:

```bash
git clone https://github.com/your-org/my-project-plan
cd my-project-plan

# Create local path overrides (machine-specific)
cp manifest.local.yaml.example manifest.local.yaml
vim manifest.local.yaml   # Set your local paths for each service
```

### What's shared vs local

| File | Shared (git) | Local (gitignored) |
|------|:-----------:|:-----------------:|
| `manifest.yaml` | Yes | — |
| `manifest.local.yaml` | — | Yes (paths) |
| `context/` | Yes | — |
| `services/*/CONTEXT.md` | Yes | — |
| `services/*/specs/SPEC.md` | Yes | — |
| `contracts/` | Yes | — |
| `standards/` | Yes | — |
| `phases/` | Yes | — |
| Service code repos | — | Yes (separate repos) |

### Typical team workflow

```
   Lead Architect              Dev 1                    Dev 2
   ─────────────              ─────                    ─────
   /project:0-setup
   /project:1-discover
   /project:2-architect
   /project:3-specify
   /project:4-contract
   ──── reviews & approves specs ────
                               /project:5-build         /project:5-build
                               order-service             payment-service

                               /project:5-build
                               bff-gateway

   /project:6-validate
   /project:7-review
                               /project:rebuild-service  /project:rebuild-service
                               order-service             payment-service
```

### Approval tracking

When the builder agent starts, it checks if specs were approved:

```
Specs need approval before building.
Has someone reviewed the specs in services/*/specs/SPEC.md?
If yes, who approved?
```

The approval is recorded in `manifest.yaml`:
```yaml
approvals:
  spec_review:
    approved_by: "@lead-architect"
    date: "2026-03-17"
```

---

## Troubleshooting

### "Run /project:0-setup first"

The discovery agent detected that `manifest.yaml` hasn't been configured. Run Phase 0 first.

### Spec agent runs out of context / quality drops

For projects with 5+ services, specify one at a time:
```bash
/project:3-specify order-service
/project:3-specify bff-gateway
```

### Builder doesn't know where to put code

The `local_path` is empty. The agent will ask you for the path. Once provided, it's saved to `manifest.local.yaml` and won't ask again.

### I changed a spec but the builder uses the old one

Re-read the spec: the builder always reads `SPEC.md` fresh. If you edited it manually, just re-run the build:
```bash
/project:rebuild-service order-service
```

### Copilot prompts are outdated

After editing `.claude/commands/*.md`, re-sync:
```bash
./scripts/sync-prompts.sh
```

### Two developers have merge conflicts on manifest.yaml

This usually happens with `local_path` fields. Solution: local paths should ONLY be in `manifest.local.yaml` (gitignored). If paths leaked into `manifest.yaml`, move them to `manifest.local.yaml` and clear them in `manifest.yaml`.

### I want to start over on a service

```bash
# Reset the service status in manifest.yaml to "new"
# Delete the old spec
rm services/order-service/specs/SPEC.md
rm services/order-service/specs/BUILD-REPORT.md

# Re-run from spec phase
/project:3-specify order-service
/project:5-build order-service
```

### The agent adds features not in the spec

The builder is instructed to follow SPEC.md exactly. If it gold-plates, remind it:
```
Follow the SPEC.md exactly. Do not add features not in the spec.
```

---

## Reference: All Commands

### Phase Commands

| Command | Purpose | Input | Output |
|---------|---------|-------|--------|
| `/project:0-setup` | Interactive project setup | Your answers | manifest.yaml, PROJECT.md, standards, service folders |
| `/project:1-discover` | Analyze context | Everything in context/ + services/ | `phases/1-discover.md` |
| `/project:2-architect` | System design | Discovery + standards | `phases/2-architect.md` + ADRs |
| `/project:3-specify [service]` | Write specs | Architecture + service context | `services/*/specs/SPEC.md` |
| `/project:4-contract` | Generate contracts | All specs | `contracts/` files + matrix |
| `/project:5-build <service>` | Build a service | Spec + contracts + standards | Code at `local_path` + BUILD-REPORT.md |
| `/project:6-validate` | Cross-service validation | Build reports + contracts | `phases/6-validate.md` |
| `/project:7-review` | Code quality review | Built code | `phases/7-review.md` |

### Utility Commands

| Command | Purpose |
|---------|---------|
| `/project:status` | Show phase progress and service states |
| `/project:add-service <name> <type>` | Scaffold a new service folder |
| `/project:rebuild-service <name>` | Incrementally rebuild after changes |

### Manifest Fields (per service)

| Field | Required | Description |
|-------|----------|-------------|
| `name` | Yes | Unique kebab-case identifier |
| `type` | Yes | `ui`, `bff`, `domain`, `shared-lib`, `infrastructure` |
| `status` | Yes | `new`, `existing`, `enrich`, `skip` |
| `description` | Yes | What this service does |
| `owner` | Recommended | Team or person responsible |
| `repo` | If existing | Git URL for clone/push |
| `local_path` | Set at build time | Where code lives on disk (saved in manifest.local.yaml) |
| `port` | Yes (null for shared-lib) | Service port number |
| `database` | Yes | Database name or `null` |
| `depends_on` | Yes | List of services this one calls |
| `owns_events` | Yes | List of events this service publishes |
| `notes` | Optional | Anything extra the agent should know |
