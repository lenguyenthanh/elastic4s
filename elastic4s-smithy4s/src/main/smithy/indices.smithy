$version: "2"

namespace se.thanh.elastic4cats

use smithy4s.meta#bincompatFriendly

/// Request to create an index
@bincompatFriendly
structure CreateIndexRequest {
    @required
    name: String

    settings: IndexSettings
    mappings: Mappings
    aliases: AliasMap
    waitForActiveShards: String
    timeout: String
    masterTimeout: String
}

/// Body for creating an index
@bincompatFriendly
structure CreateIndexBody {
    settings: IndexSettings
    mappings: Mappings
    aliases: AliasMap
}

/// Index settings
@bincompatFriendly
structure IndexSettings {
    numberOfShards: Integer
    numberOfReplicas: Integer

    @jsonName("refresh_interval")
    refreshInterval: String

    @jsonName("max_result_window")
    maxResultWindow: Integer

    @jsonName("analysis")
    analysis: AnalysisSettings

    /// Additional settings
    additionalSettings: SettingsMap
}

/// Analysis settings
@bincompatFriendly
structure AnalysisSettings {
    analyzer: AnalyzerMap
    tokenizer: TokenizerMap
    filter: FilterMap
    charFilter: CharFilterMap
}

/// Mappings for an index
@bincompatFriendly
structure Mappings {
    properties: PropertyMap

    @jsonName("dynamic")
    dynamic: Dynamic

    @jsonName("_source")
    source: SourceSettings

    @jsonName("_routing")
    routing: RoutingSettings

    meta: MetaMap
}

/// Source settings
@bincompatFriendly
structure SourceSettings {
    enabled: Boolean
    includes: StringList
    excludes: StringList
}

/// Routing settings
@bincompatFriendly
structure RoutingSettings {
    required: Boolean
}

/// Dynamic mapping behavior
enum Dynamic {
    TRUE = "true"
    FALSE = "false"
    STRICT = "strict"
    RUNTIME = "runtime"
}

/// Property mapping
@bincompatFriendly
structure Property {
    @required
    type: String

    index: Boolean
    store: Boolean
    docValues: Boolean

    analyzer: String
    searchAnalyzer: String
    normalizer: String

    boost: Double
    coerce: Boolean
    copyTo: StringList

    eagerGlobalOrdinals: Boolean
    enabled: Boolean

    fielddata: Boolean
    fields: PropertyMap

    format: String
    ignoreAbove: Integer
    ignoreMalformed: Boolean

    indexOptions: String
    indexPhrases: Boolean
    indexPrefixes: IndexPrefixes

    meta: MetaMap

    norms: Boolean
    nullValue: String

    positionIncrementGap: Integer
    properties: PropertyMap

    searchQuoteAnalyzer: String
    similarity: String

    termVector: String
}

/// Index prefixes settings
@bincompatFriendly
structure IndexPrefixes {
    minChars: Integer
    maxChars: Integer
}

/// Request to delete an index
@bincompatFriendly
structure DeleteIndexRequest {
    @required
    indexes: StringList

    timeout: String
    masterTimeout: String
    allowNoIndices: Boolean
    ignoreUnavailable: Boolean
}

/// Response for delete index
@bincompatFriendly
structure DeleteIndexResponse {
    @required
    acknowledged: Boolean
}

/// Request to get index
@bincompatFriendly
structure GetIndexRequest {
    @required
    indexes: StringList

    includeDefaults: Boolean
    allowNoIndices: Boolean
    expandWildcards: String
    flatSettings: Boolean
    ignoreUnavailable: Boolean
    includeTypeName: Boolean
    local: Boolean
    masterTimeout: String
}

/// Request to check if index exists
@bincompatFriendly
structure IndexExistsRequest {
    @required
    indexes: StringList

    allowNoIndices: Boolean
    expandWildcards: String
    flatSettings: Boolean
    ignoreUnavailable: Boolean
    includeDefaults: Boolean
    local: Boolean
}

/// Request to open an index
@bincompatFriendly
structure OpenIndexRequest {
    @required
    indexes: StringList

    timeout: String
    masterTimeout: String
    waitForActiveShards: String
    allowNoIndices: Boolean
    expandWildcards: String
    ignoreUnavailable: Boolean
}

/// Response for open index
@bincompatFriendly
structure OpenIndexResponse {
    @required
    acknowledged: Boolean

    @jsonName("shards_acknowledged")
    shardsAcknowledged: Boolean
}

/// Request to close an index
@bincompatFriendly
structure CloseIndexRequest {
    @required
    indexes: StringList

    timeout: String
    masterTimeout: String
    allowNoIndices: Boolean
    expandWildcards: String
    ignoreUnavailable: Boolean
    waitForActiveShards: String
}

