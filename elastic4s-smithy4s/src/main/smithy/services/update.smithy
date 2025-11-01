$version: "2"

namespace se.thanh.elastic4cats

/// Elasticsearch Update Service
@title("Elasticsearch Update API")
service ElasticsearchUpdateService {
    version: "9.0"
    operations: [
        UpdateDocument
        UpdateByQuery
    ]
}

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

    @httpQuery("_source")
    fetchSource: Boolean
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

    @httpQuery("timeout")
    timeout: String
}

/// Update documents by query
@http(method: "POST", uri: "/{index}/_update_by_query")
operation UpdateByQuery {
    input: UpdateByQueryInput
    output: UpdateByQueryResponse
}
