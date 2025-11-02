$version: "2"

namespace se.thanh.elastic4cats

use smithy4s.meta#bincompatFriendly

/// Request for counting documents
@bincompatFriendly
structure CountRequest {
    @required
    indexes: StringList
    query: Document
    allowNoIndices: Boolean
    analyzeWildcard: Boolean
    expandWildcards: String
    ignoreUnavailable: Boolean
    ignoreThrottled: Boolean
    lenient: Boolean
    routing: String
    terminateAfter: Integer
    minScore: Double
}

/// Response for count request
@bincompatFriendly
structure CountResponse {
    @required
    count: Long
}
