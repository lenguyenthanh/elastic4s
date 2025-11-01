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

There are two types of test suites in this module:

1. **ElasticServiceIntegrationTest**: Tests using the generated ElasticService trait with smithy4s-http4s
2. **Operation-specific tests**: Tests using manual HTTP requests with generated data types

### ElasticServiceIntegrationTest (NEW)
**Recommended approach** - Tests the generated ElasticService using smithy4s-http4s integration:
- Index and Get documents through generated service
- Search operations with the service interface
- Update and Delete operations
- Bulk operations using the service
- Index management (create, delete, open, close, refresh)
- Cluster operations (health, stats)
- Count operations

This suite demonstrates the **proper way** to use smithy4s-generated services with http4s client, providing:
- Type-safe HTTP calls through the ElasticService trait
- Automatic request/response serialization
- Proper HTTP routing via smithy4s bindings
- End-to-end integration validation

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

### ElasticServiceIntegrationTest
Tests the **generated ElasticService** using smithy4s-http4s client integration:
- Creates a smithy4s HTTP client for the ElasticService trait
- Tests all operations through the generated service interface
- Demonstrates proper http4s and smithy4s integration
- End-to-end testing of the unified service

**Key Features**:
- Uses `SimpleRestJsonBuilder` to create ElasticService client
- All operations go through the generated service trait
- Type-safe HTTP bindings with proper routing
- Validates complete smithy4s workflow

**Mirrors**: All handler operations, but using generated service interface

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

## Smithy4s-Http4s Integration

The **ElasticServiceIntegrationTest** demonstrates the recommended pattern for using smithy4s-generated services:

```scala
// Create smithy4s client for ElasticService
def createElasticServiceClient(httpClient: Client[IO], baseUri: String): IO[ElasticService[IO]] = {
  val uri = Uri.unsafeFromString(baseUri)
  
  SimpleRestJsonBuilder(ElasticService)
    .client(httpClient)
    .uri(uri)
    .resource
    .use(client => IO.pure(client))
}

// Use the generated service
for {
  elasticService <- createElasticServiceClient(httpClient, esUrl)
  
  // All operations are type-safe and use HTTP bindings from Smithy
  indexResponse <- elasticService.indexDocument(IndexDocumentInput(...))
  getResponse <- elasticService.getDocument(GetDocumentInput(...))
  searchResponse <- elasticService.search(SearchInput(...))
} yield results
```

### Benefits of Service-Based Approach

1. **Type Safety**: All HTTP paths, methods, and parameters are validated at compile time
2. **HTTP Bindings**: `@http`, `@httpLabel`, `@httpQuery` traits ensure correct routing
3. **Automatic Serialization**: JSON encoding/decoding handled by smithy4s
4. **Single Interface**: All 42 operations accessible from one ElasticService trait
5. **Testable**: Easy to mock or stub the service interface for unit tests

## Future Enhancements

Potential additions:
- More ElasticService tests for remaining operations (Snapshot, Reindex, Ingest, Script, Task)
- Mock service implementation for unit tests
- Error handling scenarios
- More complex aggregation scenarios
- Performance benchmarks comparing approaches
