# Agent Architect

A template repository for building multi-microservice systems using AI coding tools as your development team.

**No custom tooling. No learning curve. Just folders, markdown, and your AI coding tool.**

**Works with:** Claude Code | GitHub Copilot (agent mode) | Any AI tool that reads markdown

> **New here?** Read **[HOW-TO-USE.md](HOW-TO-USE.md)** for the complete step-by-step guide.

## How It Works

```
┌─────────────────────────────────────────────────────────────────┐
│  Phase 0: /project:0-setup        → Interactive project setup    │
│           Agent interviews you, populates manifest + standards   │
│           + PROJECT.md + service folders. No blank forms.        │
├─────────────────────────────────────────────────────────────────┤
│  Phase 1: /project:1-discover     → Gap analysis & questions    │
│  Phase 2: /project:2-architect    → System design & ADRs        │
│  Phase 3: /project:3-specify      → Specs + test plans / service│
│  Phase 4: /project:4-contract     → API contracts + integration │
│                                      test plan                   │
│               ⚠️  HUMAN REVIEW GATE ⚠️                          │
│                                                                  │
│  Phase 5: /project:5-build        → Build with test traceability│
│  Phase 6: /project:6-validate     → Cross-service validation    │
│  Phase 7: /project:7-review       → Security, quality & test    │
│                                      completeness review         │
├─────────────────────────────────────────────────────────────────┤
│  TEAM MODE (optional):                                           │
│  /project:team-start              → Spawn 5-agent team that      │
│                                      auto-orchestrates Phases 1-7│
└─────────────────────────────────────────────────────────────────┘
```

## Quick Start

### 1. Create your project from this template

```bash
# Option A: Use GitHub template (recommended)
gh repo create my-project-plan --template nakurian/agent-architect --private
cd my-project-plan

# Option B: Clone and disconnect
git clone https://github.com/nakurian/agent-architect.git my-project-plan
cd my-project-plan
rm -rf .git && git init
git add -A && git commit -m "feat: init from agent-architect template"
```

### 2. Run the interactive setup

```bash
# Open Claude Code in this directory
claude

# Run Phase 0 — the agent interviews you and populates everything
/project:0-setup
```

