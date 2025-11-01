$version: "2"

namespace se.thanh.elastic4cats

/// Elasticsearch Reindex Service
@title("Elasticsearch Reindex API")
service ElasticsearchReindexService {
    version: "9.0"
    operations: [
        Reindex
    ]
}

/// HTTP-bound Reindex Request
structure ReindexInput {
    @required
    @httpPayload
    body: Document

    @httpQuery("refresh")
    refresh: Boolean

    @httpQuery("wait_for_completion")
    waitForCompletion: Boolean

    @httpQuery("timeout")
    timeout: String

    @httpQuery("requests_per_second")
    requestsPerSecond: Float

    @httpQuery("slices")
    slices: String
}

/// Reindex documents from source to destination index
@http(method: "POST", uri: "/_reindex")
operation Reindex {
    input: ReindexInput
    output: ReindexResponse
}
