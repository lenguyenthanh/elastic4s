$version: "2"

namespace se.thanh.elastic4cats

/// Elasticsearch Delete Operations Service
@title("Elasticsearch Delete API")
service ElasticsearchDeleteService {
    version: "9.0"
    operations: [
        DeleteDocument
        DeleteByQuery
    ]
}

/// HTTP-bound Delete Document Request
structure DeleteDocumentInput {
    @required
    @httpLabel
    index: String

    @required
    @httpLabel
    id: String

    @httpQuery("routing")
    routing: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("refresh")
    refresh: String

    @httpQuery("wait_for_active_shards")
    waitForActiveShards: String

    @httpQuery("version")
    version: Long

    @httpQuery("version_type")
    versionType: String
}

/// Delete a document by ID
@http(method: "DELETE", uri: "/{index}/_doc/{id}")
@idempotent
operation DeleteDocument {
    input: DeleteDocumentInput
    output: DeleteResponse
}

/// HTTP-bound Delete By Query Request
structure DeleteByQueryInput {
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

/// Delete documents by query
@http(method: "POST", uri: "/{index}/_delete_by_query")
operation DeleteByQuery {
    input: DeleteByQueryInput
    output: DeleteByQueryResponse
}
