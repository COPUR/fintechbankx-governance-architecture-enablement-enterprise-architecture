# Full Regression Test Report

- Timestamp (UTC): `2026-02-22 13:07:12`
- Scope: Root monorepo, `amanahfi-platform`, and all standalone `services/*` Gradle modules
- Command pattern: `clean check` (or equivalent per module wrapper/project path)

## Module Results

| Module | Result | Duration (s) | Tests (run/fail/skip) | Line Coverage | Log |
|---|---:|---:|---:|---:|---|
| `root-monorepo` | `FAIL(1)` | 48 | n/a | n/a | `/tmp/enterprise-test-orchestration/root-monorepo.log` |
| `amanahfi-platform` | `FAIL(1)` | 0 | n/a | n/a | `/tmp/enterprise-test-orchestration/amanahfi-platform.log` |
| `openfinance-atm-directory-service` | `FAIL(1)` | 11 | 1/0/0 | 33.33% | `/tmp/enterprise-test-orchestration/openfinance-atm-directory-service.log` |
| `openfinance-banking-metadata-service` | `PASS` | 21 | 77/0/0 | 89.12% | `/tmp/enterprise-test-orchestration/openfinance-banking-metadata-service.log` |
| `openfinance-business-financial-data-service` | `PASS` | 20 | 76/0/0 | 89.05% | `/tmp/enterprise-test-orchestration/openfinance-business-financial-data-service.log` |
| `openfinance-confirmation-of-payee-service` | `FAIL(1)` | 10 | 1/0/0 | 33.33% | `/tmp/enterprise-test-orchestration/openfinance-confirmation-of-payee-service.log` |
| `openfinance-consent-authorization-service` | `PASS` | 15 | 77/0/0 | 89.36% | `/tmp/enterprise-test-orchestration/openfinance-consent-authorization-service.log` |
| `openfinance-open-products-service` | `FAIL(1)` | 10 | 1/0/0 | 33.33% | `/tmp/enterprise-test-orchestration/openfinance-open-products-service.log` |
| `openfinance-personal-financial-data-service` | `PASS` | 20 | 93/0/0 | 93.01% | `/tmp/enterprise-test-orchestration/openfinance-personal-financial-data-service.log` |

## Summary

- Total modules tested: `9`
- Passed: `4`
- Failed: `5`

## Failure Diagnostics

### `root-monorepo` (`FAIL(1)`)

```text
* What went wrong:\nExecution failed for task ':open-finance-context:open-finance-infrastructure:spotbugsFunctionalTest'.\n> A failure occurred while executing com.github.spotbugs.snom.internal.SpotBugsRunnerForHybrid$SpotBugsExecutor\n   > Verification failed: SpotBugs ended with exit code 1.\n

* What went wrong:\nExecution failed for task ':open-finance-context:open-finance-infrastructure:spotbugsMain'.\n> A failure occurred while executing com.github.spotbugs.snom.internal.SpotBugsRunnerForHybrid$SpotBugsExecutor\n   > Verification failed: SpotBugs ended with exit code 1.\n
```

### `amanahfi-platform` (`FAIL(1)`)

```text
Error: Could not find or load main class org.gradle.wrapper.GradleWrapperMain\nCaused by: java.lang.ClassNotFoundException: org.gradle.wrapper.GradleWrapperMain
```

### `openfinance-atm-directory-service` (`FAIL(1)`)

```text
* What went wrong:\nExecution failed for task ':jacocoTestCoverageVerification'.\n> A failure occurred while executing org.gradle.internal.jacoco.JacocoCoverageAction\n   > Rule violated for bundle openfinance-microservice: lines covered ratio is 0.33, but expected minimum is 0.85\n
```

### `openfinance-confirmation-of-payee-service` (`FAIL(1)`)

```text
* What went wrong:\nExecution failed for task ':jacocoTestCoverageVerification'.\n> A failure occurred while executing org.gradle.internal.jacoco.JacocoCoverageAction\n   > Rule violated for bundle openfinance-microservice: lines covered ratio is 0.33, but expected minimum is 0.85\n
```

### `openfinance-open-products-service` (`FAIL(1)`)

```text
* What went wrong:\nExecution failed for task ':jacocoTestCoverageVerification'.\n> A failure occurred while executing org.gradle.internal.jacoco.JacocoCoverageAction\n   > Rule violated for bundle openfinance-microservice: lines covered ratio is 0.33, but expected minimum is 0.85\n
```

## Artifacts

- Matrix results TSV: `/tmp/enterprise-test-orchestration/results.tsv`
- Raw logs: `/tmp/enterprise-test-orchestration/*.log`
- This report: `/Users/alicopur/Documents/GitHub/enterprise-loan-management-system/docs/enterprisearchitecture/implementation-development/test-reports/FULL_REGRESSION_REPORT_20260222_130712Z.md`