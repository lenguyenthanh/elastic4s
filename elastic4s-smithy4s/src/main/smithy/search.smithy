$version: "2"

namespace com.sksamuel.elastic4s.smithy.search

use com.sksamuel.elastic4s.smithy.common#StringList
use com.sksamuel.elastic4s.smithy.common#Operator

/// Search request
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
structure ScriptSort {
    @required
    script: Script
    
    @required
    type: String
    
    order: SortOrder
}

/// Geo distance sort
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

/// Script for sorting or scripted fields
structure Script {
    @required
    source: String
    
    lang: String
    params: ScriptParams
}

/// Highlight settings
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
structure HighlightField {
    preTags: StringList
    postTags: StringList
    fragmentSize: Integer
    numberOfFragments: Integer
    fragmentOffset: Integer
    noMatchSize: Integer
}

/// Field collapse
structure FieldCollapse {
    @required
    field: String
    
    innerHits: InnerHitsList
    maxConcurrentGroupSearches: Integer
}

/// Inner hits for collapsed results
structure InnerHits {
    name: String
    size: Integer
    from: Integer
    sort: SortList
}

/// Search response
structure SearchResponse {
    took: Long
    
    @jsonName("timed_out")
    timedOut: Boolean
    
    @jsonName("_shards")
    shards: SearchShards
    
    hits: SearchHits
    
    aggregations: AggregationResultMap
    
    suggest: SuggestResultMap
    
    @jsonName("_scroll_id")
    scrollId: String
    
    profile: ProfileResult
}

/// Search shards info
structure SearchShards {
    total: Integer
    successful: Integer
    skipped: Integer
    failed: Integer
    failures: ShardFailureList
}

/// Shard failure
structure ShardFailure {
    shard: Integer
    index: String
    node: String
    reason: FailureReason
}

/// Failure reason
structure FailureReason {
    type: String
    reason: String
}

/// Search hits
structure SearchHits {
    total: TotalHits
    
    @jsonName("max_score")
    maxScore: Double
    
    hits: HitList
}

/// Total hits info
structure TotalHits {
    value: Long
    relation: String
}

/// Search hit
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
structure Explanation {
    value: Double
    description: String
    details: ExplanationList
}

/// Profile result
structure ProfileResult {
    shards: ProfileShardList
}

/// Profile shard result
structure ProfileShard {
    id: String
    searches: SearchProfileList
    aggregations: AggregationProfileList
}

/// Search profile
structure SearchProfile {
    query: QueryProfileList
    rewriteTime: Long
    collector: CollectorProfileList
}

/// Query profile
structure QueryProfile {
    type: String
    description: String
    timeInNanos: Long
    breakdown: BreakdownMap
    children: QueryProfileList
}

/// Collector profile
structure CollectorProfile {
    name: String
    reason: String
    timeInNanos: Long
    children: CollectorProfileList
}

/// Aggregation profile
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

list SortValueList {
    member: Document
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

map ScriptParams {
    key: String
    value: Document
}
