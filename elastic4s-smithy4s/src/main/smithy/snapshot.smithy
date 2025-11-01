$version: "2"

namespace se.thanh.elastic4cats

/// Request to create a snapshot repository
structure CreateRepositoryRequest {
    @required
    repositoryName: String

    @required
    type: String

    settings: RepositorySettings
    verify: Boolean
    timeout: String
    masterTimeout: String
}

/// Repository settings
structure RepositorySettings {
    location: String
    compress: Boolean
    chunkSize: String
    maxRestoreBytesPerSec: String
    maxSnapshotBytesPerSec: String
    readonly: Boolean
}

/// Request to get repository
structure GetRepositoryRequest {
    @required
    repositoryName: String

    local: Boolean
    masterTimeout: String
}

/// Request to delete repository
structure DeleteRepositoryRequest {
    @required
    repositoryName: String

    timeout: String
    masterTimeout: String
}

/// Request to create a snapshot
structure CreateSnapshotRequest {
    @required
    snapshotName: String

    @required
    repositoryName: String

    indices: StringList
    ignoreUnavailable: Boolean
    waitForCompletion: Boolean
    partial: Boolean
    includeGlobalState: Boolean
}

/// Request to get snapshots
structure GetSnapshotsRequest {
    @required
    snapshotNames: StringList

    @required
    repositoryName: String

    ignoreUnavailable: Boolean
    verbose: Boolean
}

/// Response for get snapshots
structure GetSnapshotsResponse {
    snapshots: SnapshotList
}

/// Snapshot information
structure SnapshotInfo {
    snapshot: String
    uuid: String
    versionId: Integer
    version: String
    indices: StringList
    state: String
    startTime: String
    startTimeInMillis: Long
    endTime: String
    endTimeInMillis: Long
    durationInMillis: Long
    failures: SnapshotFailureList
    shards: SnapshotShardStats
}

/// Snapshot shard statistics
structure SnapshotShardStats {
    total: Integer
    successful: Integer
    failed: Integer
}

/// Snapshot failure
structure SnapshotFailure {
    index: String
    shardId: Integer
    reason: String
    nodeId: String
}

/// Request to delete a snapshot
structure DeleteSnapshotRequest {
    @required
    snapshotName: String

    @required
    repositoryName: String

    timeout: String
    masterTimeout: String
}

/// Request to restore a snapshot
structure RestoreSnapshotRequest {
    @required
    snapshotName: String

    @required
    repositoryName: String

    indices: StringList
    ignoreUnavailable: Boolean
    includeGlobalState: Boolean
    renamePattern: String
    renameReplacement: String
    includeAliases: Boolean
    indexSettings: SnapshotIndexSettings
    ignoreIndexSettings: StringList
    partial: Boolean
    waitForCompletion: Boolean
}

/// Index settings for restore
structure SnapshotIndexSettings {
    numberOfShards: Integer
    numberOfReplicas: Integer
}

list SnapshotList {
    member: SnapshotInfo
}

list SnapshotFailureList {
    member: SnapshotFailure
}
