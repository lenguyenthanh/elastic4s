$version: "2"

namespace com.sksamuel.elastic4s.smithy.services

use com.sksamuel.elastic4s.smithy.cluster#ClusterHealthResponse
use com.sksamuel.elastic4s.smithy.cluster#ClusterStatsResponse

/// Elasticsearch Cluster Service
@title("Elasticsearch Cluster API")
service ElasticsearchClusterService {
    version: "9.0"
    operations: [
        GetClusterHealth
        GetClusterStats
    ]
}

/// HTTP-bound Cluster Health Request
structure GetClusterHealthInput {
    @httpQuery("level")
    level: String
    
    @httpQuery("wait_for_status")
    waitForStatus: String
    
    @httpQuery("timeout")
    timeout: String
}

/// Get cluster health
@http(method: "GET", uri: "/_cluster/health")
@readonly
operation GetClusterHealth {
    input: GetClusterHealthInput
    output: ClusterHealthResponse
}

/// HTTP-bound Cluster Stats Request
structure GetClusterStatsInput {
    @httpQuery("flat_settings")
    flatSettings: Boolean
}

/// Get cluster statistics
@http(method: "GET", uri: "/_cluster/stats")
@readonly
operation GetClusterStats {
    input: GetClusterStatsInput
    output: ClusterStatsResponse
}
