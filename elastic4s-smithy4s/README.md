# elastic4s-smithy4s

This module provides an alternative domain model for elastic4s using [Smithy4s](https://disneystreaming.github.io/smithy4s/), a code generator and framework for [Smithy](https://smithy.io/2.0/index.html).

## Overview

The `elastic4s-smithy4s` module is equivalent to the `elastic4s-domain` module but uses Smithy IDL (Interface Definition Language) specifications to define the Elasticsearch domain models. The Scala code is generated from these Smithy specifications at compile time.

## Benefits

- **Protocol-agnostic**: Smithy specifications are language and protocol agnostic
- **Automatic code generation**: Reduces boilerplate and ensures consistency
- **Type safety**: Smithy4s generates type-safe Scala code with proper validation
- **Documentation**: Smithy specifications serve as machine-readable documentation
- **Interoperability**: Smithy models can be used to generate code for other languages
- **HTTP Bindings**: Service definitions include HTTP method, URI, and parameter bindings

## Structure

The module contains Smithy specifications in `src/main/smithy/` that define:

- **Common types**: Enums and structures used across the API (HealthStatus, RefreshPolicy, etc.)
- **Request/Response models**: Data structures for various Elasticsearch operations
  - Document operations: Get (`get.smithy`), Index (`index.smithy`), Update (`update.smithy`), Delete (`delete.smithy`)
  - Bulk operations: Bulk (`bulk.smithy`)
  - Search operations: Search (`search.smithy`), Count (`count.smithy`), Scroll (`scroll.smithy`)
  - Index management: Indices (`indices.smithy`), Alias (`alias.smithy`)
  - Cluster operations: Cluster (`cluster.smithy`)
  - Data operations: Reindex (`reindex.smithy`)
  - Snapshot/Restore: Snapshot (`snapshot.smithy`)
  - Pipeline operations: Ingest (`ingest.smithy`)
  - Script operations: Script (`script.smithy`)
  - Task operations: Task (`task.smithy`)
- **Service definitions**: Unified HTTP-bound service definition in `services/` directory
  - `services/elastic.smithy`: ElasticService - Unified service with all 42 Elasticsearch operations

## Smithy Service

The module includes a unified HTTP-bound Smithy service definition (`ElasticService`) that maps all Elasticsearch operations to HTTP endpoints:

### ElasticService (42 operations)

**Document Operations** (4):
- `GetDocument` - GET /{index}/_doc/{id}
- `IndexDocument` - POST /{index}/_doc/{id}
- `MultiGetDocuments` - POST /_mget
- `CountDocuments` - POST /_count

**Search Operations** (3):
- `Search` - POST /{index}/_search
- `SearchScroll` - POST /_search/scroll/{scrollId}
- `ClearScroll` - DELETE /_search/scroll

**Index Management Operations** (9):
- `CreateIndex` - PUT /{index}
- `DeleteIndex` - DELETE /{index}
- `OpenIndex` - POST /{index}/_open
- `CloseIndex` - POST /{index}/_close
- `RefreshIndex` - POST /{index}/_refresh
- `FlushIndex` - POST /{index}/_flush
- `GetIndexStats` - GET /{index}/_stats
- `GetAliases` - GET /{index}/_alias/{alias}
- `UpdateAliases` - POST /_aliases

**Cluster Operations** (2):
- `GetClusterHealth` - GET /_cluster/health
- `GetClusterStats` - GET /_cluster/stats

**Update Operations** (2):
- `UpdateDocument` - POST /{index}/_update/{id}
- `UpdateByQuery` - POST /{index}/_update_by_query

**Bulk Operations** (1):
- `BulkOperations` - POST /_bulk

**Delete Operations** (2):
- `DeleteDocument` - DELETE /{index}/_doc/{id}
- `DeleteByQuery` - POST /{index}/_delete_by_query

**Snapshot Operations** (7):
- `CreateRepository` - PUT /_snapshot/{repository}
- `GetRepository` - GET /_snapshot/{repository}
- `DeleteRepository` - DELETE /_snapshot/{repository}
- `CreateSnapshot` - PUT /_snapshot/{repository}/{snapshot}
- `GetSnapshot` - GET /_snapshot/{repository}/{snapshot}
- `DeleteSnapshot` - DELETE /_snapshot/{repository}/{snapshot}
- `RestoreSnapshot` - POST /_snapshot/{repository}/{snapshot}/_restore

**Reindex Operations** (1):
- `Reindex` - POST /_reindex

**Ingest Pipeline Operations** (4):
- `PutPipeline` - PUT /_ingest/pipeline/{id}
- `GetPipeline` - GET /_ingest/pipeline/{id}
- `DeletePipeline` - DELETE /_ingest/pipeline/{id}
- `SimulatePipeline` - POST /_ingest/pipeline/{id}/_simulate

**Script Management Operations** (3):
- `PutStoredScript` - PUT /_scripts/{id}
- `GetStoredScript` - GET /_scripts/{id}
- `DeleteStoredScript` - DELETE /_scripts/{id}

**Task Management Operations** (3):
- `ListTasks` - GET /_tasks
- `GetTask` - GET /_tasks/{taskId}
- `CancelTask` - POST /_tasks/{taskId}/_cancel

## Usage

Add the dependency to your `build.sbt`:

```scala
libraryDependencies += "nl.gn0s1s" %% "elastic4s-smithy4s" % elastic4sVersion
```

The generated Scala code will be available in the `com.sksamuel.elastic4s.smithy.*` packages.

Example usage with unified service:

```scala
import se.thanh.elastic4cats._
import smithy4s.http4s.SimpleRestJsonBuilder

// The generated ElasticService trait can be used with smithy4s HTTP libraries
val service: ElasticService[F] = ???

// All 42 operations are available through a single service interface
service.getDocument(GetDocumentInput(index = "myindex", id = "doc123"))
service.search(SearchInput(index = "myindex", body = searchQuery))
service.bulkOperations(BulkOperationsInput(body = bulkRequest))
```

Example usage with generated types:

```scala
import se.thanh.elastic4cats._

val getRequest = GetDocumentInput(
  index = "myindex",
  id = "doc123",
  refresh = Some(true)
)

val searchRequest = SearchInput(
  index = "products",
  body = searchQuery
)
```

## Smithy Specifications

Smithy specifications follow the [Smithy IDL syntax](https://smithy.io/2.0/spec/idl.html). Key files:

### Core APIs
- `common.smithy` - Common types and enums (HealthStatus, RefreshPolicy, VersionType, DistanceUnit, etc.)
- `get.smithy` - Get and MultiGet operations
- `count.smithy` - Count operations
- `delete.smithy` - Delete and DeleteByQuery operations
- `index.smithy` - Index operations
- `update.smithy` - Update and UpdateByQuery operations
- `bulk.smithy` - Bulk operations (index, create, update, delete)

### Search & Analysis
- `search.smithy` - Full search API with aggregations, highlights, sorting, profiling
- `scroll.smithy` - Scroll API for pagination
- `script.smithy` - Stored scripts and search templates

### Index & Cluster Management
- `indices.smithy` - Index management (create, delete, open, close, stats, mappings, settings)
- `alias.smithy` - Index alias operations
- `cluster.smithy` - Cluster health, state, and statistics

### Data Management
- `reindex.smithy` - Reindex operations
- `snapshot.smithy` - Snapshot and restore operations
- `ingest.smithy` - Ingest pipeline operations

### Operations & Monitoring
- `task.smithy` - Task management operations

## Building

The Smithy4s SBT plugin automatically generates Scala code from the Smithy specifications during compilation:

```bash
sbt smithy4s/compile
```

This generates approximately 308 Scala files from 17 Smithy specifications.

## Comparison with elastic4s-domain

Both modules provide the same functionality but with different approaches:

- **elastic4s-domain**: Hand-written Scala case classes and traits
- **elastic4s-smithy4s**: Generated from Smithy IDL specifications

Choose `elastic4s-smithy4s` if you:
- Want protocol-agnostic specifications
- Need to generate clients in multiple languages
- Prefer IDL-based definitions over hand-written code
- Want automatic validation and serialization
- Need to maintain API contracts in a structured format

Choose `elastic4s-domain` if you:
- Prefer traditional Scala code
- Need full control over implementation details
- Want to avoid build-time code generation

## Generated Code

The Smithy4s plugin generates:
- Case classes for all structures
- Sealed traits for enums and unions
- Type-safe schemas using Smithy4s Schema API
- JSON codecs for serialization/deserialization
- Documentation from Smithy comments

## Coverage

The module covers the following Elasticsearch APIs:

**Document APIs**: Get, MultiGet, Index, Update, UpdateByQuery, Delete, DeleteByQuery, Bulk, Count

**Search APIs**: Search (with aggregations, highlights, sorting, profiling), Scroll, ClearScroll

**Index APIs**: Create Index, Delete Index, Open Index, Close Index, Refresh, Flush, Index Stats, Index Settings, Mappings

**Cluster APIs**: Cluster Health, Cluster State, Cluster Stats

**Alias APIs**: Get Aliases, Add/Remove Aliases, Indices Aliases

**Data APIs**: Reindex

**Snapshot APIs**: Create/Get/Delete Snapshot, Create/Get/Delete Repository, Restore Snapshot

**Ingest APIs**: Put/Get/Delete Pipeline, Simulate Pipeline

**Script APIs**: Put/Get/Delete Stored Script, Search Template

**Task APIs**: List Tasks, Get Task, Cancel Task

This provides comprehensive coverage of the core Elasticsearch APIs used in most applications.

## Testing

The module includes comprehensive integration tests using Testcontainers for Elasticsearch. The tests demonstrate practical usage of the Smithy4s-generated types and validate functionality against real Elasticsearch instances.

### Test Structure

- **Unit Tests**: Basic type construction and validation (`Smithy4sBasicTest`, `Smithy4sTypesTest`)
- **Integration Tests**: Full operations tested against Elasticsearch containers
  - Document operations (Get, Index, Update, Delete, Count)
  - Search operations (queries, aggregations, sorting)
  - Bulk operations (mixed operations)
  - Index management (create, delete, open, close, refresh, stats)
  - Cluster operations (health, stats)
  - Alias operations (add, remove, get)

### Running Tests

```bash
# Run all tests
sbt "smithy4s/test"

# Run specific test suite
sbt "smithy4s/testOnly se.thanh.elastic4s.integration.DocumentOperationsIntegrationTest"
```

### Test Approach

The integration tests use:
- **Testcontainers**: Automatic Elasticsearch container lifecycle
- **HTTP4s**: Type-safe HTTP client with Cats Effect
- **Smithy4s Types**: Generated request/response models
- **ScalaTest**: Test framework consistent with elastic4s-tests

See `src/test/scala/se/thanh/elastic4s/integration/README.md` for detailed testing documentation.

### Comparison with Legacy Tests

| Aspect | Legacy elastic4s Tests | Smithy4s Tests |
|--------|------------------------|----------------|
| Test Framework | ScalaTest + DockerTests | ScalaTest + Testcontainers |
| Elasticsearch Setup | External/Manual | Automatic (Docker) |
| API Types | Hand-written models | Smithy4s generated |
| HTTP Client | elastic4s JavaClient | http4s + Cats Effect |
| Isolation | Shared instance | Per-suite containers |
| CI/CD | Requires ES setup | Fully self-contained |

The Smithy4s tests complement the existing elastic4s tests by demonstrating the generated types in action while maintaining the same test coverage.
