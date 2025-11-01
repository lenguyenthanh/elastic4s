$version: "2"

namespace se.thanh.elastic4cats

/// Elasticsearch Task Management Service
@title("Elasticsearch Task Management API")
service ElasticsearchTaskService {
    version: "9.0"
    operations: [
        ListTasks
        GetTask
        CancelTask
    ]
}

/// HTTP-bound List Tasks Request
structure ListTasksInput {
    @httpQuery("actions")
    actions: String

    @httpQuery("nodes")
    nodes: String

    @httpQuery("detailed")
    detailed: Boolean

    @httpQuery("wait_for_completion")
    waitForCompletion: Boolean

    @httpQuery("timeout")
    timeout: String

    @httpQuery("group_by")
    groupBy: String
}

/// List currently running tasks
@http(method: "GET", uri: "/_tasks")
@readonly
operation ListTasks {
    input: ListTasksInput
    output: ListTasksResponse
}

/// HTTP-bound Get Task Request
structure GetTaskInput {
    @required
    @httpLabel
    taskId: String

    @httpQuery("wait_for_completion")
    waitForCompletion: Boolean

    @httpQuery("timeout")
    timeout: String
}

/// Get information about a specific task
@http(method: "GET", uri: "/_tasks/{taskId}")
@readonly
operation GetTask {
    input: GetTaskInput
    output: GetTaskResponse
}

/// HTTP-bound Cancel Task Request
structure CancelTaskInput {
    @required
    @httpLabel
    taskId: String

    @httpQuery("wait_for_completion")
    waitForCompletion: Boolean
}

/// Cancel a running task
@http(method: "POST", uri: "/_tasks/{taskId}/_cancel")
operation CancelTask {
    input: CancelTaskInput
    output: CancelTaskResponse
}
