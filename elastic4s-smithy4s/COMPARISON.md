# Comparison: elastic4s-smithy4s vs elastic4s-domain

This document compares the Smithy4s approach with the traditional hand-written domain approach.

## Approach Overview

### Traditional Approach (elastic4s-domain)
Hand-written Scala case classes with Jackson annotations for JSON serialization.

### Smithy4s Approach (elastic4s-smithy4s)
Protocol-agnostic IDL specifications that generate type-safe Scala code with JSON codecs automatically.

## Example 1: Simple Response Model

### Traditional Approach (elastic4s-domain)

**File**: `elastic4s-domain/src/main/scala/com/sksamuel/elastic4s/requests/update/UpdateResponse.scala`

```scala
package com.sksamuel.elastic4s.requests.update

import com.fasterxml.jackson.annotation.JsonProperty
import com.sksamuel.elastic4s.requests.common.{DocumentRef, Shards}

case class UpdateResponse(
    @JsonProperty("_index") index: String,
    @JsonProperty("_id") id: String,
    @JsonProperty("_version") version: Long,
    @JsonProperty("_seq_no") seqNo: Long,
    @JsonProperty("_primary_term") primaryTerm: Long,
    result: String,
    @JsonProperty("forcedRefresh") forcedRefresh: Boolean,
    @JsonProperty("_shards") shards: Shards,
    private val get: Option[UpdateGet]
) {
  def ref: DocumentRef         = DocumentRef(index, id)
  def source: Map[String, Any] = get.flatMap(get => Option(get._source)).getOrElse(Map.empty)
  def found: Boolean           = get.forall(_.found)
}
```

**Characteristics**:
- Manual JSON field mapping with `@JsonProperty`
- Hand-written helper methods
- Depends on Jackson library
- No schema validation
- Manual maintenance required

### Smithy4s Approach

**File**: `elastic4s-smithy4s/src/main/smithy/update.smithy`

```smithy
$version: "2"

namespace com.sksamuel.elastic4s.smithy.update

use com.sksamuel.elastic4s.smithy.common#Shards

/// Response for update request
structure UpdateResponse {
    @jsonName("_index")
    @required
    index: String
    
    @jsonName("_type")
    type: String
    
    @jsonName("_id")
    @required
    id: String
    
    @jsonName("_version")
    version: Long
    
    @required
    result: String
    
    @jsonName("_shards")
    shards: Shards
    
    @jsonName("_seq_no")
    seqNo: Long
    
    @jsonName("_primary_term")
    primaryTerm: Long
    
    get: UpdateGet
}
```

**Generated Scala Code** (automatic):
```scala
package com.sksamuel.elastic4s.smithy.update

case class UpdateResponse(
  index: String,
  result: String,
  `type`: Option[String] = None,
  id: Option[String] = None,
  version: Option[Long] = None,
  shards: Option[Shards] = None,
  seqNo: Option[Long] = None,
  primaryTerm: Option[Long] = None,
  get: Option[UpdateGet] = None
)

object UpdateResponse extends ShapeTag.Companion[UpdateResponse] {
  val id: ShapeId = ShapeId("com.sksamuel.elastic4s.smithy.update", "UpdateResponse")
  
  val hints: Hints = Hints(/* ... */)
  
  implicit val schema: Schema[UpdateResponse] = struct(/* ... */)
  
  implicit val jsonCodec: JsonCodec[UpdateResponse] = /* auto-generated */
}
```

**Characteristics**:
- Protocol-agnostic Smithy specification
- Automatic code generation
- Built-in JSON codecs (no Jackson dependency)
- Schema validation via Smithy4s
- Type-safe by design
- Single source of truth

## Example 2: HTTP-Bound Service Operations

### Traditional Approach (elastic4s-handlers)

**File**: `elastic4s-handlers/src/main/scala/com/sksamuel/elastic4s/handlers/searches/SearchHandler.scala`

```scala
package com.sksamuel.elastic4s.handlers.searches

trait SearchHandler {
  def apply(request: SearchRequest): HttpEntity = {
    val endpoint = s"/${request.indexes.mkString(",")}/_search"
    val params = buildParams(request)
    val body = SearchBodyBuilderFn(request)
    
    HttpEntity(
      endpoint = endpoint,
      method = "POST",
      params = params,
      body = Some(body)
    )
  }
  
  private def buildParams(request: SearchRequest): Map[String, String] = {
    // Manual parameter building
    val map = scala.collection.mutable.Map.empty[String, String]
    request.routing.foreach(r => map.put("routing", r))
    request.preference.foreach(p => map.put("preference", p))
    // ... many more parameters
    map.toMap
  }
}
```

**Characteristics**:
- Manual HTTP endpoint construction
- Manual parameter mapping
- No type safety for HTTP layer
- Scattered across multiple files
- Error-prone URL construction

### Smithy4s Approach

**File**: `elastic4s-smithy4s/src/main/smithy/services/search.smithy`

```smithy
$version: "2"

namespace com.sksamuel.elastic4s.smithy.services

/// Elasticsearch Search Service
@title("Elasticsearch Search API")
service ElasticsearchSearchService {
    version: "9.0"
    operations: [Search]
}

/// HTTP-bound Search Request
structure SearchInput {
    @required
    @httpLabel
    index: String
    
    @required
    @httpPayload
    body: Document
    
    @httpQuery("routing")
    routing: String
    
    @httpQuery("preference")
    preference: String
    
    @httpQuery("timeout")
    timeout: String
}

/// Search for documents
@http(method: "POST", uri: "/{index}/_search")
operation Search {
    input: SearchInput
    output: SearchResponse
}
```

