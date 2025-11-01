$version: "2"

namespace com.sksamuel.elastic4s.smithy.count

use com.sksamuel.elastic4s.smithy.common#StringList

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
