$version: "2"

namespace se.thanh.elastic4cats

/// Elasticsearch Document Service
@title("Elasticsearch Document API")
service ElasticsearchDocumentService {
    version: "9.0"
    operations: [
        GetDocument
        MultiGetDocuments
        CountDocuments
        IndexDocument
    ]
}

/// HTTP-bound Get Document Request
structure GetDocumentInput {
    @required
    @httpLabel
    index: String

    @required
    @httpLabel
    id: String

    @httpQuery("routing")
    routing: String

    @httpQuery("preference")
    preference: String

    @httpQuery("refresh")
    refresh: Boolean

    @httpQuery("realtime")
    realtime: Boolean
}

/// Get a single document by ID
@http(method: "GET", uri: "/{index}/_doc/{id}")
@readonly
operation GetDocument {
    input: GetDocumentInput
    output: GetResponse
}

/// HTTP-bound MultiGet Request
structure MultiGetDocumentsInput {
    @required
    @httpPayload
    body: Document

    @httpQuery("preference")
    preference: String

    @httpQuery("refresh")
    refresh: Boolean

    @httpQuery("realtime")
    realtime: Boolean
}

/// Get multiple documents in a single request
@http(method: "POST", uri: "/_mget")
operation MultiGetDocuments {
    input: MultiGetDocumentsInput
    output: MultiGetResponse
}

/// HTTP-bound Count Request
structure CountDocumentsInput {
    @httpQuery("index")
    indexes: String

    @httpPayload
    body: Document
}

/// Count documents matching a query
@http(method: "POST", uri: "/_count")
operation CountDocuments {
    input: CountDocumentsInput
    output: CountResponse
}

/// HTTP-bound Index Document Request
structure IndexDocumentInput {
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

    @httpQuery("wait_for_active_shards")
    waitForActiveShards: String

    @httpQuery("pipeline")
    pipeline: String
}

/// Index a document
@http(method: "POST", uri: "/{index}/_doc/{id}")
operation IndexDocument {
    input: IndexDocumentInput
    output: IndexResponse
}
