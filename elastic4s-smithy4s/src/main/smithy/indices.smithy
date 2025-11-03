$version: "2"

namespace se.thanh.elastic4cats

use alloy#untagged

/// Request to create an index
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
structure CreateIndexBody {
    settings: IndexSettings
    mappings: Mappings
    aliases: AliasMap
}

/// Index settings
structure IndexSettings {
    @jsonName("number_of_shards")
    numberOfShards: Integer
    @jsonName("number_of_replicas")
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
structure AnalysisSettings {
    analyzer: AnalyzerMap
    tokenizer: TokenizerMap
    filter: FilterMap
    charFilter: CharFilterMap
}

/// Mappings for an index
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
structure SourceSettings {
    enabled: Boolean
    includes: StringList
    excludes: StringList
}

/// Routing settings
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

/// Property mapping - Union of all Elasticsearch field data types

@untagged
union Property {
    // Text family
    text: TextProperty
    matchOnlyText: MatchOnlyTextProperty
    
    // Keyword family
    keyword: KeywordProperty
    constantKeyword: ConstantKeywordProperty
    wildcard: WildcardProperty
    
    // Numeric family
    long: LongProperty
    integer: IntegerProperty
    short: ShortProperty
    byte: ByteProperty
    double: DoubleProperty
    float: FloatProperty
    halfFloat: HalfFloatProperty
    scaledFloat: ScaledFloatProperty
    unsignedLong: UnsignedLongProperty
    
    // Date family
    date: DateProperty
    dateNanos: DateNanosProperty
    
    // Boolean
    boolean: BooleanProperty
    
    // Binary
    binary: BinaryProperty
    
    // Range family
    integerRange: IntegerRangeProperty
    floatRange: FloatRangeProperty
    longRange: LongRangeProperty
    doubleRange: DoubleRangeProperty
    dateRange: DateRangeProperty
    ipRange: IpRangeProperty
    
    // Object and nested
    object: ObjectProperty
    nested: NestedProperty
    flattened: FlattenedProperty
    
    // Structured data
    join: JoinProperty
    
    // Spatial
    geoPoint: GeoPointProperty
    geoShape: GeoShapeProperty
    point: PointProperty
    shape: ShapeProperty
    
    // IP
    ip: IpProperty
    
    // Completion
    completion: CompletionProperty
    
    // Token count
    tokenCount: TokenCountProperty
    
    // Murmur3
    murmur3: Murmur3Property
    
    // Annotated text
    annotatedText: AnnotatedTextProperty
    
    // Percolator
    percolator: PercolatorProperty
    
    // Rank features
    rankFeature: RankFeatureProperty
    rankFeatures: RankFeaturesProperty
    
    // Dense vector
    denseVector: DenseVectorProperty
    
    // Sparse vector  
    sparseVector: SparseVectorProperty
    
    // Search as you type
    searchAsYouType: SearchAsYouTypeProperty
    
    // Alias
    alias: AliasProperty
    
    // Histogram
    histogram: HistogramProperty
    
    // Aggregate metric
    aggregateMetricDouble: AggregateMetricDoubleProperty
    
    // Other types not explicitly defined
    other: GenericProperty
}

/// Base property fields common to most field types

structure BasePropertyFields {
    meta: MetaMap
    copyTo: StringList
    store: Boolean
    index: Boolean
    docValues: Boolean
}

/// Text field type for full-text search
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/text
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/text")
structure TextProperty {
    analyzer: String
    searchAnalyzer: String
    searchQuoteAnalyzer: String
    boost: Double
    eagerGlobalOrdinals: Boolean
    fielddata: Boolean
    fielddataFrequencyFilter: FielddataFrequencyFilter
    fields: PropertyMap
    indexOptions: String
    indexPhrases: Boolean
    indexPrefixes: IndexPrefixes
    norms: Boolean
    positionIncrementGap: Integer
    similarity: String
    termVector: String
    meta: MetaMap
    copyTo: StringList
    store: Boolean
}

/// Match only text field type optimized for search-only use cases
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/match-only-text
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/match-only-text")
structure MatchOnlyTextProperty {
    fields: PropertyMap
    meta: MetaMap
    copyTo: StringList
}

/// Keyword field type for structured content
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/keyword
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/keyword")
structure KeywordProperty {
    boost: Double
    docValues: Boolean
    eagerGlobalOrdinals: Boolean
    fields: PropertyMap
    ignoreAbove: Integer
    index: Boolean
    indexOptions: String
    norms: Boolean
    nullValue: String
    store: Boolean
    similarity: String
    normalizer: String
    splitQueriesOnWhitespace: Boolean
    meta: MetaMap
    copyTo: StringList
}

/// Constant keyword field type for fields that always contain the same value
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/constant-keyword
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/constant-keyword")
structure ConstantKeywordProperty {
    value: String
    meta: MetaMap
}

/// Wildcard field type for wildcard pattern matching
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/wildcard
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/wildcard")
structure WildcardProperty {
    nullValue: String
    ignoreAbove: Integer
    meta: MetaMap
}

/// Long numeric field type
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number")
structure LongProperty {
    coerce: Boolean
    boost: Double
    docValues: Boolean
    ignoreMalformed: Boolean
    index: Boolean
    nullValue: Long
    store: Boolean
    meta: MetaMap
    copyTo: StringList
}

/// Integer numeric field type
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number")
structure IntegerProperty {
    coerce: Boolean
    boost: Double
    docValues: Boolean
    ignoreMalformed: Boolean
    index: Boolean
    nullValue: Integer
    store: Boolean
    meta: MetaMap
    copyTo: StringList
}

/// Short numeric field type
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number")
structure ShortProperty {
    coerce: Boolean
    boost: Double
    docValues: Boolean
    ignoreMalformed: Boolean
    index: Boolean
    nullValue: Short
    store: Boolean
    meta: MetaMap
    copyTo: StringList
}

/// Byte numeric field type
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number")
structure ByteProperty {
    coerce: Boolean
    boost: Double
    docValues: Boolean
    ignoreMalformed: Boolean
    index: Boolean
    nullValue: Byte
    store: Boolean
    meta: MetaMap
    copyTo: StringList
}

/// Double numeric field type
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number")
structure DoubleProperty {
    coerce: Boolean
    boost: Double
    docValues: Boolean
    ignoreMalformed: Boolean
    index: Boolean
    nullValue: Double
    store: Boolean
    meta: MetaMap
    copyTo: StringList
}

/// Float numeric field type
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number")
structure FloatProperty {
    coerce: Boolean
    boost: Double
    docValues: Boolean
    ignoreMalformed: Boolean
    index: Boolean
    nullValue: Float
    store: Boolean
    meta: MetaMap
    copyTo: StringList
}

/// Half float numeric field type
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number")
structure HalfFloatProperty {
    coerce: Boolean
    boost: Double
    docValues: Boolean
    ignoreMalformed: Boolean
    index: Boolean
    nullValue: Float
    store: Boolean
    meta: MetaMap
    copyTo: StringList
}

/// Scaled float numeric field type for floating point with fixed scaling factor
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number")
structure ScaledFloatProperty {
    @required
    scalingFactor: Double
    coerce: Boolean
    boost: Double
    docValues: Boolean
    ignoreMalformed: Boolean
    index: Boolean
    nullValue: Double
    store: Boolean
    meta: MetaMap
    copyTo: StringList
}

/// Unsigned long numeric field type
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/number")
structure UnsignedLongProperty {
    coerce: Boolean
    boost: Double
    docValues: Boolean
    ignoreMalformed: Boolean
    index: Boolean
    nullValue: Long
    store: Boolean
    meta: MetaMap
    copyTo: StringList
}

/// Date field type for date values
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/date
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/date")
structure DateProperty {
    boost: Double
    docValues: Boolean
    format: String
    locale: String
    ignoreMalformed: Boolean
    index: Boolean
    nullValue: String
    store: Boolean
    meta: MetaMap
    copyTo: StringList
}

/// Date nanos field type for high precision date values
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/date_nanos
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/date_nanos")
structure DateNanosProperty {
    boost: Double
    docValues: Boolean
    format: String
    locale: String
    ignoreMalformed: Boolean
    index: Boolean
    nullValue: String
    store: Boolean
    meta: MetaMap
    copyTo: StringList
}

/// Boolean field type for true/false values
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/boolean
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/boolean")
structure BooleanProperty {
    boost: Double
    docValues: Boolean
    index: Boolean
    nullValue: Boolean
    store: Boolean
    meta: MetaMap
    copyTo: StringList
}

/// Binary field type for binary data
/// See: https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/binary
@externalDocumentation(url: "https://www.elastic.co/docs/reference/elasticsearch/mapping-reference/binary")
structure BinaryProperty {
    docValues: Boolean
    store: Boolean
    meta: MetaMap
}

/// Integer range property

structure IntegerRangeProperty {
    coerce: Boolean
    boost: Double
    index: Boolean
    store: Boolean
    meta: MetaMap
}

/// Float range property

structure FloatRangeProperty {
    coerce: Boolean
    boost: Double
    index: Boolean
    store: Boolean
    meta: MetaMap
}

/// Long range property

structure LongRangeProperty {
    coerce: Boolean
    boost: Double
    index: Boolean
    store: Boolean
    meta: MetaMap
}

/// Double range property

structure DoubleRangeProperty {
    coerce: Boolean
    boost: Double
    index: Boolean
    store: Boolean
    meta: MetaMap
}

/// Date range property

structure DateRangeProperty {
    coerce: Boolean
    boost: Double
    index: Boolean
    store: Boolean
    format: String
    meta: MetaMap
}

/// IP range property

structure IpRangeProperty {
    coerce: Boolean
    boost: Double
    index: Boolean
    store: Boolean
    meta: MetaMap
}

/// Object property

structure ObjectProperty {
    dynamic: Dynamic
    enabled: Boolean
    properties: PropertyMap
    meta: MetaMap
}

/// Nested property

structure NestedProperty {
    dynamic: Dynamic
    properties: PropertyMap
    includeInParent: Boolean
    includeInRoot: Boolean
    meta: MetaMap
}

/// Flattened property

structure FlattenedProperty {
    boost: Double
    depthLimit: Integer
    docValues: Boolean
    eagerGlobalOrdinals: Boolean
    index: Boolean
    indexOptions: String
    nullValue: String
    similarity: String
    splitQueriesOnWhitespace: Boolean
    meta: MetaMap
}

/// Join property

structure JoinProperty {
    relations: JoinRelationsMap
    eagerGlobalOrdinals: Boolean
    meta: MetaMap
}

/// Geo point property

structure GeoPointProperty {
    ignoreMalformed: Boolean
    ignoreZValue: Boolean
    nullValue: String
    meta: MetaMap
}

/// Geo shape property

structure GeoShapeProperty {
    orientation: String
    ignoreMalformed: Boolean
    ignoreZValue: Boolean
    coerce: Boolean
    meta: MetaMap
}

/// Point property

structure PointProperty {
    ignoreMalformed: Boolean
    ignoreZValue: Boolean
    nullValue: String
    meta: MetaMap
}

/// Shape property

structure ShapeProperty {
    orientation: String
    ignoreMalformed: Boolean
    ignoreZValue: Boolean
    coerce: Boolean
    meta: MetaMap
}

/// IP property

structure IpProperty {
    boost: Double
    docValues: Boolean
    index: Boolean
    nullValue: String
    store: Boolean
    ignoreMalformed: Boolean
    meta: MetaMap
    copyTo: StringList
}

/// Completion property

structure CompletionProperty {
    analyzer: String
    searchAnalyzer: String
    preserveSeparators: Boolean
    preservePositionIncrements: Boolean
    maxInputLength: Integer
    contexts: ContextList
    meta: MetaMap
}

/// Token count property

structure TokenCountProperty {
    @required
    analyzer: String
    enablePositionIncrements: Boolean
    boost: Double
    docValues: Boolean
    index: Boolean
    nullValue: Integer
    store: Boolean
    meta: MetaMap
}

/// Murmur3 property

structure Murmur3Property {
    meta: MetaMap
}

/// Annotated text property

structure AnnotatedTextProperty {
    analyzer: String
    searchAnalyzer: String
    searchQuoteAnalyzer: String
    meta: MetaMap
}

/// Percolator property

structure PercolatorProperty {
    meta: MetaMap
}

/// Rank feature property

structure RankFeatureProperty {
    positiveScoreImpact: Boolean
    meta: MetaMap
}

/// Rank features property

structure RankFeaturesProperty {
    positiveScoreImpact: Boolean
    meta: MetaMap
}

/// Dense vector property

structure DenseVectorProperty {
    @required
    dims: Integer
    index: Boolean
    similarity: String
    indexOptions: DenseVectorIndexOptions
    meta: MetaMap
}

/// Sparse vector property

structure SparseVectorProperty {
    meta: MetaMap
}

/// Search as you type property

structure SearchAsYouTypeProperty {
    analyzer: String
    searchAnalyzer: String
    searchQuoteAnalyzer: String
    maxShingleSize: Integer
    termVector: String
    meta: MetaMap
}

/// Alias property

structure AliasProperty {
    @required
    path: String
    meta: MetaMap
}

/// Histogram property

structure HistogramProperty {
    ignoreMalformed: Boolean
    meta: MetaMap
}

/// Aggregate metric double property

structure AggregateMetricDoubleProperty {
    @required
    metrics: StringList
    @required
    defaultMetric: String
    meta: MetaMap
}

/// Generic property for types not explicitly defined

structure GenericProperty {
    @required
    type: String
    
    // Common fields that might be used
    properties: PropertyMap
    fields: PropertyMap
    enabled: Boolean
    dynamic: Dynamic
    
    // Additional arbitrary configuration
    config: Document
    meta: MetaMap
}

/// Fielddata frequency filter

structure FielddataFrequencyFilter {
    min: Double
    max: Double
    minSegmentSize: Integer
}

/// Dense vector index options

structure DenseVectorIndexOptions {
    type: String
    m: Integer
    efConstruction: Integer
}

/// Context for completion suggester

structure Context {
    @required
    name: String
    @required
    type: String
    path: String
    precision: String
}

list ContextList {
    member: Context
}

map JoinRelationsMap {
    key: String
    value: StringList
}

/// Index prefixes settings
structure IndexPrefixes {
    minChars: Integer
    maxChars: Integer
}

/// Request to delete an index
structure DeleteIndexRequest {
    @required
    indexes: StringList

    timeout: String
    masterTimeout: String
    allowNoIndices: Boolean
    ignoreUnavailable: Boolean
}

/// Response for delete index
structure DeleteIndexResponse {
    @required
    acknowledged: Boolean
}

/// Request to get index
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
structure OpenIndexResponse {
    @required
    acknowledged: Boolean

    @jsonName("shards_acknowledged")
    shardsAcknowledged: Boolean
}

/// Request to close an index
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
structure CloseIndexResponse {
    @required
    acknowledged: Boolean

    @jsonName("shards_acknowledged")
    shardsAcknowledged: Boolean

    indices: IndexResultMap
}

/// Index result
structure IndexResult {
    closed: Boolean
    shards: ShardResultMap
}

/// Shard result
structure ShardResult {
    failures: FailureList
}

/// Failure information
structure Failure {
    index: String
    shard: Integer
    reason: String
}

/// Request to refresh an index
structure RefreshIndexRequest {
    @required
    indexes: StringList

    allowNoIndices: Boolean
    expandWildcards: String
    ignoreUnavailable: Boolean
}

/// Request to flush an index
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
structure IndexStatsResponse {
    @jsonName("_shards")
    shards: ShardsInfo

    @jsonName("_all")
    all: IndexStats

    indices: IndexStatsMap
}

/// Shards info
structure ShardsInfo {
    total: Integer
    successful: Integer
    failed: Integer
}

/// Index statistics
structure IndexStats {
    primaries: Stats
    total: Stats
}

/// Statistics
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
structure DocsStats {
    count: Long
    deleted: Long
}

/// Store statistics
structure StoreStats {
    @jsonName("size_in_bytes")
    sizeInBytes: Long

    @jsonName("reserved_in_bytes")
    reservedInBytes: Long
}

/// Indexing statistics
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
structure FlushStats {
    total: Long

    @jsonName("total_time_in_millis")
    totalTimeInMillis: Long

    periodic: Long
}

/// Warmer statistics
structure WarmerStats {
    current: Long
    total: Long

    @jsonName("total_time_in_millis")
    totalTimeInMillis: Long
}

/// Query cache statistics
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
structure FielddataStats {
    @jsonName("memory_size_in_bytes")
    memorySizeInBytes: Long

    evictions: Long

    fields: FieldStatsMap
}

/// Completion statistics
structure CompletionStats {
    @jsonName("size_in_bytes")
    sizeInBytes: Long

    fields: FieldStatsMap
}

/// Segment statistics
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