The setup agent will ask about:
- Project name, description, business domain
- Tech stack (language, framework, database, testing)
- Company coding standards and conventions
- Business context (what you're building, for whom, core workflows)
- Services (name, type, existing repo, dependencies)
- Quality gates (review requirements, coverage thresholds)

Every answer is **saved immediately** to the right file. If interrupted, re-run and it picks up where you left off.

### 3. Add reference materials (optional)

```bash
# Drop in any existing documentation
cp ~/Downloads/requirements.pdf context/references/requirements/
cp ~/Downloads/api-spec.yaml context/references/existing-apis/
cp ~/Downloads/wireframes.png context/references/designs/
```

### 4. Run the phases

```bash
/project:1-discover        # Agent analyzes everything, asks clarifying questions
# → Answer questions in phases/1-discover.md

/project:2-architect       # Agent designs the system + test strategy ADR
# → Review architecture in phases/2-architect.md

/project:3-specify         # Agent writes specs + test plans for each service
# → Review specs in services/*/specs/SPEC.md
# → Review test plans in services/*/specs/TEST-PLAN.md

/project:4-contract        # Agent generates API contracts + integration test plan
# → Review contracts in contracts/
# → Review cross-service tests in contracts/INTEGRATION-TEST-PLAN.md

# ⚠️ Review and approve specs, test plans, and contracts before building ⚠️

/project:5-build order-service    # Build one service at a time
# → Agent asks where to put the code (first time only)
# → Tests map to TEST-PLAN.md cases with traceability comments

/project:6-validate        # Verify services work together
/project:7-review          # Security, quality, and test completeness review
```

### 5. Check status anytime

```bash
/project:status            # See phase progress and service states
/project:team-status       # Enhanced: includes agent assignments & test coverage
```

## Directory Structure

```
.
├── manifest.yaml              # ★ Single source of truth (services, stack, quality gates)
├── manifest.local.yaml        # 🔒 Machine-specific paths (gitignored, per developer)
├── CLAUDE.md                  # Agent instructions
├── README.md                  # This file
│
├── context/                   # 📥 Human-maintained inputs
│   ├── PROJECT.md             #    Business overview
│   ├── references/            #    Supporting documents
│   │   ├── confluence/        #    Confluence exports
│   │   ├── requirements/      #    PRDs, user stories
│   │   ├── designs/           #    Mockups, wireframes
│   │   ├── existing-apis/     #    OpenAPI specs, Postman
│   │   └── data-models/       #    ERDs, schemas
│   └── decisions/             #    Architecture Decision Records
│
├── services/                  # 📦 Per-service context & specs
│   ├── .template/             #    Template for new services
│   ├── web-ui/
│   │   ├── CONTEXT.md         #    Human-written service context
│   │   ├── references/        #    Service-specific references
│   │   └── specs/
│   │       ├── SPEC.md        #    🤖 Generated by spec agent (Phase 3)
│   │       ├── TEST-PLAN.md   #    🤖 Test cases with traceability (Phase 3)
│   │       ├── BUILD-REPORT.md#    🤖 Build results (Phase 5)
│   │       └── TEST-REPORT.md #    🤖 Test execution results (Phase 5)
│   ├── bff-gateway/
│   └── order-service/
│
├── contracts/                 # 🤝 Cross-service interfaces
│   ├── api/                   #    🤖 OpenAPI specs (service-to-service)
│   ├── events/                #    🤖 Event JSON schemas
│   ├── shared-models/         #    🤖 Shared data types
│   ├── CONTRACT-MATRIX.md     #    🤖 Interface overview
│   └── INTEGRATION-TEST-PLAN.md#   🤖 Cross-service test scenarios (Phase 4)
│
├── standards/                 # 📏 Coding, API & testing standards
│   ├── coding-standards.md    #    Code style, structure, testing
│   ├── api-design.md          #    REST conventions, error formats
│   └── testing-standards.md   #    Test pyramid, edge cases, test plan template
│
├── phases/                    # 📊 Phase completion tracking
│   ├── 1-discover.md         #    🤖 Gap analysis & questions
│   ├── 2-architect.md          #    🤖 System design
│   ├── 3-specify.md            #    🤖 Spec completion report
│   ├── 4-contract.md           #    🤖 Contract validation
│   ├── 6-validate.md           #    🤖 Integration test results
│   └── 7-review.md            #    🤖 Code review report
│
├── .claude/
│   └── commands/              # 🤖 Claude Code slash commands
│       ├── 0-setup.md         #    Interactive project setup (run first!)
│       ├── 1-discover.md ... 7-review.md
│       ├── add-service.md
│       ├── rebuild-service.md
│       ├── status.md
│       ├── team-start.md      #    Spawn 5-agent team (Phases 1-7)
│       ├── team-migrate.md    #    Upgrade v1 repos to team-capable
│       └── team-status.md     #    Enhanced status with agents & tests
│
├── .github/
│   ├── copilot-instructions.md  # 🤖 Copilot instructions (synced from CLAUDE.md)
│   └── prompts/                 # 🤖 Copilot prompt files (synced from .claude/commands/)
│       ├── 0-setup.prompt.md ... 7-review.prompt.md
│       └── ...
│
└── scripts/
    └── sync-prompts.sh        # Sync Claude commands → Copilot prompts
```

## Folder Layout (Planning Repo vs Code Repos)

This is a **planning-only** repo. Service code lives in separate repos/paths.
Each service in `manifest.yaml` has a `local_path` and optional `repo` field:

```
# Each service can live wherever makes sense for your team:

/Users/you/projects/
├── my-project-plan/           # THIS REPO — planning only
│   ├── manifest.yaml          #   local_path per service points to code
│   ├── context/
│   ├── services/              #   Context & specs (not code!)
│   └── ...
│
├── web-ui/                    # local_path: "../web-ui"
├── bff-gateway/               # local_path: "../bff-gateway"
└── order-service/             # local_path: "../order-service"

# Or services can be anywhere:
# local_path: "/Users/you/repos/payment-service"     ← cloned from existing repo
# local_path: "../monorepo/packages/auth-service"     ← inside a monorepo
# local_path: ""                                      ← builder will ask at build time
```

The builder agent asks for the path at build time if `local_path` is empty, then saves it to `manifest.local.yaml` (gitignored) so each developer has their own paths without polluting the shared repo.

## Key Concepts

### manifest.yaml drives everything
Every agent reads the manifest first. Change the tech stack → agents generate different code. Change build_targets → agents focus on different services. Change a service status to `skip` → agents ignore it.

### Specs + test plans are the quality gate
The most important outputs are `services/*/specs/SPEC.md` and `TEST-PLAN.md`. A good spec produces good code. A good test plan catches bugs before they ship. Every test in code traces back to a test case ID (`// Covers: TC-ORD-ACC-001`), which traces back to a SPEC.md section.

### Contracts prevent integration failures
Cross-service API contracts in `contracts/` are shared truth. Both provider and consumer reference the same file. `INTEGRATION-TEST-PLAN.md` defines cross-service test scenarios, failure cascades, and eventual consistency verification. Contract tests catch mismatches before runtime.

### Phases are checkpoints, not walls
You can re-run any phase. Updated the requirements? Re-run discover + architect + specify. Found a bug in the spec? Fix it, then rebuild-service. The framework is iterative.

## Advanced Usage

### Building services in parallel (manual)
```bash
# First, ensure local_path is set for each service in manifest.yaml
# (the builder will ask on first run, then saves it)

# Then run multiple Claude Code sessions (one per service)
# Terminal 1:
claude -p "/project:5-build order-service"
# Terminal 2:
claude -p "/project:5-build payment-service"
```

### Using Agent Teams (recommended for 3+ services)

Agent Teams spawn 5 specialized AI agents that orchestrate all phases automatically, with parallel builds and role-based reviews. Requires tmux for split-pane visibility.

```bash
# 1. Enable agent teams (one-time setup)
# In ~/.claude/settings.json:
#   "env": { "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1" }

# 2. Run Phase 0 solo (interactive)
/project:0-setup

# 3. Start the team — agents take over from here
/project:team-start
```

The team spawns:
| Agent | Model | Role |
|-------|-------|------|
| Team Lead / PO | opus | Orchestrates, enforces quality gates, human liaison |
| Sr. Architect | opus | Discovery, architecture, contracts, cross-service review |
| Sr. Lead Engineer | opus | Specs, test plans, builds services |
| Sr. QA & Security | sonnet | Test augmentation, validation, security review |
| Sr. DevOps | sonnet | Dockerfiles, CI/CD, docker-compose |

Agents challenge each other's work (architect vs engineer on feasibility, QA vs engineer on testability). The human only intervenes at quality gates (spec approval, contract approval, production readiness).

**For existing repos using the old sequential approach:**
```bash
/project:team-migrate      # Detects progress, upgrades to v2.0
/project:team-start        # Resumes from next incomplete phase
```

### Using with GSD Framework
This template is compatible with GSD. Use this template for the planning/spec phases, then hand off individual service specs to GSD for the build phase.

### Using with GitHub Copilot

The framework works with Copilot out of the box:

```bash
# Copilot reads .github/copilot-instructions.md (auto-generated from CLAUDE.md)
# Copilot prompt files live in .github/prompts/*.prompt.md (synced from .claude/commands/)

# In VS Code Copilot Chat (agent mode), type / to see available prompts:
# /0-setup, /1-discover, /2-architect, /3-specify, etc.

# After editing any .claude/commands/*.md, sync to Copilot:
./scripts/sync-prompts.sh
```

| Feature | Claude Code | Copilot |
|---------|------------|---------|
| Instructions | `CLAUDE.md` | `.github/copilot-instructions.md` |
| Phase commands | `/project:0-setup` | `/0-setup` (prompt file) |
| Agent mode | Built-in | VS Code agent mode |
| Autonomous | `claude -p` headless | Copilot Coding Agent (GitHub Issues) |

### Enriching existing services
1. Set service status to `enrich` in manifest
2. Put the existing API spec in `services/<name>/references/`
3. Describe what needs to change in `services/<name>/CONTEXT.md`
4. Run phases 3-7 — specs will focus only on changes

## FAQ

**Q: Where does the actual code live?**
A: Each service has a `local_path` in `manifest.yaml` pointing to its code directory. This can be anywhere — a sibling folder, an existing repo, a monorepo path. The builder agent asks for the path on first build and saves it. This planning repo only holds context, specs, and contracts — never code.

**Q: What's the difference between sequential mode and team mode?**
A: Sequential mode runs phases one at a time with a single AI session. Team mode spawns 5 specialized agents (architect, engineer, QA, devops + team lead) that orchestrate automatically, build in parallel, and review each other's work. Use sequential for small projects (1-2 services), teams for larger ones (3+ services).

**Q: Can I skip phases?**
A: Phases 1-4 build on each other. You can skip 6-7 but they catch real issues. Phase 5 requires phase 3 (specs); phase 4 (contracts) is recommended if the service has cross-service dependencies but can be skipped for standalone services.

**Q: How do I handle changing requirements?**
A: Update `context/PROJECT.md` or the service's `CONTEXT.md`, then re-run from the phase that's affected. Specs are regenerated, builders can rebuild.

**Q: What if I have 10+ services?**
A: Use `build_targets` to focus on 2-3 at a time. The framework handles any number of services but building is most effective in small batches.

**Q: Does this replace project management tools?**
A: No. This handles the technical planning and implementation. Your Jira/Linear still tracks tickets, timelines, and team assignments.

**Q: Can multiple developers work on this simultaneously?**
A: Yes. The planning repo is shared (manifest.yaml, specs, contracts). Machine-specific paths live in `manifest.local.yaml` (gitignored). Each developer creates their own `manifest.local.yaml` from `manifest.local.yaml.example`. Build phases run independently per service.

**Q: How does the approval process work?**
A: Quality gates in `manifest.yaml` define what needs approval. When the builder agent starts, it checks `approvals` in the manifest. If a required approval is missing, it asks who reviewed and records it. This creates an audit trail.
