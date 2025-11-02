$version: "2"

namespace se.thanh.elastic4cats

/// Request for getting a document by ID
structure GetRequest {
    @required
    index: String

    @required
    id: String

    storedFields: StringList
    parent: String
    preference: String
    realtime: Boolean
    refresh: Boolean
    routing: String
    version: Long
    versionType: VersionType
    fetchSource: FetchSourceContext
}

/// Response for get document request
@mixin
structure GetResponseMixin {
    @jsonName("_id")
    @required
    id: String

    @jsonName("_index")
    @required
    index: String

    @jsonName("_type")
    type: String

    @jsonName("_version")
    version: Long

    @jsonName("_seq_no")
    seqNo: Long

    @jsonName("_primary_term")
    primaryTerm: Long

    @required
    found: Boolean

    fields: FieldMap
    source: SourceMap
}

structure GetResponse with [GetResponseMixin] {
}

/// Multi-get request
structure MultiGetRequest {
    @required
    items: GetItemList

    preference: String
    realtime: Boolean
    refresh: Boolean
}

/// Individual item in multi-get request
structure GetItem {
    @required
    index: String

    @required
    id: String

    routing: String
    storedFields: StringList
    fetchSource: FetchSourceContext
}

/// Multi-get response
structure MultiGetResponse {
    @required
    docs: GetResponseList
}

list GetItemList {
    member: GetItem
}

list GetResponseList {
    member: GetResponse
}

map FieldMap {
    key: String
    value: Document
}
