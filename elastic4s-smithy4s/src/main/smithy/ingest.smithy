$version: "2"

namespace se.thanh.elastic4cats

/// Request to create or update an ingest pipeline
structure PutPipelineRequest {
    @required
    id: String

    @required
    description: String

    @required
    processors: ProcessorList

    onFailure: ProcessorList
    version: Integer
    timeout: String
    masterTimeout: String
}

/// Ingest processor
structure Processor {
    type: String
    field: String
    targetField: String
    ignoreFailure: Boolean
    onFailure: ProcessorList
    if: String
    tag: String

    /// Additional processor-specific configuration
    config: ProcessorConfig
}

/// Request to get pipeline
structure GetPipelineRequest {
    @required
    id: String

    masterTimeout: String
}

/// Response for get pipeline
structure GetPipelineResponse {
    pipelines: PipelineMap
}

/// Pipeline information
structure PipelineInfo {
    description: String
    processors: ProcessorList
    version: Integer
}

/// Request to delete pipeline
structure DeletePipelineRequest {
    @required
    id: String

    timeout: String
    masterTimeout: String
}

/// Response for delete pipeline
structure DeletePipelineResponse {
    acknowledged: Boolean
}

/// Request to simulate pipeline
structure SimulatePipelineRequest {
    @required
    id: String

    @required
    docs: SimulateDocList

    verbose: Boolean
}

/// Simulate document
structure SimulateDoc {
    @jsonName("_index")
    index: String

    @jsonName("_id")
    id: String

    @jsonName("_source")
    source: Document
}

/// Response for simulate pipeline
structure SimulatePipelineResponse {
    docs: SimulateResultList
}

/// Simulate result
structure SimulateResult {
    doc: SimulateDoc

    @jsonName("processor_results")
    processorResults: ProcessorResultList

    error: IngestError
}

/// Processor result
structure ProcessorResult {
    @jsonName("processor_type")
    processorType: String

    status: String
    doc: SimulateDoc
    error: IngestError
}

/// Ingest error
structure IngestError {
    type: String
    reason: String

    @jsonName("caused_by")
    causedBy: IngestError
}

list ProcessorList {
    member: Processor
}

list SimulateDocList {
    member: SimulateDoc
}

list SimulateResultList {
    member: SimulateResult
}

list ProcessorResultList {
    member: ProcessorResult
}

map PipelineMap {
    key: String
    value: PipelineInfo
}

map ProcessorConfig {
    key: String
    value: Document
}
