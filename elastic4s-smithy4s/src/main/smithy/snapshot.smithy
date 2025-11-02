$version: "2"

namespace se.thanh.elastic4cats

use smithy4s.meta#bincompatFriendly

/// Request to create a snapshot repository
@bincompatFriendly
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
@bincompatFriendly
structure RepositorySettings {
    location: String
    compress: Boolean
    chunkSize: String
    maxRestoreBytesPerSec: String
    maxSnapshotBytesPerSec: String
    readonly: Boolean
}

/// Request to get repository
@bincompatFriendly
structure GetRepositoryRequest {
    @required
    repositoryName: String

    local: Boolean
    masterTimeout: String
}

/// Request to delete repository
@bincompatFriendly
structure DeleteRepositoryRequest {
    @required
    repositoryName: String

    timeout: String
    masterTimeout: String
}

/// Request to create a snapshot
@bincompatFriendly
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
@bincompatFriendly
structure GetSnapshotsRequest {
    @required
    snapshotNames: StringList

    @required
    repositoryName: String

    ignoreUnavailable: Boolean
    verbose: Boolean
}

/// Response for get snapshots
@bincompatFriendly
structure GetSnapshotsResponse {
    snapshots: SnapshotList
}

/// Snapshot information
@bincompatFriendly
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
@bincompatFriendly
structure SnapshotShardStats {
    total: Integer
    successful: Integer
    failed: Integer
}

/// Snapshot failure
@bincompatFriendly
structure SnapshotFailure {
    index: String
    shardId: Integer
    reason: String
    nodeId: String
}

/// Request to delete a snapshot
@bincompatFriendly
structure DeleteSnapshotRequest {
    @required
    snapshotName: String

    @required
    repositoryName: String

    timeout: String
    masterTimeout: String
}

/// Request to restore a snapshot
@bincompatFriendly
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
@bincompatFriendly
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

/// Response for get repository
@bincompatFriendly
structure GetRepositoryResponse {
    repositories: RepositoryMap
}

/// Repository information
@bincompatFriendly
structure RepositoryInfo {
    type: String
    settings: RepositorySettings
}

map RepositoryMap {
    key: String
    value: RepositoryInfo
}

/// Response for create snapshot
@bincompatFriendly
structure CreateSnapshotResponse {
    snapshot: SnapshotInfo
}

/// Response for get snapshot  
@bincompatFriendly
structure GetSnapshotResponse {
    snapshots: SnapshotList
}

/// Response for restore snapshot
@bincompatFriendly
structure RestoreSnapshotResponse {
    snapshot: RestoreSnapshotInfo
}

/// Restore snapshot information
@bincompatFriendly
structure RestoreSnapshotInfo {
    snapshot: String
    indices: StringList
    shards: SnapshotShardStats
}
