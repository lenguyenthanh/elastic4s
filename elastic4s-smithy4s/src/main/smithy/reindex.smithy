$version: "2"

namespace com.sksamuel.elastic4s.smithy.reindex

use com.sksamuel.elastic4s.smithy.common#StringList
use com.sksamuel.elastic4s.smithy.common#RefreshPolicy
use com.sksamuel.elastic4s.smithy.common#VersionType

/// Request to reindex documents
structure ReindexRequest {
    @required
    sourceIndexes: StringList
    
    @required
    targetIndex: String
    
    filter: Document
    requestsPerSecond: Float
    refresh: RefreshPolicy
    maxRetries: Integer
    waitForCompletion: Boolean
    waitForActiveShards: Integer
    timeout: String
    retryBackoffInitialTime: String
    shouldStoreResult: Boolean
    proceedOnConflicts: Boolean
    remoteHost: String
    remoteUser: String
    remotePass: String
    maxDocs: Integer
    script: Script
    scroll: String
    size: Integer
    createOnly: Boolean
    slices: Integer
    slice: Slice
    versionType: VersionType
    pipeline: String
}

/// Script for reindex operations
structure Script {
    @required
    source: String
    
    lang: String
    params: ScriptParams
}

/// Slice for parallel reindexing
structure Slice {
    @required
    id: Integer
    
    @required
    max: Integer
}

/// Response for reindex request
structure ReindexResponse {
    took: Long
    
    @jsonName("timed_out")
    timedOut: Boolean
    
    total: Long
    updated: Long
    created: Long
    deleted: Long
    batches: Integer
    
    @jsonName("version_conflicts")
    versionConflicts: Long
    
    noops: Long
    
    retries: Retries
    
    @jsonName("throttled_millis")
    throttledMillis: Long
    
    @jsonName("requests_per_second")
    requestsPerSecond: Float
    
    @jsonName("throttled_until_millis")
    throttledUntilMillis: Long
    
    failures: FailureList
}

/// Retry information
structure Retries {
    bulk: Integer
    search: Integer
}

/// Failure information
structure Failure {
    index: String
    type: String
    id: String
    cause: FailureCause
    status: Integer
}

/// Failure cause
structure FailureCause {
    type: String
    reason: String
}

list FailureList {
    member: Failure
}

map ScriptParams {
    key: String
    value: Document
}
