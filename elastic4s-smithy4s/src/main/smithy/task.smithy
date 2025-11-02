$version: "2"

namespace se.thanh.elastic4cats

use smithy4s.meta#bincompatFriendly

/// Request to list tasks
@bincompatFriendly
structure ListTasksRequest {
    actions: StringList
    nodes: StringList
    detailed: Boolean
    waitForCompletion: Boolean
    timeout: String
    groupBy: String
}

/// Response for list tasks
@bincompatFriendly
structure ListTasksResponse {
    nodes: TaskNodeMap
}

/// Task node information
@bincompatFriendly
structure TaskNode {
    name: String

    @jsonName("transport_address")
    transportAddress: String

    host: String
    ip: String
    roles: StringList
    tasks: TaskMap
}

/// Task information
@bincompatFriendly
structure TaskInfo {
    node: String
    id: Long
    type: String
    action: String

    @jsonName("start_time_in_millis")
    startTimeInMillis: Long

    @jsonName("running_time_in_nanos")
    runningTimeInNanos: Long

    cancellable: Boolean
    description: String
    headers: HeaderMap
}

/// Request to get a task
@bincompatFriendly
structure GetTaskRequest {
    @required
    taskId: String

    waitForCompletion: Boolean
    timeout: String
}

/// Response for get task
@bincompatFriendly
structure GetTaskResponse {
    completed: Boolean
    task: TaskInfo
    response: TaskResponse
    error: TaskError
}

/// Task response
@bincompatFriendly
structure TaskResponse {
    took: Long

    @jsonName("timed_out")
    timedOut: Boolean

    total: Long
    updated: Long
    created: Long
    deleted: Long
    batches: Integer

    @jsonName("version_conflicts")
    versionConflicts: Long

    noops: Long
    failures: IndexFailureList
}

/// Task error
@bincompatFriendly
structure TaskError {
    type: String
    reason: String
}

/// Request to cancel a task
@bincompatFriendly
structure CancelTaskRequest {
    @required
    taskId: String

    waitForCompletion: Boolean
}

/// Response for cancel task
@bincompatFriendly
structure CancelTaskResponse {
    nodes: TaskNodeMap
}

map TaskNodeMap {
    key: String
    value: TaskNode
}

map TaskMap {
    key: String
    value: TaskInfo
}

map HeaderMap {
    key: String
    value: String
}
