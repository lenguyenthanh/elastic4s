$version: "2"

namespace se.thanh.elastic4cats

/// Elasticsearch Snapshot and Restore Service
@title("Elasticsearch Snapshot and Restore API")
service ElasticsearchSnapshotService {
    version: "9.0"
    operations: [
        CreateRepository
        GetRepository
        DeleteRepository
        CreateSnapshot
        GetSnapshot
        DeleteSnapshot
        RestoreSnapshot
    ]
}

/// HTTP-bound Create Repository Request
structure CreateRepositoryInput {
    @required
    @httpLabel
    repository: String

    @required
    @httpPayload
    body: Document

    @httpQuery("verify")
    verify: Boolean

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Create a snapshot repository
@http(method: "PUT", uri: "/_snapshot/{repository}")
@idempotent
operation CreateRepository {
    input: CreateRepositoryInput
}

/// HTTP-bound Get Repository Request
structure GetRepositoryInput {
    @required
    @httpLabel
    repository: String

    @httpQuery("local")
    local: Boolean

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Get snapshot repository information
@http(method: "GET", uri: "/_snapshot/{repository}")
@readonly
operation GetRepository {
    input: GetRepositoryInput
    output: GetRepositoryResponse
}

/// HTTP-bound Delete Repository Request
structure DeleteRepositoryInput {
    @required
    @httpLabel
    repository: String

    @httpQuery("timeout")
    timeout: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Delete a snapshot repository
@http(method: "DELETE", uri: "/_snapshot/{repository}")
@idempotent
operation DeleteRepository {
    input: DeleteRepositoryInput
}

/// HTTP-bound Create Snapshot Request
structure CreateSnapshotInput {
    @required
    @httpLabel
    repository: String

    @required
    @httpLabel
    snapshot: String

    @httpPayload
    body: Document

    @httpQuery("wait_for_completion")
    waitForCompletion: Boolean

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Create a snapshot
@http(method: "PUT", uri: "/_snapshot/{repository}/{snapshot}")
@idempotent
operation CreateSnapshot {
    input: CreateSnapshotInput
    output: CreateSnapshotResponse
}

/// HTTP-bound Get Snapshot Request
structure GetSnapshotInput {
    @required
    @httpLabel
    repository: String

    @required
    @httpLabel
    snapshot: String

    @httpQuery("ignore_unavailable")
    ignoreUnavailable: Boolean

    @httpQuery("verbose")
    verbose: Boolean
}

/// Get snapshot information
@http(method: "GET", uri: "/_snapshot/{repository}/{snapshot}")
@readonly
operation GetSnapshot {
    input: GetSnapshotInput
    output: GetSnapshotResponse
}

/// HTTP-bound Delete Snapshot Request
structure DeleteSnapshotInput {
    @required
    @httpLabel
    repository: String

    @required
    @httpLabel
    snapshot: String

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Delete a snapshot
@http(method: "DELETE", uri: "/_snapshot/{repository}/{snapshot}")
@idempotent
operation DeleteSnapshot {
    input: DeleteSnapshotInput
}

/// HTTP-bound Restore Snapshot Request
structure RestoreSnapshotInput {
    @required
    @httpLabel
    repository: String

    @required
    @httpLabel
    snapshot: String

    @httpPayload
    body: Document

    @httpQuery("wait_for_completion")
    waitForCompletion: Boolean

    @httpQuery("master_timeout")
    masterTimeout: String
}

/// Restore a snapshot
@http(method: "POST", uri: "/_snapshot/{repository}/{snapshot}/_restore")
operation RestoreSnapshot {
    input: RestoreSnapshotInput
    output: RestoreSnapshotResponse
}
