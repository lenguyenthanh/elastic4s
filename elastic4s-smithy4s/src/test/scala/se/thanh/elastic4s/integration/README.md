# Smithy4s Integration Tests

This directory contains comprehensive integration tests for the elastic4s-smithy4s module using Testcontainers.

## Overview

The integration tests demonstrate how to use the Smithy4s-generated Elasticsearch API types with real Elasticsearch instances running in Docker containers. These tests complement the legacy elastic4s tests and show practical usage patterns of the Smithy4s approach.

## Test Structure

### Base Test Infrastructure

- **Smithy4sTestContainer**: Base trait providing Testcontainers setup with Elasticsearch 8.11.0
  - Automatic container lifecycle management
  - HTTP4s client creation
  - Elasticsearch connection utilities

### Integration Test Suites

1. **DocumentOperationsIntegrationTest**
   - Index documents
   - Get documents by ID
   - Update documents
   - Delete documents
   - Count documents
   - Mirrors: `UpdateTest`, `GetTest` from elastic4s-tests

2. **SearchIntegrationTest**
   - Basic search with match queries
   - Search with aggregations
   - Search with sorting
   - Mirrors: Search-related tests from elastic4s-tests

3. **BulkOperationsIntegrationTest**
   - Bulk index operations
   - Mixed bulk operations (index, update, delete)
   - Mirrors: `BulkTest` from elastic4s-tests

4. **IndexManagementIntegrationTest**
   - Create index with settings and mappings
   - Delete index
   - Open/Close index
   - Refresh index
   - Get index statistics
   - Mirrors: Index management tests from elastic4s-tests

5. **ClusterOperationsIntegrationTest**
   - Get cluster health
   - Get cluster statistics
   - Mirrors: `ClusterStatsTest`, `ClusterStateTest` from elastic4s-tests

6. **AliasOperationsIntegrationTest**
   - Add/Remove aliases
   - Get aliases
   - Mirrors: `AliasesHttpTest` from elastic4s-tests

7. **Smithy4sTypesTest**
   - Demonstrates usage of generated Smithy4s types
   - Shows type construction patterns
   - Validates enum values
   - Tests common structures

## Running the Tests

### Prerequisites

- Docker installed and running
- SBT build tool
- Java 17 or later

### Run All Tests

```bash
sbt "smithy4s/test"
```

### Run Specific Test Suite

```bash
sbt "smithy4s/testOnly se.thanh.elastic4s.integration.DocumentOperationsIntegrationTest"
```

### Run with Specific Elasticsearch Version

Edit `Smithy4sTestContainer.scala` to change the Docker image:

```scala
dockerImageName = DockerImageName.parse("docker.elastic.co/elasticsearch/elasticsearch:8.11.0")
```

## Test Approach

### Legacy Tests vs. Smithy4s Tests

| Aspect | Legacy Tests | Smithy4s Tests |
|--------|--------------|----------------|
| Test Framework | ScalaTest with DockerTests | ScalaTest with Testcontainers |
| Elasticsearch Setup | External/Manual | Testcontainers (Automatic) |
| API Types | Hand-written domain models | Smithy4s generated types |
| HTTP Client | elastic4s JavaClient | http4s with Cats Effect |
| Type Safety | Request-level | End-to-end with schemas |

### Benefits of Testcontainers Approach

1. **Isolation**: Each test suite gets a fresh Elasticsearch instance
2. **Reproducibility**: Consistent environment across all runs
3. **CI/CD Ready**: No external dependencies, runs anywhere Docker is available
4. **Version Flexibility**: Easy to test against different Elasticsearch versions
5. **Cleanup**: Automatic container teardown after tests

### Test Design Patterns

1. **Resource Management**: Uses Cats Effect `Resource` for safe resource handling
2. **HTTP Requests**: Direct HTTP calls to demonstrate low-level Elasticsearch interaction
3. **Type Demonstration**: Shows how to construct and use Smithy4s generated types
4. **Async Execution**: Uses Cats Effect `IO` for non-blocking operations

## Generated Types Used

The tests demonstrate usage of key Smithy4s-generated types:

- **Requests**: `GetRequest`, `IndexRequest`, `UpdateRequest`, `DeleteByIdRequest`, `SearchRequest`, `BulkRequest`, `CreateIndexRequest`
- **Responses**: `GetResponse`, `IndexResponse`, `UpdateResponse`, `DeleteResponse`, `SearchResponse`, `BulkResponse`
- **Enums**: `RefreshPolicy`, `VersionType`, `HealthStatus`, `Operator`, `DistanceUnit`
- **Common Types**: `Document`, `Script`, `Shards`, `DocumentRef`, `FetchSourceContext`

## Coverage

The integration tests cover all major Elasticsearch operations defined in the Smithy specifications:

- ✅ Document Operations (Get, Index, Update, Delete, Count)
- ✅ Search Operations (Search, Aggregations, Sorting)
- ✅ Bulk Operations (Mixed operations)
- ✅ Index Management (Create, Delete, Open, Close, Refresh, Stats)
- ✅ Cluster Operations (Health, Stats)
- ✅ Alias Operations (Add, Remove, Get)

## Future Enhancements

Potential additions to the test suite:

- Snapshot and Restore operations
- Reindex operations
- Script management
- Ingest pipeline operations
- Task management
- Full service client integration (when available)

## Troubleshooting

### Container Startup Issues

If tests fail due to container startup:

```bash
# Check Docker is running
docker ps

# Pull Elasticsearch image manually
docker pull docker.elastic.co/elasticsearch/elasticsearch:8.11.0
```

### Port Conflicts

Testcontainers automatically maps to available ports, so port conflicts are rare. If issues occur, check for:

```bash
# Check for processes using Elasticsearch ports
lsof -i :9200
```

### Memory Issues

Elasticsearch requires sufficient memory. The tests configure ES_JAVA_OPTS to `-Xms512m -Xmx512m`. If tests fail with OOM errors, increase Docker's memory allocation.

## Contributing

When adding new integration tests:

1. Extend `Smithy4sTestContainer` for container management
2. Mirror existing elastic4s test functionality
3. Use Smithy4s generated types to demonstrate the new approach
4. Include clear test descriptions
5. Add appropriate logging for debugging
6. Ensure tests are idempotent and isolated
