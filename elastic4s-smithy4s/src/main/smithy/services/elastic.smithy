$version: "2"

namespace se.thanh.elastic4cats

use alloy#simpleRestJson

/// Unified Elasticsearch Service
/// Provides all Elasticsearch operations in a single service
@title("Elasticsearch API")
@simpleRestJson
service ElasticService {
    version: "9.0"
    operations: [
        // Document Operations
        GetDocument
        MultiGetDocuments
        GetCountDocuments
        PostCountDocuments
        IndexDocument

        // Search Operations
        Search
        SearchScroll
        ClearScroll

        // Index Management Operations
        CreateIndex
        DeleteIndex
        OpenIndex
        CloseIndex
        RefreshIndex
        FlushIndex
        GetIndexStats
        GetAliases
        UpdateAliases

        // Cluster Operations
        GetClusterHealth
        GetClusterStats

        // Update Operations
        UpdateDocument
        UpdateByQuery

        // Bulk Operations
        BulkOperations

        // Delete Operations
        DeleteDocument
        DeleteByQuery

        // Snapshot Operations
        CreateRepository
        GetRepository
        DeleteRepository
        CreateSnapshot
        GetSnapshot
        DeleteSnapshot
        RestoreSnapshot

        // Reindex Operations
        Reindex

        // Ingest Pipeline Operations
        PutPipeline
        GetPipeline
        DeletePipeline
        SimulatePipeline

        // Script Management Operations
        PutStoredScript
        GetStoredScript
        DeleteStoredScript

        // Task Management Operations
        ListTasks
        GetTask
        CancelTask
    ]
}

// ========================================
// Document Operations
// ========================================

/// HTTP-bound Get Document Request
structure GetDocumentInput {
    @required
    @httpLabel
    index: String

    @required
    @httpLabel
    id: String

    @httpQuery("routing")
    routing: String

    @httpQuery("preference")
    preference: String

    @httpQuery("refresh")
    refresh: Boolean

    @httpQuery("realtime")
    realtime: Boolean
}

@error("client")
@httpError(404)
structure GetDocumentError with [GetResponseMixin] {}

/// Retrieves the specified JSON document from an index
/// Returns a document that is stored in an index by its id.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-get
// @http(method: "GET", uri: "/{index}/_doc/{id}", code: 404) cause danger warning
@http(method: "GET", uri: "/{index}/_doc/{id}", code: 200)
@readonly
@externalDocumentation("Elasticsearch Get API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-get")
operation GetDocument {
    input: GetDocumentInput
    output: GetResponse
    // errors: [GetDocumentError]
}

/// HTTP-bound MultiGet Request
structure MultiGetDocumentsInput {
    @required
    @httpPayload
    body: Document

    @httpQuery("preference")
    preference: String

    @httpQuery("refresh")
    refresh: Boolean

    @httpQuery("realtime")
    realtime: Boolean
}

/// Retrieves multiple JSON documents by ID
/// Returns multiple documents from one or more data streams or indices.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-mget
@http(method: "POST", uri: "/_mget")
@externalDocumentation("Elasticsearch Multi Get API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-mget")
operation MultiGetDocuments {
    input: MultiGetDocumentsInput
    output: MultiGetResponse
}

/// HTTP-bound Count Request
structure CountDocumentsInput {
    /// A comma-separated list of data streams, indices, and aliases to search.
    /// It supports wildcards (*). To search all data streams and indices,
    /// omit this parameter or use * or _all.
    @required
    @httpLabel
    index: String

    /// Defines the search query using Query DSL.
    /// A request body query cannot be used with the q query string parameter.
    @httpPayload
    @required
    body: Document
}

/// Returns number of matches for a search query
/// Gets the number of documents matching a query.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-count
@http(method: "POST", uri: "/{index}/_count")
@externalDocumentation("Elasticsearch Count API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-count")
operation PostCountDocuments {
    input: CountDocumentsInput
    output: CountResponse
}

