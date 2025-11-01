# Smithy4s Integration Tests

Comprehensive integration tests for the Smithy4s module using **Weaver** test framework and **Testcontainers** for Elasticsearch.

## Overview

These tests demonstrate how to use Smithy4s-generated types to interact with Elasticsearch via HTTP. They mirror the functionality of legacy elastic4s tests while showcasing the benefits of Smithy4s code generation.

## Test Framework: Weaver

All tests use [Weaver](https://disneystreaming.github.io/weaver-test/), a functional test framework that integrates seamlessly with Cats Effect and provides:
- Resource-safe test lifecycle management
- Shared resources across tests
- Better composition with IO-based code
- Built-in support for Cats Effect

## Test Infrastructure

### Smithy4sTestSuite

Base trait that all integration tests extend. Provides:
- **Automatic Elasticsearch container management**: Starts an Elasticsearch 8.11.0 Docker container before tests, stops it after
- **Shared HTTP client**: Creates an ember-client using http4s for making requests
- **Resource safety**: Uses Cats Effect Resource for proper cleanup

### Test Structure

Each test suite:
1. Extends `Smithy4sTestSuite`
2. Receives `(ElasticsearchContainer, Client[IO])` as shared resources
3. Uses `test("description") { case (container, client) => ... }` for individual tests
4. Returns `IO[Expectations]` from each test

## Running Tests

### Run all tests
```bash
sbt smithy4s/test
```

### Run a specific test suite
```bash
sbt "smithy4s/testOnly se.thanh.elastic4s.integration.DocumentOperationsIntegrationTest"
```

### Run with verbose output
```bash
sbt "smithy4s/testOnly * -- --verbose"
```

## Test Suites

### DocumentOperationsIntegrationTest
Tests document CRUD operations:
- Index documents with various options
- Get documents by ID
- Update documents with partial updates
- Delete documents
- Count documents with filters

**Mirrors**: `UpdateTest`, `GetTest` from legacy tests

### SearchIntegrationTest
Tests search functionality:
- Match queries
- Aggregations (avg, terms)
- Sorting and pagination

**Mirrors**: Search-related legacy tests

### BulkOperationsIntegrationTest
Tests bulk indexing and operations:
- Bulk index multiple documents
- Mixed operations (index, update, delete) in single bulk request
- NDJSON format handling

**Mirrors**: `BulkTest` from legacy tests

### IndexManagementIntegrationTest
Tests index lifecycle management:
- Create index with settings and mappings
- Delete index
- Open/Close index
- Refresh index
- Get index statistics

**Mirrors**: Index management legacy tests

### ClusterOperationsIntegrationTest
Tests cluster-level operations:
- Get cluster health (green/yellow/red status)
- Get cluster statistics (nodes, indices, etc.)

**Mirrors**: `ClusterStatsTest`, `ClusterStateTest`

### AliasOperationsIntegrationTest
Tests alias management:
- Add/Remove aliases via _aliases API
- Get aliases for an index

**Mirrors**: `AliasesHttpTest`

### Smithy4sTypesTest
Demonstrates usage of Smithy4s generated types:
- Enum value validation (RefreshPolicy, HealthStatus)
- Request construction with all field types
- Reusable structures (Script, FetchSourceContext)
- Union types (BulkOperation)

**Purpose**: Documentation and type usage examples

## Benefits of This Approach

### 1. **Full Isolation**
Each test suite gets its own fresh Elasticsearch instance, preventing test interference.

### 2. **Reproducibility**
Tests run consistently across all environments. No external Elasticsearch instance needed.

### 3. **CI/CD Ready**
Fully self-contained. Runs anywhere Docker is available with zero configuration.

### 4. **Type Safety**
Demonstrates end-to-end type safety:
- Compile-time validation of request structures
- Type-safe enum values
- Schema-validated JSON serialization

### 5. **Resource Safety**
Weaver's Resource management ensures:
- Containers always stop, even on test failure
- No resource leaks
- Proper cleanup of HTTP clients

### 6. **Functional Composition**
Tests are pure IO values that compose naturally with other IO-based code.

## Testcontainers Benefits

- **No manual setup**: Containers start automatically
- **Isolated environments**: Each suite gets fresh instance
- **Version control**: Pin exact Elasticsearch version (8.11.0)
- **Cross-platform**: Works on Linux, macOS, Windows (with Docker)
- **CI-friendly**: Runs in GitHub Actions, GitLab CI, etc.

## Comparison with Legacy Tests

| Aspect | Legacy elastic4s Tests | Smithy4s Tests |
|--------|----------------------|----------------|
| Test Framework | ScalaTest | Weaver |
| Effect Type | Future/Execution Context | IO (Cats Effect) |
| Elasticsearch | External instance | Testcontainers |
| Type Safety | Request DSL | Smithy4s generated types |
| HTTP Client | Internal handler | http4s ember-client |
| Resource Management | Manual | Cats Effect Resource |
| Isolation | Shared instance | Per-suite container |
| CI Setup | Requires ES installation | Zero setup (Docker only) |

## Troubleshooting

### Docker not found
Ensure Docker is running and accessible:
```bash
docker ps
```

### Container startup timeout
Increase Testcontainers startup timeout in test config if needed.

### Port conflicts
Testcontainers automatically assigns free ports, so conflicts are rare.

### Memory issues
Elasticsearch requires ~2GB RAM. Ensure Docker has sufficient memory allocated.

## Dependencies

```scala
"com.disneystreaming" %% "weaver-cats" % "0.8.4" % Test
"com.dimafeng" %% "testcontainers-scala-core" % "0.41.0" % Test
"com.dimafeng" %% "testcontainers-scala-elasticsearch" % "0.41.0" % Test
"org.http4s" %% "http4s-ember-client" % "0.23.33" % Test
```

## Future Enhancements

Potential additions:
- Snapshot/Restore operation tests
- Reindex operation tests
- Ingest pipeline tests
- Script management tests
- Task API tests
- More complex aggregation scenarios
- Scroll API testing
- Integration with smithy4s-http4s for service-based testing
