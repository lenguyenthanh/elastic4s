# Smithy Service Operations

This document maps the Elasticsearch handlers to Smithy operations defined in this module.

## Overview

While Smithy services with HTTP bindings would be ideal, the naming conflicts between helper structures (like `Failure`, `Script`, `StringList`) across different namespaces make it impractical to bundle operations into Smithy service definitions.

Instead, this module provides comprehensive Smithy specifications for all request/response types that correspond to the handlers in the `elastic4s-handlers` module.

## Handler to Smithy Mapping

### Document Operations

| Handler | Smithy Namespace | Request Type | Response Type |
|---------|------------------|--------------|---------------|
| GetHandler | `com.sksamuel.elastic4s.smithy.get` | GetRequest | GetResponse |
| MultiGetHandler | `com.sksamuel.elastic4s.smithy.get` | MultiGetRequest | MultiGetResponse |
| IndexHandler | `com.sksamuel.elastic4s.smithy.index` | IndexRequest | IndexResponse |
| UpdateHandler | `com.sksamuel.elastic4s.smithy.update` | UpdateRequest | UpdateResponse |
| UpdateByQueryHandler | `com.sksamuel.elastic4s.smithy.update` | UpdateByQueryRequest | UpdateByQueryResponse |
| DeleteHandler | `com.sksamuel.elastic4s.smithy.delete` | DeleteByIdRequest | DeleteResponse |
| DeleteByQueryHandler | `com.sksamuel.elastic4s.smithy.delete` | DeleteByQueryRequest | DeleteByQueryResponse |
| BulkHandler | `com.sksamuel.elastic4s.smithy.bulk` | BulkRequest | BulkResponse |
| CountHandler | `com.sksamuel.elastic4s.smithy.count` | CountRequest | CountResponse |

### Search Operations

| Handler | Smithy Namespace | Request Type | Response Type |
|---------|------------------|--------------|---------------|
| SearchHandler | `com.sksamuel.elastic4s.smithy.search` | SearchRequest | SearchResponse |
| SearchScrollHandler | `com.sksamuel.elastic4s.smithy.scroll` | SearchScrollRequest | SearchScrollResponse |
| ClearScrollHandler | `com.sksamuel.elastic4s.smithy.scroll` | ClearScrollRequest | ClearScrollResponse |

### Index Management Operations

| Handler | Smithy Namespace | Request Type | Response Type |
|---------|------------------|--------------|---------------|
| CreateIndexHandler | `com.sksamuel.elastic4s.smithy.indices` | CreateIndexRequest | - |
| DeleteIndexHandler | `com.sksamuel.elastic4s.smithy.indices` | DeleteIndexRequest | DeleteIndexResponse |
| OpenIndexHandler | `com.sksamuel.elastic4s.smithy.indices` | OpenIndexRequest | OpenIndexResponse |
| CloseIndexHandler | `com.sksamuel.elastic4s.smithy.indices` | CloseIndexRequest | CloseIndexResponse |
| RefreshIndexHandler | `com.sksamuel.elastic4s.smithy.indices` | RefreshIndexRequest | - |
| FlushIndexHandler | `com.sksamuel.elastic4s.smithy.indices` | FlushIndexRequest | - |
| IndexStatsHandler | `com.sksamuel.elastic4s.smithy.indices` | IndexStatsRequest | IndexStatsResponse |

### Alias Operations

| Handler | Smithy Namespace | Request Type | Response Type |
|---------|------------------|--------------|---------------|
| GetAliasesHandler | `com.sksamuel.elastic4s.smithy.alias` | GetAliasesRequest | GetAliasesResponse |
| IndicesAliasesHandler | `com.sksamuel.elastic4s.smithy.alias` | IndicesAliasesRequest | IndicesAliasesResponse |

### Cluster Operations

| Handler | Smithy Namespace | Request Type | Response Type |
|---------|------------------|--------------|---------------|
| ClusterHealthHandler | `com.sksamuel.elastic4s.smithy.cluster` | ClusterHealthRequest | ClusterHealthResponse |
| ClusterStateHandler | `com.sksamuel.elastic4s.smithy.cluster` | ClusterStateRequest | - |
| ClusterStatsHandler | `com.sksamuel.elastic4s.smithy.cluster` | ClusterStatsRequest | ClusterStatsResponse |

