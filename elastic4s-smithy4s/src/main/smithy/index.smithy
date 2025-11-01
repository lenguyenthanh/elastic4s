$version: "2"

namespace com.sksamuel.elastic4s.smithy.index

use com.sksamuel.elastic4s.smithy.common#RefreshPolicy
use com.sksamuel.elastic4s.smithy.common#VersionType
use com.sksamuel.elastic4s.smithy.common#Shards

/// Request for indexing a document
structure IndexRequest {
    @required
    index: String
    
    id: String
    
    @required
    source: Document
    
    routing: String
    parent: String
    timeout: String
    version: Long
    versionType: VersionType
    pipeline: String
    refreshPolicy: RefreshPolicy
    waitForActiveShards: String
}

/// Response for index request
structure IndexResponse {
    @jsonName("_index")
    @required
    index: String
    
    @jsonName("_type")
    type: String
    
    @jsonName("_id")
    @required
    id: String
    
    @jsonName("_version")
    version: Long
    
    @required
    result: String
    
    @jsonName("_shards")
    shards: Shards
    
    @jsonName("_seq_no")
    seqNo: Long
    
    @jsonName("_primary_term")
    primaryTerm: Long
    
    created: Boolean
}
