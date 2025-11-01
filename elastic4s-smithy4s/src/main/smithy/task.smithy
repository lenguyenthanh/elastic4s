$version: "2"

namespace se.thanh.elastic4cats

/// Request to list tasks
structure ListTasksRequest {
    actions: StringList
    nodes: StringList
    detailed: Boolean
    waitForCompletion: Boolean
    timeout: String
    groupBy: String
}

/// Response for list tasks
structure ListTasksResponse {
    nodes: TaskNodeMap
}

/// Task node information
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
structure GetTaskRequest {
    @required
    taskId: String

    waitForCompletion: Boolean
    timeout: String
}

/// Response for get task
structure GetTaskResponse {
    completed: Boolean
    task: TaskInfo
    response: TaskResponse
    error: TaskError
}

/// Task response
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
structure TaskError {
    type: String
    reason: String
}

/// Request to cancel a task
structure CancelTaskRequest {
    @required
    taskId: String

    waitForCompletion: Boolean
}

/// Response for cancel task
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