/// Response for close index
@bincompatFriendly
structure CloseIndexResponse {
    @required
    acknowledged: Boolean

    @jsonName("shards_acknowledged")
    shardsAcknowledged: Boolean

    indices: IndexResultMap
}

/// Index result
@bincompatFriendly
structure IndexResult {
    closed: Boolean
    shards: ShardResultMap
}

/// Shard result
@bincompatFriendly
structure ShardResult {
    failures: FailureList
}

/// Failure information
@bincompatFriendly
structure Failure {
    index: String
    shard: Integer
    reason: String
}

/// Request to refresh an index
@bincompatFriendly
structure RefreshIndexRequest {
    @required
    indexes: StringList

    allowNoIndices: Boolean
    expandWildcards: String
    ignoreUnavailable: Boolean
}

/// Request to flush an index
@bincompatFriendly
structure FlushIndexRequest {
    @required
    indexes: StringList

    force: Boolean
    waitIfOngoing: Boolean
    allowNoIndices: Boolean
    expandWildcards: String
    ignoreUnavailable: Boolean
}

/// Request to get index stats
@bincompatFriendly
structure IndexStatsRequest {
    indexes: StringList

    metric: StringList
    completionFields: StringList
    fielddataFields: StringList
    fields: StringList
    groups: StringList
    level: String
    includeSegmentFileSizes: Boolean
    includeUnloadedSegments: Boolean
}

/// Response for index stats
@bincompatFriendly
structure IndexStatsResponse {
    @jsonName("_shards")
    shards: ShardsInfo

    @jsonName("_all")
    all: IndexStats

    indices: IndexStatsMap
}

/// Shards info
@bincompatFriendly
structure ShardsInfo {
    total: Integer
    successful: Integer
    failed: Integer
}

/// Index statistics
@bincompatFriendly
structure IndexStats {
    primaries: Stats
    total: Stats
}

/// Statistics
@bincompatFriendly
structure Stats {
    docs: DocsStats
    store: StoreStats
    indexing: IndexingStats
    get: GetStats
    search: SearchStats
    merges: MergeStats
    refresh: RefreshStats
    flush: FlushStats
    warmer: WarmerStats
    queryCache: QueryCacheStats
    fielddata: FielddataStats
    completion: CompletionStats
    segments: SegmentStats
    translog: TranslogStats
    requestCache: RequestCacheStats
}

/// Document statistics
@bincompatFriendly
structure DocsStats {
    count: Long
    deleted: Long
}

/// Store statistics
@bincompatFriendly
structure StoreStats {
    @jsonName("size_in_bytes")
    sizeInBytes: Long

    @jsonName("reserved_in_bytes")
    reservedInBytes: Long
}

/// Indexing statistics
@bincompatFriendly
structure IndexingStats {
    @jsonName("index_total")
    indexTotal: Long

    @jsonName("index_time_in_millis")
    indexTimeInMillis: Long

    @jsonName("index_current")
    indexCurrent: Long

    @jsonName("delete_total")
    deleteTotal: Long

    @jsonName("delete_time_in_millis")
    deleteTimeInMillis: Long

    @jsonName("delete_current")
    deleteCurrent: Long
}

/// Get statistics
@bincompatFriendly
structure GetStats {
    total: Long

    @jsonName("time_in_millis")
    timeInMillis: Long

    @jsonName("exists_total")
    existsTotal: Long

    @jsonName("exists_time_in_millis")
    existsTimeInMillis: Long

    @jsonName("missing_total")
    missingTotal: Long

    @jsonName("missing_time_in_millis")
    missingTimeInMillis: Long

    current: Long
}

/// Search statistics
@bincompatFriendly
structure SearchStats {
    @jsonName("query_total")
    queryTotal: Long

    @jsonName("query_time_in_millis")
    queryTimeInMillis: Long

    @jsonName("query_current")
    queryCurrent: Long

    @jsonName("fetch_total")
    fetchTotal: Long

    @jsonName("fetch_time_in_millis")
    fetchTimeInMillis: Long

    @jsonName("fetch_current")
    fetchCurrent: Long

    @jsonName("scroll_total")
    scrollTotal: Long

    @jsonName("scroll_time_in_millis")
    scrollTimeInMillis: Long

    @jsonName("scroll_current")
    scrollCurrent: Long

    @jsonName("suggest_total")
    suggestTotal: Long

    @jsonName("suggest_time_in_millis")
    suggestTimeInMillis: Long

    @jsonName("suggest_current")
    suggestCurrent: Long
}

/// Merge statistics
@bincompatFriendly
structure MergeStats {
    current: Long

    @jsonName("current_docs")
    currentDocs: Long

    @jsonName("current_size_in_bytes")
    currentSizeInBytes: Long

    total: Long

    @jsonName("total_time_in_millis")
    totalTimeInMillis: Long

    @jsonName("total_docs")
    totalDocs: Long

    @jsonName("total_size_in_bytes")
    totalSizeInBytes: Long
}

