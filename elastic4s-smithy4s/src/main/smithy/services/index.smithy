$version: "2"

namespace se.thanh.elastic4cats

/// Elasticsearch Index Management Service
@title("Elasticsearch Index Management API")
service ElasticsearchIndexService {
    version: "9.0"
    operations: [
        CreateIndex
        DeleteIndex
        OpenIndex
        CloseIndex
        RefreshIndex
        FlushIndex
        GetIndexStats
        GetAliases
        UpdateAliases
    ]
}

/// HTTP-bound Create Index Request
structure CreateIndexInput {
    @required
    @httpLabel
    index: String

    @httpPayload
    body: Document
}

/// Create an index
@http(method: "PUT", uri: "/{index}")
@idempotent
operation CreateIndex {
    input: CreateIndexInput
}

/// HTTP-bound Delete Index Request
structure DeleteIndexInput {
    @required
    @httpLabel
    index: String
}

/// Delete an index
@http(method: "DELETE", uri: "/{index}")
@idempotent
operation DeleteIndex {
    input: DeleteIndexInput
    output: DeleteIndexResponse
}

/// HTTP-bound Open Index Request
structure OpenIndexInput {
    @required
    @httpLabel
    index: String
}

/// Open a closed index
@http(method: "POST", uri: "/{index}/_open")
operation OpenIndex {
    input: OpenIndexInput
    output: OpenIndexResponse
}

/// HTTP-bound Close Index Request
structure CloseIndexInput {
    @required
    @httpLabel
    index: String
}

/// Close an index
@http(method: "POST", uri: "/{index}/_close")
operation CloseIndex {
    input: CloseIndexInput
    output: CloseIndexResponse
}

/// HTTP-bound Refresh Index Request
structure RefreshIndexInput {
    @required
    @httpLabel
    index: String
}

/// Refresh an index
@http(method: "POST", uri: "/{index}/_refresh")
operation RefreshIndex {
    input: RefreshIndexInput
}

/// HTTP-bound Flush Index Request
structure FlushIndexInput {
    @required
    @httpLabel
    index: String
}

/// Flush an index
@http(method: "POST", uri: "/{index}/_flush")
operation FlushIndex {
    input: FlushIndexInput
}

/// HTTP-bound Index Stats Request
structure GetIndexStatsInput {
    @required
    @httpLabel
    index: String

    @httpQuery("metric")
    metric: String
}

/// Get index statistics
@http(method: "GET", uri: "/{index}/_stats")
@readonly
operation GetIndexStats {
    input: GetIndexStatsInput
    output: IndexStatsResponse
}

/// HTTP-bound Get Aliases Request
structure GetAliasesInput {
    @required
    @httpLabel
    index: String

    @required
    @httpLabel
    alias: String
}

/// Get index aliases
@http(method: "GET", uri: "/{index}/_alias/{alias}")
@readonly
operation GetAliases {
    input: GetAliasesInput
    output: GetAliasesResponse
}

/// HTTP-bound Update Aliases Request
structure UpdateAliasesInput {
    @required
    @httpPayload
    body: Document
}

/// Update index aliases
@http(method: "POST", uri: "/_aliases")
operation UpdateAliases {
    input: UpdateAliasesInput
    output: IndicesAliasesResponse
}
