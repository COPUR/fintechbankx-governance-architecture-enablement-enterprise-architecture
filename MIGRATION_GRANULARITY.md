# Migration Granularity Notes

- Repository: `fintechbankx-enterprise-architecture`
- Source monorepo: `enterprise-loan-management-system`
- Sync date: `2026-03-15`
- Sync branch: `chore/granular-source-sync-20260313`

## Applied Rules

- allowlist:
  - `docs/enterprisearchitecture/implementation-development` -> `docs/enterprisearchitecture/implementation-development`
  - `docs/enterprisearchitecture/project-management` -> `docs/enterprisearchitecture/project-management`
  - `docs/enterprisearchitecture/technology-radar` -> `docs/enterprisearchitecture/technology-radar`
  - `docs/architecture/overview` -> `docs/architecture/overview`
  - `docs/puml/service-mesh` -> `docs/puml/service-mesh`
  - `docs/puml/system-overview` -> `docs/puml/system-overview`
  - `docs/puml/security` -> `docs/puml/security`
  - `docs/diagrams` -> `docs/diagrams`
  - `docs/security-architecture` -> `docs/security-architecture`
  - `readme.md` -> `README_SOURCE_MONOREPO.md`

## Notes

- This is an extraction seed for bounded-context split migration.
- Follow-up refactoring may be needed to remove residual cross-context coupling.
- Build artifacts and local machine files are excluded by policy.

