$version: "2"

namespace se.thanh.elastic4cats

/// Request to get aliases
structure GetAliasesRequest {
    @required
    indices: StringList

    aliases: StringList
    ignoreUnavailable: Boolean
}

/// Response for get aliases
structure GetAliasesResponse {
    aliases: AliasInfoMap
}

/// Alias information for an index
structure AliasInfo {
    aliases: AliasDetailsMap
}

/// Alias details
structure AliasDetails {
    filter: Document

    @jsonName("index_routing")
    indexRouting: String

    @jsonName("search_routing")
    searchRouting: String

    @jsonName("is_write_index")
    isWriteIndex: Boolean

    @jsonName("is_hidden")
    isHidden: Boolean
}

/// Request for indices aliases operations
structure IndicesAliasesRequest {
    @required
    actions: AliasActionList

    timeout: String
    masterTimeout: String
}

/// Union of alias actions
union AliasAction {
    add: AddAliasAction
    remove: RemoveAliasAction
    removeIndex: RemoveIndexAction
}

/// Add alias action
structure AddAliasAction {
    @required
    indices: StringList

    @required
    alias: String

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

/// Remove alias action
structure RemoveAliasAction {
    @required
    indices: StringList

    @required
    alias: String
}

/// Remove index action
structure RemoveIndexAction {
    @required
    index: String
}

/// Response for indices aliases request
structure IndicesAliasesResponse {
    acknowledged: Boolean
}

list AliasActionList {
    member: AliasAction
}

map AliasInfoMap {
    key: String
    value: AliasInfo
}

map AliasDetailsMap {
    key: String
    value: AliasDetails
}
