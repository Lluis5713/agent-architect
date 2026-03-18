# Coding Standards

<!--
INSTRUCTIONS: Customize these to match your team's standards.
Agents will follow these rules when generating code in the build phase.
Delete sections that don't apply to your tech stack.
-->

## General Principles

- Write clean, readable code over clever code
- Follow SOLID principles
- Prefer composition over inheritance
- Keep functions small and single-purpose (max ~30 lines)
- Use meaningful names — code should read like prose

## Project Structure (per microservice)

```
src/
├── main.ts                    # Entry point
├── app.module.ts              # Root module
├── config/                    # Environment config, validation
├── modules/
│   └── <domain>/
│       ├── <domain>.module.ts
│       ├── <domain>.controller.ts
│       ├── <domain>.service.ts
│       ├── <domain>.repository.ts
│       ├── dto/               # Request/response DTOs
│       ├── entities/          # Database entities
│       ├── events/            # Event publishers/handlers
│       └── __tests__/         # Co-located tests
├── common/
│   ├── filters/               # Exception filters
│   ├── guards/                # Auth guards
│   ├── interceptors/          # Logging, transform
│   ├── pipes/                 # Validation pipes
│   └── decorators/            # Custom decorators
├── health/                    # Health check endpoint
└── database/
    └── migrations/            # Database migrations
```

## API Design

- Use RESTful conventions: nouns for resources, HTTP verbs for actions
- Version APIs: `/api/v1/resources`
- Use consistent response envelope:
  ```json
  {
    "data": {},
    "meta": { "timestamp": "", "requestId": "" },
    "errors": []
  }
  ```
- Use HTTP status codes correctly (201 for created, 204 for no content, etc.)
- Paginate list endpoints: `?page=1&limit=20`
- Always validate request bodies with DTOs

## Error Handling

- Use domain-specific error classes extending a base `AppError`
- Never expose stack traces or internal details in API responses
- Log the full error internally, return a safe message externally
- Use correlation IDs for request tracing across services

## Testing

- Minimum 80% code coverage
- Unit tests: test business logic in services, pure functions
- Integration tests: test API endpoints with real database (use test containers)
- Name tests descriptively: `should return 404 when order does not exist`
- Use factories/fixtures for test data, not inline object literals

## Database

- Use migrations for ALL schema changes — never manual DDL
- Use transactions for multi-step writes
- Index foreign keys and frequently queried columns
- Use soft deletes where business requires audit trail

## Security

- Validate and sanitize all inputs at the boundary
- Use parameterized queries (never string concatenation for SQL)
- Implement rate limiting on public endpoints
- Use JWT with short expiry + refresh tokens for auth
- Never log sensitive data (tokens, passwords, PII)

## Observability

- Structured JSON logging (not console.log)
- Include correlationId, service name, and timestamp in every log
- Log at appropriate levels: ERROR for failures, WARN for degraded, INFO for business events, DEBUG for troubleshooting
- Expose `/health` and `/ready` endpoints
- Emit metrics for: request count, latency, error rate, queue depth

## Git & PR Conventions

- Branch naming: `feature/<ticket>-short-description`, `fix/<ticket>-short-description`
- Commit messages: conventional commits (`feat:`, `fix:`, `chore:`, `docs:`)
- PRs must include: description, test plan, and link to spec
