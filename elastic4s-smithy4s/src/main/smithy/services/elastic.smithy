$version: "2"

namespace se.thanh.elastic4cats

/// Unified Elasticsearch Service
/// Provides all Elasticsearch operations in a single service
@title("Elasticsearch API")
service ElasticService {
    version: "9.0"
    operations: [
        // Document Operations
        GetDocument
        MultiGetDocuments
        CountDocuments
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

/// Get a single document by ID
@http(method: "GET", uri: "/{index}/_doc/{id}")
@readonly
operation GetDocument {
    input: GetDocumentInput
    output: GetResponse
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

/// Get multiple documents in a single request
@http(method: "POST", uri: "/_mget")
operation MultiGetDocuments {
    input: MultiGetDocumentsInput
    output: MultiGetResponse
}

/// HTTP-bound Count Request
structure CountDocumentsInput {
    @httpQuery("index")
    indexes: String

    @httpPayload
    body: Document
}

/// Count documents matching a query
@http(method: "POST", uri: "/_count")
operation CountDocuments {
    input: CountDocumentsInput
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
    refresh: String

    @httpQuery("wait_for_active_shards")
    waitForActiveShards: String

    @httpQuery("pipeline")
    pipeline: String
}

/// Index a document
@http(method: "POST", uri: "/{index}/_doc/{id}")
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

/// Search for documents
@http(method: "POST", uri: "/{index}/_search")
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

/// Continue scrolling through search results
@http(method: "POST", uri: "/_search/scroll/{scrollId}")
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

/// Clear scroll contexts
@http(method: "DELETE", uri: "/_search/scroll")
@idempotent
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
    body: Document

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String

    @httpQuery("wait_for_active_shards")
    waitForActiveShards: String
}

/// Create a new index
@http(method: "PUT", uri: "/{index}")
@idempotent
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

/// Delete an index
@http(method: "DELETE", uri: "/{index}")
@idempotent
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

/// Open a closed index
@http(method: "POST", uri: "/{index}/_open")
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

/// Close an index
@http(method: "POST", uri: "/{index}/_close")
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

/// Refresh an index
@http(method: "POST", uri: "/{index}/_refresh")
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

/// Flush an index
@http(method: "POST", uri: "/{index}/_flush")
operation FlushIndex {
    input: FlushIndexInput
    output: FlushIndexResponse
}

/// HTTP-bound Get Index Stats Request
structure GetIndexStatsInput {
    @required
    @httpLabel
    index: String

    @httpQuery("level")
    level: String
}

/// Get index statistics
@http(method: "GET", uri: "/{index}/_stats")
@readonly
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

/// Get index aliases
@http(method: "GET", uri: "/{index}/_alias/{alias}")
@readonly
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

/// Update index aliases
@http(method: "POST", uri: "/_aliases")
operation UpdateAliases {
    input: UpdateAliasesInput
    output: UpdateAliasesResponse
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

/// Get cluster health
@http(method: "GET", uri: "/_cluster/health")
@readonly
operation GetClusterHealth {
    input: GetClusterHealthInput
    output: ClusterHealthResponse
}

/// HTTP-bound Cluster Stats Request
structure GetClusterStatsInput {
    @httpQuery("flat_settings")
    flatSettings: Boolean
}

/// Get cluster statistics
@http(method: "GET", uri: "/_cluster/stats")
@readonly
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

/// Update a document
@http(method: "POST", uri: "/{index}/_update/{id}")
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

/// Update documents matching a query
@http(method: "POST", uri: "/{index}/_update_by_query")
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

/// Execute bulk operations
@http(method: "POST", uri: "/_bulk")
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

/// Delete a document by ID
@http(method: "DELETE", uri: "/{index}/_doc/{id}")
@idempotent
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

/// Delete documents matching a query
@http(method: "POST", uri: "/{index}/_delete_by_query")
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

/// Create a snapshot repository
@http(method: "PUT", uri: "/_snapshot/{repository}")
@idempotent
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

/// Get snapshot repository information
@http(method: "GET", uri: "/_snapshot/{repository}")
@readonly
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

/// Delete a snapshot repository
@http(method: "DELETE", uri: "/_snapshot/{repository}")
@idempotent
operation DeleteRepository {
    input: DeleteRepositoryInput
    output: DeleteRepositoryResponse
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

/// Create a snapshot
@http(method: "PUT", uri: "/_snapshot/{repository}/{snapshot}")
@idempotent
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

/// Get snapshot information
@http(method: "GET", uri: "/_snapshot/{repository}/{snapshot}")
@readonly
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

/// Delete a snapshot
@http(method: "DELETE", uri: "/_snapshot/{repository}/{snapshot}")
@idempotent
operation DeleteSnapshot {
    input: DeleteSnapshotInput
    output: DeleteSnapshotResponse
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

/// Restore a snapshot
@http(method: "POST", uri: "/_snapshot/{repository}/{snapshot}/_restore")
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

/// Reindex documents from one index to another
@http(method: "POST", uri: "/_reindex")
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

/// Create or update an ingest pipeline
@http(method: "PUT", uri: "/_ingest/pipeline/{id}")
@idempotent
operation PutPipeline {
    input: PutPipelineInput
    output: PutPipelineResponse
}

/// HTTP-bound Get Pipeline Request
structure GetPipelineInput {
    @required
    @httpLabel
    id: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Get ingest pipeline
@http(method: "GET", uri: "/_ingest/pipeline/{id}")
@readonly
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

/// Delete an ingest pipeline
@http(method: "DELETE", uri: "/_ingest/pipeline/{id}")
@idempotent
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

/// Simulate an ingest pipeline
@http(method: "POST", uri: "/_ingest/pipeline/{id}/_simulate")
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

/// Create or update a stored script
@http(method: "PUT", uri: "/_scripts/{id}")
@idempotent
operation PutStoredScript {
    input: PutStoredScriptInput
    output: PutStoredScriptResponse
}

/// HTTP-bound Get Stored Script Request
structure GetStoredScriptInput {
    @required
    @httpLabel
    id: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Get a stored script
@http(method: "GET", uri: "/_scripts/{id}")
@readonly
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

/// Delete a stored script
@http(method: "DELETE", uri: "/_scripts/{id}")
@idempotent
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

/// List running tasks
@http(method: "GET", uri: "/_tasks")
@readonly
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

/// Get task information
@http(method: "GET", uri: "/_tasks/{taskId}")
@readonly
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

/// Cancel a running task
@http(method: "POST", uri: "/_tasks/{taskId}/_cancel")
operation CancelTask {
    input: CancelTaskInput
    output: CancelTaskResponse
}