### Snapshot Operations

| Handler | Smithy Namespace | Request Type | Response Type |
|---------|------------------|--------------|---------------|
| CreateSnapshotHandler | `com.sksamuel.elastic4s.smithy.snapshot` | CreateSnapshotRequest | - |
| GetSnapshotsHandler | `com.sksamuel.elastic4s.smithy.snapshot` | GetSnapshotsRequest | GetSnapshotsResponse |
| DeleteSnapshotHandler | `com.sksamuel.elastic4s.smithy.snapshot` | DeleteSnapshotRequest | - |
| RestoreSnapshotHandler | `com.sksamuel.elastic4s.smithy.snapshot` | RestoreSnapshotRequest | - |
| CreateRepositoryHandler | `com.sksamuel.elastic4s.smithy.snapshot` | CreateRepositoryRequest | - |
| GetRepositoryHandler | `com.sksamuel.elastic4s.smithy.snapshot` | GetRepositoryRequest | - |
| DeleteRepositoryHandler | `com.sksamuel.elastic4s.smithy.snapshot` | DeleteRepositoryRequest | - |

### Ingest Pipeline Operations

| Handler | Smithy Namespace | Request Type | Response Type |
|---------|------------------|--------------|---------------|
| PutPipelineHandler | `com.sksamuel.elastic4s.smithy.ingest` | PutPipelineRequest | - |
| GetPipelineHandler | `com.sksamuel.elastic4s.smithy.ingest` | GetPipelineRequest | GetPipelineResponse |
| DeletePipelineHandler | `com.sksamuel.elastic4s.smithy.ingest` | DeletePipelineRequest | DeletePipelineResponse |
| SimulatePipelineHandler | `com.sksamuel.elastic4s.smithy.ingest` | SimulatePipelineRequest | SimulatePipelineResponse |

### Script Operations

| Handler | Smithy Namespace | Request Type | Response Type |
|---------|------------------|--------------|---------------|
| PutStoredScriptHandler | `com.sksamuel.elastic4s.smithy.script` | PutStoredScriptRequest | - |
| GetStoredScriptHandler | `com.sksamuel.elastic4s.smithy.script` | GetStoredScriptRequest | GetStoredScriptResponse |
| DeleteStoredScriptHandler | `com.sksamuel.elastic4s.smithy.script` | DeleteStoredScriptRequest | DeleteStoredScriptResponse |
| SearchTemplateHandler | `com.sksamuel.elastic4s.smithy.script` | SearchTemplateRequest | - |
| PutSearchTemplateHandler | `com.sksamuel.elastic4s.smithy.script` | PutSearchTemplateRequest | - |
| GetSearchTemplateHandler | `com.sksamuel.elastic4s.smithy.script` | GetSearchTemplateRequest | - |
| DeleteSearchTemplateHandler | `com.sksamuel.elastic4s.smithy.script` | DeleteSearchTemplateRequest | - |

### Task Operations

| Handler | Smithy Namespace | Request Type | Response Type |
|---------|------------------|--------------|---------------|
| ListTasksHandler | `com.sksamuel.elastic4s.smithy.task` | ListTasksRequest | ListTasksResponse |
| GetTaskHandler | `com.sksamuel.elastic4s.smithy.task` | GetTaskRequest | GetTaskResponse |
| CancelTaskHandler | `com.sksamuel.elastic4s.smithy.task` | CancelTaskRequest | CancelTaskResponse |

### Data Operations

| Handler | Smithy Namespace | Request Type | Response Type |
|---------|------------------|--------------|---------------|
| ReindexHandler | `com.sksamuel.elastic4s.smithy.reindex` | ReindexRequest | ReindexResponse |

## Notes

- All Smithy specifications are generated into Scala case classes with type-safe schemas
- The generated code is in the `com.sksamuel.elastic4s.smithy.*` packages
- Each operation's request and response types are defined in separate Smithy files
- HTTP bindings and routing information can be found in the elastic4s-handlers module
