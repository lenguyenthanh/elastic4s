$version: "2"

namespace se.thanh.elastic4cats

use smithy4s.meta#bincompatFriendly

/// Request to search with scroll
@bincompatFriendly
structure SearchScrollRequest {
    @required
    scrollId: String

    keepAlive: String
}

/// Response for search scroll
@bincompatFriendly
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
@bincompatFriendly
structure ScrollShards {
    total: Integer
    successful: Integer
    skipped: Integer
    failed: Integer
}

/// Scroll hits
@bincompatFriendly
structure ScrollHits {
    total: ScrollTotalHits

    @jsonName("max_score")
    maxScore: Double

    hits: ScrollHitList
}

/// Total hits information
@bincompatFriendly
structure ScrollTotalHits {
    value: Long
    relation: String
}

/// Search hit
@bincompatFriendly
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
@bincompatFriendly
structure ClearScrollRequest {
    @required
    scrollIds: StringList
}

/// Response for clear scroll
@bincompatFriendly
structure ClearScrollResponse {
    succeeded: Boolean

    @jsonName("num_freed")
    numFreed: Integer
}

list ScrollHitList {
    member: ScrollHit
}
