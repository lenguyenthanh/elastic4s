$version: "2"

namespace com.sksamuel.elastic4s.smithy.common

/// Health status of a cluster
enum HealthStatus {
    GREEN = "green"
    YELLOW = "yellow"
    RED = "red"
}

/// Refresh policy for indexing operations
enum RefreshPolicy {
    /// Do not refresh
    NONE = "none"
    /// Refresh immediately
    IMMEDIATE = "immediate"
    /// Wait for refresh
    WAIT_FOR = "wait_for"
}

/// Version type for versioning operations
enum VersionType {
    INTERNAL = "internal"
    EXTERNAL = "external"
    EXTERNAL_GTE = "external_gte"
    FORCE = "force"
}

/// Distance units for geo queries
enum DistanceUnit {
    INCH = "in"
    YARD = "yd"
    FEET = "ft"
    KILOMETER = "km"
    NAUTICAL_MILES = "nmi"
    MILLIMETER = "mm"
    CENTIMETER = "cm"
    MILE = "mi"
    METER = "m"
}

/// Operator for queries
enum Operator {
    AND = "and"
    OR = "or"
}

/// Priority levels
enum Priority {
    IMMEDIATE = "immediate"
    URGENT = "urgent"
    HIGH = "high"
    NORMAL = "normal"
    LOW = "low"
    LANGUID = "languid"
}

/// Document reference
structure DocumentRef {
    @required
    index: String
    
    @required
    id: String
    
    routing: String
}

/// Fetch source context for controlling source retrieval
structure FetchSourceContext {
    @required
    fetchSource: Boolean
    
    includes: StringList
    excludes: StringList
}

/// Shards information
structure Shards {
    total: Integer
    successful: Integer
    skipped: Integer
    failed: Integer
}

list StringList {
    member: String
}