/// Refresh statistics
@bincompatFriendly
structure RefreshStats {
    total: Long

    @jsonName("total_time_in_millis")
    totalTimeInMillis: Long

    @jsonName("external_total")
    externalTotal: Long

    @jsonName("external_total_time_in_millis")
    externalTotalTimeInMillis: Long
}

/// Flush statistics
@bincompatFriendly
structure FlushStats {
    total: Long

    @jsonName("total_time_in_millis")
    totalTimeInMillis: Long

    periodic: Long
}

/// Warmer statistics
@bincompatFriendly
structure WarmerStats {
    current: Long
    total: Long

    @jsonName("total_time_in_millis")
    totalTimeInMillis: Long
}

/// Query cache statistics
@bincompatFriendly
structure QueryCacheStats {
    @jsonName("memory_size_in_bytes")
    memorySizeInBytes: Long

    @jsonName("total_count")
    totalCount: Long

    @jsonName("hit_count")
    hitCount: Long

    @jsonName("miss_count")
    missCount: Long

    @jsonName("cache_size")
    cacheSize: Long

    @jsonName("cache_count")
    cacheCount: Long

    evictions: Long
}

/// Fielddata statistics
@bincompatFriendly
structure FielddataStats {
    @jsonName("memory_size_in_bytes")
    memorySizeInBytes: Long

    evictions: Long

    fields: FieldStatsMap
}

/// Completion statistics
@bincompatFriendly
structure CompletionStats {
    @jsonName("size_in_bytes")
    sizeInBytes: Long

    fields: FieldStatsMap
}

/// Segment statistics
@bincompatFriendly
structure SegmentStats {
    count: Long

    @jsonName("memory_in_bytes")
    memoryInBytes: Long

    @jsonName("terms_memory_in_bytes")
    termsMemoryInBytes: Long

    @jsonName("stored_fields_memory_in_bytes")
    storedFieldsMemoryInBytes: Long

    @jsonName("term_vectors_memory_in_bytes")
    termVectorsMemoryInBytes: Long

    @jsonName("norms_memory_in_bytes")
    normsMemoryInBytes: Long

    @jsonName("points_memory_in_bytes")
    pointsMemoryInBytes: Long

    @jsonName("doc_values_memory_in_bytes")
    docValuesMemoryInBytes: Long

    @jsonName("index_writer_memory_in_bytes")
    indexWriterMemoryInBytes: Long

    @jsonName("version_map_memory_in_bytes")
    versionMapMemoryInBytes: Long

    @jsonName("fixed_bit_set_memory_in_bytes")
    fixedBitSetMemoryInBytes: Long
}

/// Translog statistics
@bincompatFriendly
structure TranslogStats {
    operations: Long

    @jsonName("size_in_bytes")
    sizeInBytes: Long

    @jsonName("uncommitted_operations")
    uncommittedOperations: Long

    @jsonName("uncommitted_size_in_bytes")
    uncommittedSizeInBytes: Long

    @jsonName("earliest_last_modified_age")
    earliestLastModifiedAge: Long
}

/// Request cache statistics
@bincompatFriendly
structure RequestCacheStats {
    @jsonName("memory_size_in_bytes")
    memorySizeInBytes: Long

    evictions: Long

    @jsonName("hit_count")
    hitCount: Long

    @jsonName("miss_count")
    missCount: Long
}

/// Field statistics
@bincompatFriendly
structure FieldStats {
    @jsonName("memory_size_in_bytes")
    memorySizeInBytes: Long
}

list FailureList {
    member: Failure
}

map AliasMap {
    key: String
    value: Alias
}

map SettingsMap {
    key: String
    value: Document
}

map AnalyzerMap {
    key: String
    value: Document
}

map TokenizerMap {
    key: String
    value: Document
}

map FilterMap {
    key: String
    value: Document
}

map CharFilterMap {
    key: String
    value: Document
}

map PropertyMap {
    key: String
    value: Property
}

map MetaMap {
    key: String
    value: String
}

map IndexResultMap {
    key: String
    value: IndexResult
}

map ShardResultMap {
    key: String
    value: ShardResult
}

map IndexStatsMap {
    key: String
    value: IndexStats
}

map FieldStatsMap {
    key: String
    value: FieldStats
}

/// Alias definition
@bincompatFriendly
structure Alias {
    filter: Document
    routing: String

    @jsonName("index_routing")
    indexRouting: String

    @jsonName("search_routing")
    searchRouting: String

    @jsonName("is_write_index")
    isWriteIndex: Boolean

    @jsonName("is_hidden")
    isHidden: Boolean
}
