$version: "2"

namespace se.thanh.elastic4cats

use smithy4s.meta#bincompatFriendly

/// Request for indexing a document
@bincompatFriendly
structure IndexRequest {
    @required
    index: String

    id: String

    @required
    source: Document

    routing: String
    parent: String
    timeout: String
    version: Long
    versionType: VersionType
    pipeline: String
    refreshPolicy: RefreshPolicy
    waitForActiveShards: String
}

/// Response for index request
@bincompatFriendly
structure IndexResponse {
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

    created: Boolean
}
