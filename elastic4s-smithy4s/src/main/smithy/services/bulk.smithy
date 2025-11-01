$version: "2"

namespace se.thanh.elastic4cats

/// Elasticsearch Bulk Operations Service
@title("Elasticsearch Bulk API")
service ElasticsearchBulkService {
    version: "9.0"
    operations: [
        BulkOperations
    ]
}

/// HTTP-bound Bulk Request
structure BulkOperationsInput {
    @required
    @httpPayload
    body: Document

    @httpQuery("index")
    index: String

    @httpQuery("refresh")
    refresh: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("wait_for_active_shards")
    waitForActiveShards: String

    @httpQuery("pipeline")
    pipeline: String

    @httpQuery("routing")
    routing: String
}

/// Perform multiple index/update/delete operations in a single request
@http(method: "POST", uri: "/_bulk")
operation BulkOperations {
    input: BulkOperationsInput
    output: BulkResponse
}
