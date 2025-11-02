$version: "2"

namespace se.thanh.elastic4cats

use smithy4s.meta#bincompatFriendly

/// Search request
@bincompatFriendly
structure SearchRequest {
    @required
    indexes: StringList

    query: Document
    from: Integer
    size: Integer
    timeout: String
    terminateAfter: Long

    sort: SortList
    trackScores: Boolean
    trackTotalHits: TrackTotalHits

    @jsonName("_source")
    source: SourceFilter

    storedFields: StringList
    docvalueFields: StringList
    scriptFields: ScriptFieldMap

    explain: Boolean
    version: Boolean
    seqNoPrimaryTerm: Boolean

    minScore: Double

    searchType: String
    requestCache: Boolean
    allowNoIndices: Boolean
    expandWildcards: String
    ignoreUnavailable: Boolean
    ignoreThrottled: Boolean

    routing: StringList
    preference: String

    scroll: String

    suggest: SuggestMap
    highlight: Highlight

    aggregations: AggregationMap

    postFilter: Document

    searchAfter: SortValueList

    collapse: FieldCollapse

    indicesBoost: IndicesBoostList

    profile: Boolean

    stats: StringList
}

/// Source filtering
@bincompatFriendly
structure SourceFilter {
    includes: StringList
    excludes: StringList
}

/// Track total hits option
union TrackTotalHits {
    enabled: Boolean
    value: Integer
}

/// Sort specification
union Sort {
    field: FieldSort
    script: ScriptSort
    geoDistance: GeoDistanceSort
}

/// Field sort
@bincompatFriendly
structure FieldSort {
    @required
    field: String

    order: SortOrder
    mode: SortMode
    missing: String
    unmappedType: String
    numericType: String
}

/// Script sort
@bincompatFriendly
structure ScriptSort {
    @required
    script: Script

    @required
    type: String

    order: SortOrder
}

/// Geo distance sort
@bincompatFriendly
structure GeoDistanceSort {
    @required
    field: String

    @required
    location: GeoPoint

    order: SortOrder
    unit: String
    mode: SortMode
    distanceType: String
}

/// Geo point
@bincompatFriendly
structure GeoPoint {
    lat: Double
    lon: Double
}

/// Sort order
enum SortOrder {
    ASC = "asc"
    DESC = "desc"
}

/// Sort mode
enum SortMode {
    MIN = "min"
    MAX = "max"
    SUM = "sum"
    AVG = "avg"
    MEDIAN = "median"
}

/// Highlight settings
@bincompatFriendly
structure Highlight {
    fields: HighlightFieldMap
    preTags: StringList
    postTags: StringList
    fragmentSize: Integer
    numberOfFragments: Integer
    order: String
    encoder: String
    requireFieldMatch: Boolean
    boundaryScanner: String
    boundaryChars: String
    boundaryMaxScan: Integer
    fragmenter: String
    highlightQuery: Document
    matchedFields: StringList
    noMatchSize: Integer
    phraseLimit: Integer
    type: String
}

/// Highlight field settings
@bincompatFriendly
structure HighlightField {
    preTags: StringList
    postTags: StringList
    fragmentSize: Integer
    numberOfFragments: Integer
    fragmentOffset: Integer
    noMatchSize: Integer
}

/// Field collapse
@bincompatFriendly
structure FieldCollapse {
    @required
    field: String

    innerHits: InnerHitsList
    maxConcurrentGroupSearches: Integer
}

/// Inner hits for collapsed results
@bincompatFriendly
structure InnerHits {
    name: String
    size: Integer
    from: Integer
    sort: SortList
}

/// Search response
@bincompatFriendly
structure SearchResponse {
    took: Long

    @jsonName("timed_out")
    timedOut: Boolean

    @jsonName("_shards")
    shards: SearchShards

    @required
    hits: SearchHits

    aggregations: AggregationResultMap

    suggest: SuggestResultMap

    @jsonName("_scroll_id")
    scrollId: String

    profile: ProfileResult
}

/// Search shards info
@bincompatFriendly
structure SearchShards {
    total: Integer
    successful: Integer
    skipped: Integer
    failed: Integer
    failures: ShardFailureList
}

/// Shard failure
@bincompatFriendly
structure ShardFailure {
    shard: Integer
    index: String
    node: String
    reason: FailureReason
}

/// Failure reason
@bincompatFriendly
structure FailureReason {
    type: String
    reason: String
}

/// Search hits
@bincompatFriendly
structure SearchHits {
    /// Total hit count information, present only if track_total_hits wasn't false in the search request.
    total: TotalHits

    @jsonName("max_score")
    maxScore: Double

    hits: HitList
}

/// Total hits info
@bincompatFriendly
structure TotalHits {
    @required
    value: Long
    @required
    relation: String
}

/// Search hit
@bincompatFriendly
structure Hit {
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

    fields: FieldValueMap

    highlight: HighlightResultMap

    sort: SortValueList

    @jsonName("matched_queries")
    matchedQueries: StringList

    @jsonName("_explanation")
    explanation: Explanation

    @jsonName("inner_hits")
    innerHits: InnerHitsResultMap
}

/// Explanation for score
@bincompatFriendly
structure Explanation {
    value: Double
    description: String
    details: ExplanationList
}

/// Profile result
@bincompatFriendly
structure ProfileResult {
    shards: ProfileShardList
}

/// Profile shard result
@bincompatFriendly
structure ProfileShard {
    id: String
    searches: SearchProfileList
    aggregations: AggregationProfileList
}

/// Search profile
@bincompatFriendly
structure SearchProfile {
    query: QueryProfileList
    rewriteTime: Long
    collector: CollectorProfileList
}

/// Query profile
@bincompatFriendly
structure QueryProfile {
    type: String
    description: String
    timeInNanos: Long
    breakdown: BreakdownMap
    children: QueryProfileList
}

/// Collector profile
@bincompatFriendly
structure CollectorProfile {
    name: String
    reason: String
    timeInNanos: Long
    children: CollectorProfileList
}

/// Aggregation profile
@bincompatFriendly
structure AggregationProfile {
    type: String
    description: String
    timeInNanos: Long
    breakdown: BreakdownMap
    children: AggregationProfileList
}

list SortList {
    member: Sort
}

list InnerHitsList {
    member: InnerHits
}

list ShardFailureList {
    member: ShardFailure
}

list HitList {
    member: Hit
}

list ExplanationList {
    member: Explanation
}

list ProfileShardList {
    member: ProfileShard
}

list SearchProfileList {
    member: SearchProfile
}

list QueryProfileList {
    member: QueryProfile
}

list CollectorProfileList {
    member: CollectorProfile
}

list AggregationProfileList {
    member: AggregationProfile
}

list IndicesBoostList {
    member: Document
}

map ScriptFieldMap {
    key: String
    value: Script
}

map SuggestMap {
    key: String
    value: Document
}

map AggregationMap {
    key: String
    value: Document
}

map AggregationResultMap {
    key: String
    value: Document
}

map SuggestResultMap {
    key: String
    value: Document
}

map HighlightFieldMap {
    key: String
    value: HighlightField
}

map HighlightResultMap {
    key: String
    value: StringList
}

map FieldValueMap {
    key: String
    value: Document
}

map InnerHitsResultMap {
    key: String
    value: SearchHits
}

map BreakdownMap {
    key: String
    value: Long
}
