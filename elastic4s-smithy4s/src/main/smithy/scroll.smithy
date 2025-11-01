$version: "2"

namespace com.sksamuel.elastic4s.smithy.scroll

use com.sksamuel.elastic4s.smithy.common#StringList

/// Request to search with scroll
structure SearchScrollRequest {
    @required
    scrollId: String
    
    keepAlive: String
}

/// Response for search scroll
structure SearchScrollResponse {
    @jsonName("_scroll_id")
    scrollId: String
    
    took: Long
    
    @jsonName("timed_out")
    timedOut: Boolean
    
    @jsonName("_shards")
    shards: ScrollShards
    
    hits: ScrollHits
}

/// Scroll shards information
structure ScrollShards {
    total: Integer
    successful: Integer
    skipped: Integer
    failed: Integer
}

/// Scroll hits
structure ScrollHits {
    total: ScrollTotalHits
    
    @jsonName("max_score")
    maxScore: Double
    
    hits: HitList
}

/// Total hits information
structure ScrollTotalHits {
    value: Long
    relation: String
}

/// Search hit
structure ScrollHit {
    @jsonName("_index")
    index: String
    
    @jsonName("_type")
    type: String
    
    @jsonName("_id")
    id: String
    
    @jsonName("_score")
    score: Double
    
    @jsonName("_source")
    source: Document
    
    sort: SortValueList
}

/// Request to clear scroll
structure ClearScrollRequest {
    @required
    scrollIds: StringList
}

/// Response for clear scroll
structure ClearScrollResponse {
    succeeded: Boolean
    
    @jsonName("num_freed")
    numFreed: Integer
}

list HitList {
    member: ScrollHit
}

list SortValueList {
    member: Document
}