**Generated Service Trait** (automatic):
```scala
trait ElasticsearchSearchServiceGen[F[_, _, _, _, _]] {
  def search(
    index: String,
    body: Document,
    routing: Option[String] = None,
    preference: Option[String] = None,
    timeout: Option[String] = None
  ): F[SearchInput, Nothing, SearchResponse, Nothing, Nothing]
}

object ElasticsearchSearchService {
  val id: ShapeId = ShapeId("com.sksamuel.elastic4s.smithy.services", "ElasticsearchSearchService")
  
  // HTTP bindings automatically extracted from @http, @httpLabel, @httpQuery traits
  val endpoints: Vector[Endpoint[_, _, _, _, _]] = Vector(
    Endpoint(
      id = ShapeId("...", "Search"),
      method = Method.POST,
      uri = UriPattern("/{index}/_search"),
      queryParams = List("routing", "preference", "timeout"),
      // ... automatic parameter extraction
    )
  )
}
```

**Characteristics**:
- Declarative HTTP bindings in Smithy
- Type-safe path and query parameters
- Automatic endpoint generation
- HTTP semantics checked at compile time
- Single source of truth
- Compatible with smithy4s HTTP libraries (http4s, etc.)

## Example 3: Usage Comparison

### Traditional Approach

```scala
import com.sksamuel.elastic4s.ElasticDsl._
import com.sksamuel.elastic4s.requests.searches.SearchRequest

// Create request
val request = SearchRequest(
  indexes = Seq("myindex"),
  query = Some(matchQuery("title", "elasticsearch"))
)

// Manual handler invocation
val handler = SearchHandler()
val httpEntity = handler(request)

// Execute with HTTP client
client.execute(httpEntity).map { response =>
  // Manual JSON parsing
  val searchResponse = objectMapper.readValue(response.body, classOf[SearchResponse])
  searchResponse.hits.hits.foreach(hit => println(hit.source))
}
```

### Smithy4s Approach

```scala
import com.sksamuel.elastic4s.smithy.services._
import com.sksamuel.elastic4s.smithy.search._
import smithy4s.http4s.SimpleRestJsonBuilder
import cats.effect.IO

// Create service instance with smithy4s HTTP client
val serviceImpl: ElasticsearchSearchService[IO] = 
  SimpleRestJsonBuilder(ElasticsearchSearchService)
    .client(httpClient)
    .uri(uri"http://localhost:9200")
    .build

// Use service with type safety
serviceImpl.search(
  index = "myindex",
  body = Document.obj(
    "query" -> Document.obj(
      "match" -> Document.obj("title" -> Document.fromString("elasticsearch"))
    )
  ),
  routing = Some("user123"),
  preference = Some("_local")
).flatMap { response =>
  // Type-safe response
  response.hits.foreach { hits =>
    hits.hits.foreach(hit => IO.println(hit.source))
  }
}
```

**Or using just the generated types:**

```scala
import com.sksamuel.elastic4s.smithy.search._
import smithy4s.json.Json

// Create request with generated types
val searchRequest = SearchRequest(
  index = "myindex",
  query = Some(Document.obj(
    "match" -> Document.obj("title" -> Document.fromString("elasticsearch"))
  )),
  size = Some(10),
  from = Some(0)
)

// Automatic JSON serialization
val json = Json.writeToString(searchRequest)

// Automatic JSON deserialization  
val response = Json.readFromString[SearchResponse](responseJson)
```

## Benefits Summary

| Feature | Traditional | Smithy4s |
|---------|------------|----------|
| Code Generation | Manual | Automatic |
| JSON Codecs | Jackson (manual) | Built-in (automatic) |
| Schema Validation | None | Smithy4s runtime |
| HTTP Bindings | Manual handlers | Declarative (@http traits) |
| Type Safety | Case classes only | Full stack (data + HTTP) |
| Protocol Agnostic | No | Yes (Smithy IDL) |
| Multi-language | No | Yes (any Smithy generator) |
| Maintenance | High (manual updates) | Low (update Smithy specs) |
| Documentation | Comments | Machine-readable Smithy |
| HTTP Client Integration | Custom | smithy4s libraries (http4s, etc.) |
| Testability | Manual mocks | Generated schemas for testing |

## When to Use Each Approach

### Use Traditional Approach When:
- You need fine-grained control over serialization
- You have complex custom logic in domain objects
- You're already heavily invested in Jackson
- You don't need cross-language support

### Use Smithy4s Approach When:
- You want automatic code generation
- You need protocol-agnostic API definitions
- You want type-safe HTTP bindings
- You're building new microservices
- You want cross-language client generation
- You need better API documentation
- You want integration with smithy4s ecosystem (http4s, etc.)

## Migration Path

Both approaches can coexist. You can:
1. Use `elastic4s-smithy4s` for new features
2. Gradually migrate existing code from `elastic4s-domain`
3. Use Smithy specifications as documentation for `elastic4s-domain`

The Smithy specifications in `elastic4s-smithy4s` can serve as canonical API documentation even if you continue using the traditional approach.
