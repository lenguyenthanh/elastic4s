$version: "2"

namespace se.thanh.elastic4cats

/// Bulk request containing multiple operations
structure BulkRequest {
    @required
    operations: BulkOperationList

    index: String
    timeout: String
    refreshPolicy: RefreshPolicy
    waitForActiveShards: String
    pipeline: String
    routing: String
}

/// A single bulk operation
union BulkOperation {
    index: BulkIndexOperation
    create: BulkCreateOperation
    update: BulkUpdateOperation
    delete: BulkDeleteOperation
}

/// Index operation in bulk request
structure BulkIndexOperation {
    @required
    index: String

    id: String

    @required
    source: Document

    routing: String
    version: Long
    versionType: String
    pipeline: String
}

/// Create operation in bulk request
structure BulkCreateOperation {
    @required
    index: String

    id: String

    @required
    source: Document

    routing: String
    version: Long
    versionType: String
    pipeline: String
}

/// Update operation in bulk request
structure BulkUpdateOperation {
    @required
    index: String

    @required
    id: String

    doc: Document
    script: Script
    docAsUpsert: Boolean
    upsert: Document
    routing: String
    version: Long
    versionType: String
}

/// Delete operation in bulk request
structure BulkDeleteOperation {
    @required
    index: String

    @required
    id: String

    routing: String
    version: Long
    versionType: String
}

/// Response for bulk request
structure BulkResponse {
    took: Long
    errors: Boolean
    items: BulkItemResponseList
}

/// Response for a single bulk item
structure BulkItemResponse {
    index: BulkItemResult
    create: BulkItemResult
    update: BulkItemResult
    delete: BulkItemResult
}

/// Result of a bulk item operation
structure BulkItemResult {
    @jsonName("_index")
    index: String

    @jsonName("_type")
    type: String

    @jsonName("_id")
    id: String

    @jsonName("_version")
    version: Long

    result: String

    @jsonName("_shards")
    shards: Shards

    @jsonName("_seq_no")
    seqNo: Long

    @jsonName("_primary_term")
    primaryTerm: Long

    status: Integer
    error: BulkError
}

/// Error information for failed bulk items
structure BulkError {
    type: String
    reason: String

    @jsonName("index_uuid")
    indexUuid: String

    shard: String
    index: String
}

list BulkOperationList {
    member: BulkOperation
}

list BulkItemResponseList {
    member: BulkItemResponse
}
