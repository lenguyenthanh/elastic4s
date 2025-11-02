$version: "2"

namespace se.thanh.elastic4cats

use smithy4s.meta#bincompatFriendly

/// Request to reindex documents
@bincompatFriendly
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

/// Slice for parallel reindexing
@bincompatFriendly
structure Slice {
    @required
    id: Integer

    @required
    max: Integer
}

/// Response for reindex request
@bincompatFriendly
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

    failures: IndexFailureList
}