/// Returns number of matches for a search query
/// Gets the number of documents matching a query.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-count
@http(method: "GET", uri: "/{index}/_count")
@externalDocumentation("Elasticsearch Count API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-count")
operation GetCountDocuments {
    input := {
        @required
        @httpLabel
        index: String
    }
    output: CountResponse
}

/// HTTP-bound Index Document Request
structure IndexDocumentInput {
    @required
    @httpLabel
    index: String

    @required
    @httpLabel
    id: String

    @required
    @httpPayload
    body: Document

    @httpQuery("routing")
    routing: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("refresh")
    refresh: String // can be "true", "false", or "wait_for"

    @httpQuery("wait_for_active_shards")
    waitForActiveShards: String

    @httpQuery("pipeline")
    pipeline: String
}

/// Create or update a document in an index
/// Add a JSON document to the specified data stream or index and make it searchable.
/// If the target is an index and the document already exists, the request updates the document and increments its version.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-index
@http(method: "POST", uri: "/{index}/_doc/{id}")
@externalDocumentation("Elasticsearch Index API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-index")
operation IndexDocument {
    input: IndexDocumentInput
    output: IndexResponse
}

// ========================================
// Search Operations
// ========================================

/// HTTP-bound Search Request
structure SearchInput {
    @required
    @httpLabel
    index: String

    @required
    @httpPayload
    body: Document

    @httpQuery("routing")
    routing: String

    @httpQuery("preference")
    preference: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("scroll")
    scroll: String
}

/// Returns search hits that match the query defined in the request
/// Allows you to execute a search query and get back search hits that match the query.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-search
@http(method: "POST", uri: "/{index}/_search")
@externalDocumentation("Elasticsearch Search API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-search")
operation Search {
    input: SearchInput
    output: SearchResponse
}

/// HTTP-bound Search Scroll Request
structure SearchScrollInput {
    @required
    @httpLabel
    scrollId: String

    @httpQuery("scroll")
    scroll: String
}

/// Allows to retrieve the next batch of results for a scrolling search
/// Returns results for a scrolling search started with the scroll parameter.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-scroll
@http(method: "POST", uri: "/_search/scroll/{scrollId}")
@externalDocumentation("Elasticsearch Scroll API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-scroll")
operation SearchScroll {
    input: SearchScrollInput
    output: SearchScrollResponse
}

/// HTTP-bound Clear Scroll Request
structure ClearScrollInput {
    @required
    @httpQuery("scroll_id")
    scrollIds: StringList
}

/// Clears the search context and results for a scrolling search
/// Explicitly clears one or more scroll searches by their IDs.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-clear-scroll
@http(method: "DELETE", uri: "/_search/scroll")
@idempotent
@externalDocumentation("Elasticsearch Clear Scroll API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-clear-scroll")
operation ClearScroll {
    input: ClearScrollInput
    output: ClearScrollResponse
}

// ========================================
// Index Management Operations
// ========================================

/// HTTP-bound Create Index Request
structure CreateIndexInput {
    @required
    @httpLabel
    index: String

    @httpPayload
    body: CreateIndexBody

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String

    @httpQuery("wait_for_active_shards")
    waitForActiveShards: String
}

structure CreateIndexResponse {
    @required
    acknowledged: Boolean
    @jsonName("shards_acknowledged")
    shardsAcknowledged: Boolean
}

/// Creates a new index or data stream
/// Creates a new index with optional settings and mappings.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-create
@http(method: "PUT", uri: "/{index}")
@idempotent
@externalDocumentation("Elasticsearch Create Index API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-create")
operation CreateIndex {
    input: CreateIndexInput
    output: CreateIndexResponse
}

