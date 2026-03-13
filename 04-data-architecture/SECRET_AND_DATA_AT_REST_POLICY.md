# Secret and Data-at-Rest Policy

## Mandatory Rules

1. Real secrets must never be stored in:
   - repository source files,
   - `.env`, `.env.local`, or similar local environment files,
   - CI pipeline plain-text variables.
2. Secret provisioning must occur at runtime through internal control-plane API:
   - `POST /internal/v1/system/secrets`
3. Secret read APIs must never return plaintext secret values.
4. Secret persistence must store masked/derived values only (masked display + cryptographic hash/salt).

## Runtime Secret API

- Endpoint: `POST /internal/v1/system/secrets`
- Purpose: create/rotate secret metadata under strict internal authentication.
- Response contract: `maskedValue`, `version`, classification, timestamps.
- Plaintext secret input is write-only and is not returned.

## Data-at-Rest Controls

1. Database encryption at rest enabled (storage and snapshots/backups).
2. Field-level protection for sensitive values:
   - no plaintext persistence for runtime secrets,
   - hashed/salted representation for verification and audit.
3. Access control:
   - least-privilege database roles,
   - service account isolation per bounded context.
4. Auditability:
   - every secret mutation captures actor, timestamp, key identifier, and version.
5. Rotation:
   - secret updates increment version and preserve immutable creation metadata.

## Development and Testing Guidance

- Local development must use placeholders such as `RUNTIME_MANAGED`.
- Integration tests may use deterministic test-only values and in-memory adapters.
- Production profiles must enforce database-backed secret storage and encryption-at-rest.
