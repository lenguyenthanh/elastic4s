$version: "2"

namespace com.sksamuel.elastic4s.smithy.script

use com.sksamuel.elastic4s.smithy.common#StringList

/// Request to create or update a stored script
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
structure StoredScript {
    @required
    source: String
    
    lang: String
    params: ScriptParams
}

/// Request to get a stored script
structure GetStoredScriptRequest {
    @required
    id: String
    
    masterTimeout: String
}

/// Response for get stored script
structure GetStoredScriptResponse {
    @jsonName("_id")
    id: String
    
    found: Boolean
    script: StoredScript
}

/// Request to delete a stored script
structure DeleteStoredScriptRequest {
    @required
    id: String
    
    timeout: String
    masterTimeout: String
}

/// Response for delete stored script
structure DeleteStoredScriptResponse {
    acknowledged: Boolean
}

/// Search template request
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
structure PutSearchTemplateRequest {
    @required
    id: String
    
    @required
    script: TemplateScript
}

/// Template script
structure TemplateScript {
    @required
    source: String
    
    lang: String
}

/// Get search template request
structure GetSearchTemplateRequest {
    @required
    id: String
}

/// Delete search template request
structure DeleteSearchTemplateRequest {
    @required
    id: String
}

map ScriptParams {
    key: String
    value: Document
}

map TemplateParams {
    key: String
    value: Document
}