/// HTTP-bound Delete Index Request
structure DeleteIndexInput {
    @required
    @httpLabel
    index: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Deletes an index
/// Removes an index and all its documents permanently.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-delete
@http(method: "DELETE", uri: "/{index}")
@idempotent
@externalDocumentation("Elasticsearch Delete Index API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-delete")
operation DeleteIndex {
    input: DeleteIndexInput
    output: DeleteIndexResponse
}

/// HTTP-bound Open Index Request
structure OpenIndexInput {
    @required
    @httpLabel
    index: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String

    @httpQuery("wait_for_active_shards")
    waitForActiveShards: String
}

/// Opens a closed index
/// Makes a closed index available for search and indexing again.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-open
@http(method: "POST", uri: "/{index}/_open")
@externalDocumentation("Elasticsearch Open Index API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-open")
operation OpenIndex {
    input: OpenIndexInput
    output: OpenIndexResponse
}

/// HTTP-bound Close Index Request
structure CloseIndexInput {
    @required
    @httpLabel
    index: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Closes an index
/// Blocks read/write operations on an index to reduce resource usage.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-close
@http(method: "POST", uri: "/{index}/_close")
@externalDocumentation("Elasticsearch Close Index API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-close")
operation CloseIndex {
    input: CloseIndexInput
    output: CloseIndexResponse
}

/// HTTP-bound Refresh Index Request
structure RefreshIndexInput {
    @required
    @httpLabel
    index: String
}

structure RefreshIndexResponse {
  @jsonName("_shards")
  shards: Shards
}

/// Performs the refresh operation in one or more indices
/// Makes recent operations performed on one or more indices available for search.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-refresh
@http(method: "POST", uri: "/{index}/_refresh")
@externalDocumentation("Elasticsearch Refresh API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-refresh")
operation RefreshIndex {
    input: RefreshIndexInput
    output: RefreshIndexResponse
}

/// HTTP-bound Flush Index Request
structure FlushIndexInput {
    @required
    @httpLabel
    index: String

    @httpQuery("wait_if_ongoing")
    waitIfOngoing: Boolean

    @httpQuery("force")
    force: Boolean
}

/// Performs the flush operation on one or more indices
/// Frees memory from the index by flushing data to the index storage and clearing the internal transaction log.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-flush
@http(method: "POST", uri: "/{index}/_flush")
@externalDocumentation("Elasticsearch Flush API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-flush")
operation FlushIndex {
    input: FlushIndexInput
    output: FlushIndexResponse
}
structure FlushIndexResponse {
  @jsonName("_shards")
  shards: Shards
}

/// HTTP-bound Get Index Stats Request
structure GetIndexStatsInput {
    @required
    @httpLabel
    index: String

    @httpQuery("level")
    level: String
}

/// Returns statistical information about one or more indices
/// Provides statistics on operations happening in an index.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-stats
@http(method: "GET", uri: "/{index}/_stats")
@readonly
@externalDocumentation("Elasticsearch Index Stats API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-stats")
operation GetIndexStats {
    input: GetIndexStatsInput
    output: IndexStatsResponse
}

/// HTTP-bound Get Aliases Request
structure GetAliasesInput {
    @required
    @httpLabel
    index: String

    @required
    @httpLabel
    alias: String
}

/// Retrieves information for one or more aliases
/// Returns information about one or more aliases.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-get-alias
@http(method: "GET", uri: "/{index}/_alias/{alias}")
@readonly
@externalDocumentation("Elasticsearch Get Alias API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-get-alias")
operation GetAliases {
    input: GetAliasesInput
    output: GetAliasesResponse
}

/// HTTP-bound Update Aliases Request
structure UpdateAliasesInput {
    @required
    @httpPayload
    body: Document

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Adds or removes index aliases
/// Creates or updates an alias to point to one or more indices.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-update-aliases
@http(method: "POST", uri: "/_aliases")
@externalDocumentation("Elasticsearch Update Aliases API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-indices-update-aliases")
operation UpdateAliases {
    input: UpdateAliasesInput
    output: UpdateAliasesResponse
}

structure UpdateAliasesResponse {
    @required
    acknowledged: Boolean
}

// ========================================
// Cluster Operations
// ========================================

/// HTTP-bound Cluster Health Request
structure GetClusterHealthInput {
    @httpQuery("level")
    level: String

    @httpQuery("wait_for_status")
    waitForStatus: String

    @httpQuery("timeout")
    timeout: String
}

/// Returns cluster health status
/// Returns the health status of a cluster.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-health
@http(method: "GET", uri: "/_cluster/health")
@readonly
@externalDocumentation("Elasticsearch Cluster Health API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-health")
operation GetClusterHealth {
    input: GetClusterHealthInput
    output: ClusterHealthResponse
}

/// HTTP-bound Cluster Stats Request
structure GetClusterStatsInput {
    @httpQuery("flat_settings")
    flatSettings: Boolean
}

/// Returns cluster statistics
/// Returns high-level overview of cluster statistics.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-stats
@http(method: "GET", uri: "/_cluster/stats")
@readonly
@externalDocumentation("Elasticsearch Cluster Stats API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-cluster-stats")
operation GetClusterStats {
    input: GetClusterStatsInput
    output: ClusterStatsResponse
}

// ========================================
// Update Operations
// ========================================

/// HTTP-bound Update Document Request
structure UpdateDocumentInput {
    @required
    @httpLabel
    index: String

    @required
    @httpLabel
    id: String

    @required
    @httpPayload
    body: Document

    @httpQuery("routing")
    routing: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("refresh")
    refresh: String

    @httpQuery("retry_on_conflict")
    retryOnConflict: Integer

    @httpQuery("wait_for_active_shards")
    waitForActiveShards: String
}

/// Updates a document with a script or partial document
/// Updates a document using the specified script or partial document.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-update
@http(method: "POST", uri: "/{index}/_update/{id}")
@externalDocumentation("Elasticsearch Update API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-update")
operation UpdateDocument {
    input: UpdateDocumentInput
    output: UpdateResponse
}

/// HTTP-bound Update By Query Request
structure UpdateByQueryInput {
    @required
    @httpLabel
    index: String

    @required
    @httpPayload
    body: Document

    @httpQuery("conflicts")
    conflicts: String

    @httpQuery("refresh")
    refresh: Boolean

    @httpQuery("wait_for_completion")
    waitForCompletion: Boolean

    @httpQuery("scroll_size")
    scrollSize: Integer
}

/// Updates documents that match a specified query
/// Performs an update on every document in the index without changing the source.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-update-by-query
@http(method: "POST", uri: "/{index}/_update_by_query")
@externalDocumentation("Elasticsearch Update By Query API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-update-by-query")
operation UpdateByQuery {
    input: UpdateByQueryInput
    output: UpdateByQueryResponse
}

// ========================================
// Bulk Operations
// ========================================

/// HTTP-bound Bulk Request
structure BulkOperationsInput {
    @required
    @httpPayload
    body: Document

    @httpQuery("index")
    index: String

    @httpQuery("routing")
    routing: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("refresh")
    refresh: String

    @httpQuery("wait_for_active_shards")
    waitForActiveShards: String

    @httpQuery("pipeline")
    pipeline: String
}

/// Allows to perform multiple index/update/delete operations in a single request
/// Performs multiple indexing or delete operations in a single API call.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-bulk
@http(method: "POST", uri: "/_bulk")
@externalDocumentation("Elasticsearch Bulk API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-bulk")
operation BulkOperations {
    input: BulkOperationsInput
    output: BulkResponse
}

// ========================================
// Delete Operations
// ========================================

/// HTTP-bound Delete Document Request
structure DeleteDocumentInput {
    @required
    @httpLabel
    index: String

    @required
    @httpLabel
    id: String

    @httpQuery("routing")
    routing: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("refresh")
    refresh: String

    @httpQuery("wait_for_active_shards")
    waitForActiveShards: String
}

/// Removes a document from the index
/// Removes a JSON document from the specified index.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-delete
@http(method: "DELETE", uri: "/{index}/_doc/{id}")
@idempotent
@externalDocumentation("Elasticsearch Delete API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-delete")
operation DeleteDocument {
    input: DeleteDocumentInput
    output: DeleteResponse
}

/// HTTP-bound Delete By Query Request
structure DeleteByQueryInput {
    @required
    @httpLabel
    index: String

    @required
    @httpPayload
    body: Document

    @httpQuery("conflicts")
    conflicts: String

    @httpQuery("refresh")
    refresh: Boolean

    @httpQuery("wait_for_completion")
    waitForCompletion: Boolean

    @httpQuery("scroll_size")
    scrollSize: Integer
}

/// Deletes documents that match a specified query
/// Deletes all documents that match the specified query.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-delete-by-query
@http(method: "POST", uri: "/{index}/_delete_by_query")
@externalDocumentation("Elasticsearch Delete By Query API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-delete-by-query")
operation DeleteByQuery {
    input: DeleteByQueryInput
    output: DeleteByQueryResponse
}

// ========================================
// Snapshot Operations
// ========================================

/// HTTP-bound Create Repository Request
structure CreateRepositoryInput {
    @required
    @httpLabel
    repository: String

    @required
    @httpPayload
    body: Document

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String

    @httpQuery("verify")
    verify: Boolean
}

structure CreateRepositoryResponse {
    @required
    acknowledged: Boolean
}

/// Creates a repository
/// Registers a shared file system repository or read-only URL repository.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-create-repository
@http(method: "PUT", uri: "/_snapshot/{repository}")
@idempotent
@externalDocumentation("Elasticsearch Create Repository API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-create-repository")
operation CreateRepository {
    input: CreateRepositoryInput
    output: CreateRepositoryResponse
}

/// HTTP-bound Get Repository Request
structure GetRepositoryInput {
    @required
    @httpLabel
    repository: String

    @httpQuery("local")
    local: Boolean

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Returns information about a repository
/// Returns information about one or more registered snapshot repositories.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-get-repository
@http(method: "GET", uri: "/_snapshot/{repository}")
@readonly
@externalDocumentation("Elasticsearch Get Repository API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-get-repository")
operation GetRepository {
    input: GetRepositoryInput
    output: GetRepositoryResponse
}

/// HTTP-bound Delete Repository Request
structure DeleteRepositoryInput {
    @required
    @httpLabel
    repository: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Deletes a repository
/// Unregisters one or more snapshot repositories.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-delete-repository
@http(method: "DELETE", uri: "/_snapshot/{repository}")
@idempotent
@externalDocumentation("Elasticsearch Delete Repository API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-delete-repository")
operation DeleteRepository {
    input: DeleteRepositoryInput
    output: DeleteRepositoryResponse
}

structure DeleteRepositoryResponse {
    @required
    acknowledged: Boolean
}

/// HTTP-bound Create Snapshot Request
structure CreateSnapshotInput {
    @required
    @httpLabel
    repository: String

    @required
    @httpLabel
    snapshot: String

    @httpPayload
    body: Document

    @httpQuery("wait_for_completion")
    waitForCompletion: Boolean

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Creates a snapshot in a repository
/// Takes a snapshot of one or more indices to a repository.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-create
@http(method: "PUT", uri: "/_snapshot/{repository}/{snapshot}")
@idempotent
@externalDocumentation("Elasticsearch Create Snapshot API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-create")
operation CreateSnapshot {
    input: CreateSnapshotInput
    output: CreateSnapshotResponse
}

/// HTTP-bound Get Snapshot Request
structure GetSnapshotInput {
    @required
    @httpLabel
    repository: String

    @required
    @httpLabel
    snapshot: String

    @httpQuery("ignore_unavailable")
    ignoreUnavailable: Boolean

    @httpQuery("verbose")
    verbose: Boolean
}

/// Returns information about a snapshot
/// Returns information about one or more snapshots.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-get
@http(method: "GET", uri: "/_snapshot/{repository}/{snapshot}")
@readonly
@externalDocumentation("Elasticsearch Get Snapshot API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-get")
operation GetSnapshot {
    input: GetSnapshotInput
    output: GetSnapshotResponse
}

/// HTTP-bound Delete Snapshot Request
structure DeleteSnapshotInput {
    @required
    @httpLabel
    repository: String

    @required
    @httpLabel
    snapshot: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Deletes one or more snapshots
/// Deletes one or more snapshots from a repository.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-delete
@http(method: "DELETE", uri: "/_snapshot/{repository}/{snapshot}")
@idempotent
@externalDocumentation("Elasticsearch Delete Snapshot API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-delete")
operation DeleteSnapshot {
    input: DeleteSnapshotInput
    output: DeleteSnapshotResponse
}

structure DeleteSnapshotResponse {
    @required
    acknowledged: Boolean
}

/// HTTP-bound Restore Snapshot Request
structure RestoreSnapshotInput {
    @required
    @httpLabel
    repository: String

    @required
    @httpLabel
    snapshot: String

    @httpPayload
    body: Document

    @httpQuery("wait_for_completion")
    waitForCompletion: Boolean

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Restores a snapshot
/// Restores a snapshot of a cluster or specified data streams and indices.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-restore
@http(method: "POST", uri: "/_snapshot/{repository}/{snapshot}/_restore")
@externalDocumentation("Elasticsearch Restore Snapshot API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-snapshot-restore")
operation RestoreSnapshot {
    input: RestoreSnapshotInput
    output: RestoreSnapshotResponse
}

// ========================================
// Reindex Operations
// ========================================

/// HTTP-bound Reindex Request
structure ReindexInput {
    @required
    @httpPayload
    body: Document

    @httpQuery("refresh")
    refresh: Boolean

    @httpQuery("timeout")
    timeout: String

    @httpQuery("wait_for_completion")
    waitForCompletion: Boolean

    @httpQuery("requests_per_second")
    requestsPerSecond: Float

    @httpQuery("slices")
    slices: String
}

/// Allows to copy documents from one index to another
/// Copies documents from a source to a destination.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-reindex
@http(method: "POST", uri: "/_reindex")
@externalDocumentation("Elasticsearch Reindex API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-reindex")
operation Reindex {
    input: ReindexInput
    output: ReindexResponse
}

// ========================================
// Ingest Pipeline Operations
// ========================================

/// HTTP-bound Put Pipeline Request
structure PutPipelineInput {
    @required
    @httpLabel
    id: String

    @required
    @httpPayload
    body: Document

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Creates or updates an ingest pipeline
/// Creates or updates a pipeline that can be used to pre-process documents during ingestion.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ingest-put-pipeline
@http(method: "PUT", uri: "/_ingest/pipeline/{id}")
@idempotent
@externalDocumentation("Elasticsearch Put Pipeline API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ingest-put-pipeline")
operation PutPipeline {
    input: PutPipelineInput
    output: PutPipelineResponse
}

structure PutPipelineResponse {
    @required
    acknowledged: Boolean
}

/// HTTP-bound Get Pipeline Request
structure GetPipelineInput {
    @required
    @httpLabel
    id: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Returns information about an ingest pipeline
/// Returns information about one or more ingest pipelines.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ingest-get-pipeline
@http(method: "GET", uri: "/_ingest/pipeline/{id}")
@readonly
@externalDocumentation("Elasticsearch Get Pipeline API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ingest-get-pipeline")
operation GetPipeline {
    input: GetPipelineInput
    output: GetPipelineResponse
}

/// HTTP-bound Delete Pipeline Request
structure DeletePipelineInput {
    @required
    @httpLabel
    id: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Deletes an ingest pipeline
/// Deletes one or more existing ingest pipeline.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ingest-delete-pipeline
@http(method: "DELETE", uri: "/_ingest/pipeline/{id}")
@idempotent
@externalDocumentation("Elasticsearch Delete Pipeline API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ingest-delete-pipeline")
operation DeletePipeline {
    input: DeletePipelineInput
    output: DeletePipelineResponse
}

/// HTTP-bound Simulate Pipeline Request
structure SimulatePipelineInput {
    @required
    @httpLabel
    id: String

    @required
    @httpPayload
    body: Document

    @httpQuery("verbose")
    verbose: Boolean
}

/// Executes an ingest pipeline against a set of documents
/// Allows to simulate a pipeline with example documents.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ingest-simulate
@http(method: "POST", uri: "/_ingest/pipeline/{id}/_simulate")
@externalDocumentation("Elasticsearch Simulate Pipeline API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-ingest-simulate")
operation SimulatePipeline {
    input: SimulatePipelineInput
    output: SimulatePipelineResponse
}

// ========================================
// Script Management Operations
// ========================================

/// HTTP-bound Put Stored Script Request
structure PutStoredScriptInput {
    @required
    @httpLabel
    id: String

    @required
    @httpPayload
    body: Document

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String

    @httpQuery("context")
    context: String
}

/// Creates or updates a stored script or search template
/// Creates or updates a stored script or search template.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-put-script
@http(method: "PUT", uri: "/_scripts/{id}")
@idempotent
@externalDocumentation("Elasticsearch Put Stored Script API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-put-script")
operation PutStoredScript {
    input: PutStoredScriptInput
    output: PutStoredScriptResponse
}

structure PutStoredScriptResponse {
    @required
    acknowledged: Boolean
}

/// HTTP-bound Get Stored Script Request
structure GetStoredScriptInput {
    @required
    @httpLabel
    id: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Returns a stored script or search template
/// Returns a script or search template.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-get-script
@http(method: "GET", uri: "/_scripts/{id}")
@readonly
@externalDocumentation("Elasticsearch Get Stored Script API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-get-script")
operation GetStoredScript {
    input: GetStoredScriptInput
    output: GetStoredScriptResponse
}

/// HTTP-bound Delete Stored Script Request
structure DeleteStoredScriptInput {
    @required
    @httpLabel
    id: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Deletes a stored script or search template
/// Deletes a stored script or search template.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-delete-script
@http(method: "DELETE", uri: "/_scripts/{id}")
@idempotent
@externalDocumentation("Elasticsearch Delete Stored Script API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-delete-script")
operation DeleteStoredScript {
    input: DeleteStoredScriptInput
    output: DeleteStoredScriptResponse
}

// ========================================
// Task Management Operations
// ========================================

/// HTTP-bound List Tasks Request
structure ListTasksInput {
    @httpQuery("actions")
    actions: String

    @httpQuery("detailed")
    detailed: Boolean

    @httpQuery("group_by")
    groupBy: String

    @httpQuery("nodes")
    nodes: String

    @httpQuery("parent_task_id")
    parentTaskId: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("wait_for_completion")
    waitForCompletion: Boolean
}

/// Returns information about the tasks currently executing in the cluster
/// Returns a list of tasks currently executing on one or more nodes in the cluster.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-tasks-list
@http(method: "GET", uri: "/_tasks")
@readonly
@externalDocumentation("Elasticsearch Task Management API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-tasks-list")
operation ListTasks {
    input: ListTasksInput
    output: ListTasksResponse
}

/// HTTP-bound Get Task Request
structure GetTaskInput {
    @required
    @httpLabel
    taskId: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("wait_for_completion")
    waitForCompletion: Boolean
}

/// Returns information about a task
/// Returns information about a task.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-tasks-get
@http(method: "GET", uri: "/_tasks/{taskId}")
@readonly
@externalDocumentation("Elasticsearch Get Task API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-tasks-get")
operation GetTask {
    input: GetTaskInput
    output: GetTaskResponse
}

/// HTTP-bound Cancel Task Request
structure CancelTaskInput {
    @required
    @httpLabel
    taskId: String

    @httpQuery("actions")
    actions: String

    @httpQuery("nodes")
    nodes: String

    @httpQuery("parent_task_id")
    parentTaskId: String
}

/// Cancels a task
/// Cancels a task, if it can be cancelled through an API.
///
/// Check https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-tasks-cancel
@http(method: "POST", uri: "/_tasks/{taskId}/_cancel")
@externalDocumentation("Elasticsearch Cancel Task API": "https://www.elastic.co/docs/api/doc/elasticsearch/operation/operation-tasks-cancel")
operation CancelTask {
    input: CancelTaskInput
    output: CancelTaskResponse
}
