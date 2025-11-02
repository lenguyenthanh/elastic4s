$version: "2"

namespace se.thanh.elastic4cats

use smithy4s.meta#bincompatFriendly

/// Request for updating a document
@bincompatFriendly
structure UpdateRequest {
    @required
    index: String

    @required
    id: String

    doc: Document
    script: Script
    docAsUpsert: Boolean
    scripted_upsert: Boolean
    upsert: Document
    routing: String
    parent: String
    timeout: String
    retryOnConflict: Integer
    version: Long
    versionType: VersionType
    refreshPolicy: RefreshPolicy
    waitForActiveShards: String
    fetchSource: Boolean
    detectNoop: Boolean
}

/// Response for update request
@bincompatFriendly
structure UpdateResponse {
    @jsonName("_index")
    @required
    index: String

    @jsonName("_type")
    type: String

    @jsonName("_id")
    @required
    id: String

    @jsonName("_version")
    version: Long

    @required
    result: String

    @jsonName("_shards")
    shards: Shards

    @jsonName("_seq_no")
    seqNo: Long

    @jsonName("_primary_term")
    primaryTerm: Long

    get: UpdateGet
}

/// Get result embedded in update response
@bincompatFriendly
structure UpdateGet {
    @jsonName("_source")
    source: SourceMap

    found: Boolean
}

/// Request for update by query
@bincompatFriendly
structure UpdateByQueryRequest {
    @required
    indexes: StringList

    script: Script
    query: Document

    allowNoIndices: Boolean
    analyzeWildcard: Boolean
    conflicts: String
    defaultOperator: String
    df: String
    expandWildcards: String
    from: Integer
    ignoreUnavailable: Boolean
    lenient: Boolean
    pipeline: String
    preference: String
    requestCache: Boolean
    refresh: Boolean
    requestsPerSecond: Float
    routing: StringList
    scroll: String
    scrollSize: Integer
    searchTimeout: String
    searchType: String
    size: Integer
    slices: String
    sort: StringList
    stats: StringList
    terminateAfter: Long
    timeout: String
    version: Boolean
    versionConflict: String
    waitForActiveShards: String
    waitForCompletion: Boolean
}

/// Response for update by query
@bincompatFriendly
structure UpdateByQueryResponse {
    took: Long

    @jsonName("timed_out")
    timedOut: Boolean

    total: Long
    updated: Long
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

    failures: IndexFailureList
}
