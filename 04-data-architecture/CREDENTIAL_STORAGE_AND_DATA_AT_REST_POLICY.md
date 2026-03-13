# Credential Storage and Data-at-Rest Policy

## Mandatory Controls

1. Real credentials and API secrets must never be stored in:
   - source code,
   - local `.env`/`.env.local` files,
   - OpenAPI examples or test fixtures.
2. Runtime credential provisioning must use internal control-plane API:
   - `POST /internal/v1/system/secrets`
3. Credential metadata APIs must never return plaintext values.
4. Persist only protected representations:
   - masked display value,
   - salted cryptographic hash,
   - versioned metadata.

## Runtime API Contract

- `POST /internal/v1/system/secrets`
  - Stores/rotates credential material through authenticated internal channel.
  - Response includes masked value and metadata only.
- `GET /internal/v1/system/secrets/{secretKey}`
  - Returns metadata only.
  - Plaintext credential is not retrievable.

## Data-at-Rest Principles

1. Enable encryption at rest for database volumes and backups/snapshots.
2. Apply least-privilege DB access for credential tables.
3. Keep immutable audit trail for credential mutation events (actor, key, version, timestamp).
4. Enforce periodic rotation and version increments.
5. Do not log plaintext credentials in application logs.

## Implementation Note

The consent authorization service implements this policy through database-backed
credential storage using masked + hash/salt fields and runtime API provisioning.
