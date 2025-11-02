$version: "2"

namespace se.thanh.elastic4cats

use smithy4s.meta#bincompatFriendly

/// Request to create or update a stored script
@bincompatFriendly
structure PutStoredScriptRequest {
    @required
    id: String

    @required
    script: StoredScript

    timeout: String
    masterTimeout: String
    context: String
}

/// Stored script
@bincompatFriendly
structure StoredScript {
    @required
    source: String

    lang: String
    params: ScriptParams
}

/// Request to get a stored script
@bincompatFriendly
structure GetStoredScriptRequest {
    @required
    id: String

    masterTimeout: String
}

/// Response for get stored script
@bincompatFriendly
structure GetStoredScriptResponse {
    @jsonName("_id")
    id: String

    found: Boolean
    script: StoredScript
}

/// Request to delete a stored script
@bincompatFriendly
structure DeleteStoredScriptRequest {
    @required
    id: String

    timeout: String
    masterTimeout: String
}

/// Response for delete stored script
@bincompatFriendly
structure DeleteStoredScriptResponse {
    @required
    acknowledged: Boolean
}

/// Search template request
@bincompatFriendly
structure SearchTemplateRequest {
    @required
    indexes: StringList

    @required
    source: String

    params: TemplateParams
    explain: Boolean
    profile: Boolean
}

/// Put search template request
@bincompatFriendly
structure PutSearchTemplateRequest {
    @required
    id: String

    @required
    script: TemplateScript
}

/// Template script
@bincompatFriendly
structure TemplateScript {
    @required
    source: String

    lang: String
}

/// Get search template request
@bincompatFriendly
structure GetSearchTemplateRequest {
    @required
    id: String
}

/// Delete search template request
@bincompatFriendly
structure DeleteSearchTemplateRequest {
    @required
    id: String
}

map TemplateParams {
    key: String
    value: Document
}
