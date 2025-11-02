$version: "2"

namespace se.thanh.elastic4cats

use smithy4s.meta#bincompatFriendly

/// Request to get cluster health
@bincompatFriendly
structure ClusterHealthRequest {
    indices: StringList
    level: String
    local: Boolean
    masterTimeout: String
    timeout: String
    waitForActiveShards: String
    waitForEvents: String
    waitForNoInitializingShards: Boolean
    waitForNoRelocatingShards: Boolean
    waitForNodes: String
    waitForStatus: HealthStatus
}

/// Response for cluster health
@bincompatFriendly
structure ClusterHealthResponse {
    @jsonName("cluster_name")
    clusterName: String

    status: HealthStatus

    @jsonName("timed_out")
    timedOut: Boolean

    @jsonName("number_of_nodes")
    numberOfNodes: Integer

    @jsonName("number_of_data_nodes")
    numberOfDataNodes: Integer

    @jsonName("active_primary_shards")
    activePrimaryShards: Integer

    @jsonName("active_shards")
    activeShards: Integer

    @jsonName("relocating_shards")
    relocatingShards: Integer

    @jsonName("initializing_shards")
    initializingShards: Integer

    @jsonName("unassigned_shards")
    unassignedShards: Integer

    @jsonName("delayed_unassigned_shards")
    delayedUnassignedShards: Integer

    @jsonName("number_of_pending_tasks")
    numberOfPendingTasks: Integer

    @jsonName("number_of_in_flight_fetch")
    numberOfInFlightFetch: Integer

    @jsonName("task_max_waiting_in_queue_millis")
    taskMaxWaitingInQueueMillis: Long

    @jsonName("active_shards_percent_as_number")
    activeShardsPercentAsNumber: Double

    indices: ClusterIndexHealthMap
}

/// Cluster index health
@bincompatFriendly
structure ClusterIndexHealth {
    status: HealthStatus

    @jsonName("number_of_shards")
    numberOfShards: Integer

    @jsonName("number_of_replicas")
    numberOfReplicas: Integer

    @jsonName("active_primary_shards")
    activePrimaryShards: Integer

    @jsonName("active_shards")
    activeShards: Integer

    @jsonName("relocating_shards")
    relocatingShards: Integer

    @jsonName("initializing_shards")
    initializingShards: Integer

    @jsonName("unassigned_shards")
    unassignedShards: Integer
}

/// Request to get cluster state
@bincompatFriendly
structure ClusterStateRequest {
    indices: StringList
    metrics: StringList
    local: Boolean
    masterTimeout: String
    flatSettings: Boolean
    ignoreUnavailable: Boolean
    allowNoIndices: Boolean
    expandWildcards: String
}

/// Request to get cluster stats
@bincompatFriendly
structure ClusterStatsRequest {
    nodeIds: StringList
    flatSettings: Boolean
    timeout: String
}

/// Response for cluster stats
@bincompatFriendly
structure ClusterStatsResponse {
    @jsonName("cluster_name")
    clusterName: String

    @jsonName("cluster_uuid")
    clusterUuid: String

    timestamp: Long
    status: HealthStatus
    indices: ClusterIndicesStats
    nodes: ClusterNodesStats
}

/// Cluster indices statistics
@bincompatFriendly
structure ClusterIndicesStats {
    count: Integer
    shards: ClusterShardsStats
    docs: ClusterDocsStats
    store: ClusterStoreStats
}

/// Cluster shards statistics
@bincompatFriendly
structure ClusterShardsStats {
    total: Integer
    primaries: Integer
    replication: Double
    index: ClusterShardIndexStats
}

/// Cluster shard index statistics
@bincompatFriendly
structure ClusterShardIndexStats {
    shards: ClusterShardStats
    primaries: ClusterShardStats
    replication: ClusterShardReplicationStats
}

/// Cluster shard statistics
@bincompatFriendly
structure ClusterShardStats {
    min: Integer
    max: Integer
    avg: Double
}

