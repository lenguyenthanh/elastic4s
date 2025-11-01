$version: "2"

namespace se.thanh.elastic4cats

/// Elasticsearch Script Management Service
@title("Elasticsearch Script API")
service ElasticsearchScriptService {
    version: "9.0"
    operations: [
        PutStoredScript
        GetStoredScript
        DeleteStoredScript
    ]
}

/// HTTP-bound Put Stored Script Request
structure PutStoredScriptInput {
    @required
    @httpLabel
    id: String

    @required
    @httpPayload
    body: Document

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String

    @httpQuery("context")
    context: String
}

/// Create or update a stored script
@http(method: "PUT", uri: "/_scripts/{id}")
@idempotent
operation PutStoredScript {
    input: PutStoredScriptInput
}

/// HTTP-bound Get Stored Script Request
structure GetStoredScriptInput {
    @required
    @httpLabel
    id: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Get a stored script
@http(method: "GET", uri: "/_scripts/{id}")
@readonly
operation GetStoredScript {
    input: GetStoredScriptInput
    output: GetStoredScriptResponse
}

/// HTTP-bound Delete Stored Script Request
structure DeleteStoredScriptInput {
    @required
    @httpLabel
    id: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Delete a stored script
@http(method: "DELETE", uri: "/_scripts/{id}")
@idempotent
operation DeleteStoredScript {
    input: DeleteStoredScriptInput
}
