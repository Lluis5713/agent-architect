# API Design Standards

## REST Conventions

| Action | Method | Path | Response Code |
|--------|--------|------|---------------|
| List | GET | `/api/v1/{resources}` | 200 |
| Get | GET | `/api/v1/{resources}/{id}` | 200 |
| Create | POST | `/api/v1/{resources}` | 201 |
| Update | PUT | `/api/v1/{resources}/{id}` | 200 |
| Partial Update | PATCH | `/api/v1/{resources}/{id}` | 200 |
| Delete | DELETE | `/api/v1/{resources}/{id}` | 204 |

## Request/Response Format

### Success Response
```json
{
  "data": { ... },
  "meta": {
    "requestId": "uuid",
    "timestamp": "ISO8601"
  }
}
```

### List Response
```json
{
  "data": [ ... ],
  "meta": {
    "requestId": "uuid",
    "timestamp": "ISO8601",
    "pagination": {
      "page": 1,
      "limit": 20,
      "total": 100,
      "totalPages": 5
    }
  }
}
```

### Error Response
```json
{
  "errors": [
    {
      "code": "ORDER_NOT_FOUND",
      "message": "Order with ID 123 not found",
      "field": null
    }
  ],
  "meta": {
    "requestId": "uuid",
    "timestamp": "ISO8601"
  }
}
```

## Naming Conventions

- URLs: kebab-case (`/order-items`, not `/orderItems`)
- Query params: camelCase (`?sortBy=createdAt`)
- JSON fields: camelCase
- Event names: dot-notation lowercase (`order.created`)

## Versioning

- URL path versioning: `/api/v1/...`
- Breaking changes require a new version
- Support previous version for minimum 6 months after deprecation notice

## Authentication

- Bearer token in `Authorization` header
- Service-to-service: mutual TLS or API keys in `X-Api-Key` header
- All endpoints authenticated by default; explicitly mark public endpoints

## Rate Limiting

- Return `429 Too Many Requests` with `Retry-After` header
- Default limits per tier:
  - Public: 100 req/min
  - Authenticated: 1000 req/min
  - Service-to-service: 10000 req/min

## Cross-Service Communication

- Synchronous: HTTP REST (for queries and commands needing immediate response)
- Asynchronous: Message broker events (for eventual consistency, notifications)
- Always include `X-Correlation-Id` header for distributed tracing
- Use circuit breaker pattern for synchronous calls
- Use retry with exponential backoff for transient failures
