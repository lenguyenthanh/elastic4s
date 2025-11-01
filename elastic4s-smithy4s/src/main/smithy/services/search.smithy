$version: "2"

namespace se.thanh.elastic4cats

/// Elasticsearch Search Service
@title("Elasticsearch Search API")
service ElasticsearchSearchService {
    version: "9.0"
    operations: [
        Search
        SearchScroll
        ClearScroll
    ]
}

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

list StringList {
    member: String
}
