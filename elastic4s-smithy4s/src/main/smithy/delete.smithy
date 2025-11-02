$version: "2"

namespace se.thanh.elastic4cats

use smithy4s.meta#bincompatFriendly

/// Request for deleting a document by ID
@bincompatFriendly
structure DeleteByIdRequest {
    @required
    index: String

    @required
    id: String

    parent: String
    routing: String
    timeout: String
    version: Long
    versionType: VersionType
    waitForActiveShards: String
    refreshPolicy: RefreshPolicy
}

/// Request for deleting documents by query
@bincompatFriendly
structure DeleteByQueryRequest {
    @required
    indexes: StringList

    @required
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
    waitForActiveShards: String
    waitForCompletion: Boolean
}

/// Response for delete by ID request
@bincompatFriendly
structure DeleteResponse {
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
}

/// Response for delete by query request
@bincompatFriendly
structure DeleteByQueryResponse {
    took: Long

    @jsonName("timed_out")
    timedOut: Boolean

    total: Long
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
