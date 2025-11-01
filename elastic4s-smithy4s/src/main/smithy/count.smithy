$version: "2"

namespace se.thanh.elastic4cats

/// Request for counting documents
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
structure CountResponse {
    @required
    count: Long
}
