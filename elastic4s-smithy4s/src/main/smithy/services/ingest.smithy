$version: "2"

namespace se.thanh.elastic4cats

/// Elasticsearch Ingest Pipeline Service
@title("Elasticsearch Ingest Pipeline API")
service ElasticsearchIngestService {
    version: "9.0"
    operations: [
        PutPipeline
        GetPipeline
        DeletePipeline
        SimulatePipeline
    ]
}

/// HTTP-bound Put Pipeline Request
structure PutPipelineInput {
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
}

/// Create or update an ingest pipeline
@http(method: "PUT", uri: "/_ingest/pipeline/{id}")
@idempotent
operation PutPipeline {
    input: PutPipelineInput
}

/// HTTP-bound Get Pipeline Request
structure GetPipelineInput {
    @required
    @httpLabel
    id: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Get an ingest pipeline
@http(method: "GET", uri: "/_ingest/pipeline/{id}")
@readonly
operation GetPipeline {
    input: GetPipelineInput
    output: GetPipelineResponse
}

/// HTTP-bound Delete Pipeline Request
structure DeletePipelineInput {
    @required
    @httpLabel
    id: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Delete an ingest pipeline
@http(method: "DELETE", uri: "/_ingest/pipeline/{id}")
@idempotent
operation DeletePipeline {
    input: DeletePipelineInput
}

/// HTTP-bound Simulate Pipeline Request
structure SimulatePipelineInput {
    @required
    @httpLabel
    id: String

    @required
    @httpPayload
    body: Document

    @httpQuery("verbose")
    verbose: Boolean
}

/// Simulate an ingest pipeline
@http(method: "POST", uri: "/_ingest/pipeline/{id}/_simulate")
operation SimulatePipeline {
    input: SimulatePipelineInput
    output: SimulatePipelineResponse
}