/// Cluster shard replication statistics
@bincompatFriendly
structure ClusterShardReplicationStats {
    min: Double
    max: Double
    avg: Double
}

/// Cluster docs statistics
@bincompatFriendly
structure ClusterDocsStats {
    count: Long
    deleted: Long
}

/// Cluster store statistics
@bincompatFriendly
structure ClusterStoreStats {
    @jsonName("size_in_bytes")
    sizeInBytes: Long
}

/// Cluster nodes statistics
@bincompatFriendly
structure ClusterNodesStats {
    count: ClusterNodeCounts
    versions: StringList
    os: ClusterOsStats
    process: ClusterProcessStats
    jvm: ClusterJvmStats
    fs: ClusterFsStats
    plugins: PluginInfoList
}

/// Cluster node counts
@bincompatFriendly
structure ClusterNodeCounts {
    total: Integer
    data: Integer

    @jsonName("coordinating_only")
    coordinatingOnly: Integer

    master: Integer
    ingest: Integer
}

/// Cluster OS statistics
@bincompatFriendly
structure ClusterOsStats {
    @jsonName("available_processors")
    availableProcessors: Integer

    @jsonName("allocated_processors")
    allocatedProcessors: Integer

    names: OsNameList
    mem: ClusterOsMemStats
}

/// OS name count
@bincompatFriendly
structure OsNameCount {
    name: String
    count: Integer
}

/// Cluster OS memory statistics
@bincompatFriendly
structure ClusterOsMemStats {
    @jsonName("total_in_bytes")
    totalInBytes: Long

    @jsonName("free_in_bytes")
    freeInBytes: Long

    @jsonName("used_in_bytes")
    usedInBytes: Long

    @jsonName("free_percent")
    freePercent: Integer

    @jsonName("used_percent")
    usedPercent: Integer
}

/// Cluster process statistics
@bincompatFriendly
structure ClusterProcessStats {
    cpu: ClusterProcessCpuStats

    @jsonName("open_file_descriptors")
    openFileDescriptors: ClusterProcessFileDescriptorStats
}

/// Cluster process CPU statistics
@bincompatFriendly
structure ClusterProcessCpuStats {
    percent: Integer
}

/// Cluster process file descriptor statistics
@bincompatFriendly
structure ClusterProcessFileDescriptorStats {
    min: Long
    max: Long
    avg: Long
}

/// Cluster JVM statistics
@bincompatFriendly
structure ClusterJvmStats {
    @jsonName("max_uptime_in_millis")
    maxUptimeInMillis: Long

    versions: JvmVersionList
    mem: ClusterJvmMemStats
    threads: Long
}

/// JVM version count
@bincompatFriendly
structure JvmVersionCount {
    version: String

    @jsonName("vm_name")
    vmName: String

    @jsonName("vm_version")
    vmVersion: String

    @jsonName("vm_vendor")
    vmVendor: String

    count: Integer
}

/// Cluster JVM memory statistics
@bincompatFriendly
structure ClusterJvmMemStats {
    @jsonName("heap_used_in_bytes")
    heapUsedInBytes: Long

    @jsonName("heap_max_in_bytes")
    heapMaxInBytes: Long
}

/// Cluster filesystem statistics
@bincompatFriendly
structure ClusterFsStats {
    @jsonName("total_in_bytes")
    totalInBytes: Long

    @jsonName("free_in_bytes")
    freeInBytes: Long

    @jsonName("available_in_bytes")
    availableInBytes: Long
}

/// Plugin information
@bincompatFriendly
structure PluginInfo {
    name: String
    version: String
    description: String
    classname: String
}

list OsNameList {
    member: OsNameCount
}

list JvmVersionList {
    member: JvmVersionCount
}

list PluginInfoList {
    member: PluginInfo
}

map ClusterIndexHealthMap {
    key: String
    value: ClusterIndexHealth
}
