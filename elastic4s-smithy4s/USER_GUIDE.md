# User Guide: Comparing Traditional vs Smithy4s Approaches

This guide shows **how end users interact with elastic4s** using both approaches for the same operations.

## Example 1: Indexing a Document

### Traditional Approach (elastic4s-client-esjava)

```scala
import com.sksamuel.elastic4s.ElasticDsl._
import com.sksamuel.elastic4s.{ElasticClient, ElasticProperties}
import com.sksamuel.elastic4s.http.JavaClient

// Create client
val client = ElasticClient(JavaClient(ElasticProperties("http://localhost:9200")))

// Index a document
val future = client.execute {
  indexInto("products").doc(
    "name" -> "iPhone 15",
    "price" -> 999.99,
    "category" -> "electronics"
  ).id("iphone-15")
}

// Handle response
future.map { response =>
  println(s"Document indexed: ${response.result.id}")
  println(s"Version: ${response.result.version}")
}
```

### Smithy4s Approach

```scala
import com.sksamuel.elastic4s.smithy.index.{IndexRequest, IndexResponse}
import com.sksamuel.elastic4s.smithy.services.ElasticsearchDocumentService
import smithy4s.http4s.SimpleRestJsonBuilder
import cats.effect.IO
import org.http4s.client.Client
import org.http4s.ember.client.EmberClientBuilder

// Create HTTP client and service
val serviceIO = EmberClientBuilder.default[IO].build.use { httpClient =>
  val service = SimpleRestJsonBuilder(ElasticsearchDocumentService)
    .client(httpClient)
    .uri(uri"http://localhost:9200")
    .build

  // Index a document
  service.indexDocument(
    index = "products",
    id = Some("iphone-15"),
    body = Document.obj(
      "name" -> Document.fromString("iPhone 15"),
      "price" -> Document.fromDouble(999.99),
      "category" -> Document.fromString("electronics")
    )
  )
}

// Handle response
serviceIO.map { response =>
  println(s"Document indexed: ${response.id}")
  println(s"Version: ${response.version}")
}
```

**User Experience:**
- **Traditional**: DSL-based, familiar to existing users, less boilerplate
- **Smithy4s**: More explicit types, requires http4s knowledge, type-safe HTTP layer

---

## Example 2: Searching Documents

### Traditional Approach

```scala
import com.sksamuel.elastic4s.ElasticDsl._

// Execute search
val searchFuture = client.execute {
  search("products")
    .query(matchQuery("category", "electronics"))
    .size(10)
    .from(0)
}

// Process results
searchFuture.map { response =>
  response.result.hits.hits.foreach { hit =>
    println(s"Product: ${hit.sourceAsMap("name")}")
    println(s"Price: ${hit.sourceAsMap("price")}")
  }
}
```

### Smithy4s Approach

```scala
import com.sksamuel.elastic4s.smithy.search.{SearchRequest, Query}
import com.sksamuel.elastic4s.smithy.services.ElasticsearchSearchService

val searchService = SimpleRestJsonBuilder(ElasticsearchSearchService)
  .client(httpClient)
  .uri(uri"http://localhost:9200")
  .build

// Execute search
val searchIO = searchService.search(
  index = "products",
  body = Document.obj(
    "query" -> Document.obj(
      "match" -> Document.obj(
        "category" -> Document.fromString("electronics")
      )
    ),
    "size" -> Document.fromInt(10),
    "from" -> Document.fromInt(0)
  )
)

// Process results
searchIO.map { response =>
  response.hits.foreach { hits =>
    hits.hits.foreach { hit =>
      hit.source.foreach { source =>
        // Access fields from Document
        println(s"Product: ${source.asObject.flatMap(_("name"))}")
        println(s"Price: ${source.asObject.flatMap(_("price"))}")
      }
    }
  }
}
```

**User Experience:**
- **Traditional**: Query DSL is fluent and intuitive, easy source access
- **Smithy4s**: More verbose JSON construction, strongly typed Documents

---

## Example 3: Updating a Document

### Traditional Approach

```scala
import com.sksamuel.elastic4s.ElasticDsl._

// Update document
val updateFuture = client.execute {
  updateById("products", "iphone-15")
    .doc("price" -> 899.99)
    .refreshImmediately
}

// Handle response
updateFuture.map { response =>
  println(s"Updated: ${response.result.result}")
  println(s"New version: ${response.result.version}")
}
```

### Smithy4s Approach

```scala
import com.sksamuel.elastic4s.smithy.update.{UpdateRequest, UpdateResponse}

// Update document (using generated types directly)
// Note: This would require creating an UpdateService similar to above
import smithy4s.json.Json

val updateRequest = UpdateRequest(
  index = "products",
  id = "iphone-15",
  doc = Some(Document.obj(
    "price" -> Document.fromDouble(899.99)
  )),
  refreshPolicy = Some(RefreshPolicy.TRUE)
)

// With service (if we had UpdateService in services/)
// val updateIO = updateService.update(...)

// Without service, you'd use the generated types for serialization:
val requestJson = Json.writeToString(updateRequest)
// ... send via HTTP client manually
```

**User Experience:**
- **Traditional**: Clean DSL, minimal code, immediate execution
- **Smithy4s**: Requires explicit request construction, benefits from type safety

---

## Example 4: Bulk Operations

### Traditional Approach

```scala
import com.sksamuel.elastic4s.ElasticDsl._

// Bulk operations
val bulkFuture = client.execute {
  bulk(
    indexInto("products").doc("name" -> "iPad Pro", "price" -> 799.99),
    indexInto("products").doc("name" -> "MacBook Air", "price" -> 1199.99),
    deleteById("products", "old-product-123")
  ).refreshImmediately
}

// Handle response
bulkFuture.map { response =>
  println(s"Bulk completed in ${response.result.took}ms")
  println(s"Errors: ${response.result.hasFailures}")
}
```

### Smithy4s Approach

```scala
import com.sksamuel.elastic4s.smithy.bulk._

val bulkRequest = BulkRequest(
  operations = List(
    BulkOperation.IndexOp(BulkIndexOperation(
      index = Some("products"),
      doc = Document.obj(
        "name" -> Document.fromString("iPad Pro"),
        "price" -> Document.fromDouble(799.99)
      )
    )),
    BulkOperation.IndexOp(BulkIndexOperation(
      index = Some("products"),
      doc = Document.obj(
        "name" -> Document.fromString("MacBook Air"),
        "price" -> Document.fromDouble(1199.99)
      )
    )),
    BulkOperation.DeleteOp(BulkDeleteOperation(
      index = Some("products"),
      id = "old-product-123"
    ))
  ),
  refresh = Some(RefreshPolicy.TRUE)
)

// Use generated schema for JSON serialization
// Then send via HTTP client
```

**User Experience:**
- **Traditional**: Concise DSL syntax, easy to read and write
- **Smithy4s**: More verbose but explicit types, union types for operations

---

## Example 5: Creating an Index with Mappings

### Traditional Approach

```scala
import com.sksamuel.elastic4s.ElasticDsl._

// Create index with mappings
val createFuture = client.execute {
  createIndex("products").mapping(
    properties(
      textField("name").boost(2.0),
      keywordField("category"),
      doubleField("price"),
      dateField("created_at")
    )
  ).shards(3).replicas(1)
}

createFuture.map { response =>
  println(s"Index created: ${response.result.acknowledged}")
}
```

### Smithy4s Approach

```scala
import com.sksamuel.elastic4s.smithy.indices._
import com.sksamuel.elastic4s.smithy.services.ElasticsearchIndexService

val indexService = SimpleRestJsonBuilder(ElasticsearchIndexService)
  .client(httpClient)
  .uri(uri"http://localhost:9200")
  .build

val createIO = indexService.createIndex(
  index = "products",
  body = Some(CreateIndexRequest(
    settings = Some(IndexSettings(
      numberOfShards = Some(3),
      numberOfReplicas = Some(1)
    )),
    mappings = Some(Mappings(
      properties = Some(Map(
        "name" -> Property.TextField(TextProperty(boost = Some(2.0))),
        "category" -> Property.KeywordField(KeywordProperty()),
        "price" -> Property.DoubleField(DoubleProperty()),
        "created_at" -> Property.DateField(DateProperty())
      ))
    ))
  ))
)

createIO.map { response =>
  println(s"Index created: ${response.acknowledged}")
}
```

**User Experience:**
- **Traditional**: Declarative DSL, natural Scala syntax
- **Smithy4s**: More structural, requires understanding of generated types

---

## Comparison Summary

| Aspect | Traditional | Smithy4s |
|--------|------------|----------|
| **Setup** | Simple: `ElasticClient` + properties | Complex: HTTP client + service builder |
| **Query Building** | Fluent DSL (`matchQuery`, `termQuery`) | JSON `Document` construction |
| **Type Safety** | Request-level types | End-to-end types (request + HTTP) |
| **Learning Curve** | Low (familiar DSL) | Medium-High (http4s + Smithy concepts) |
| **Verbosity** | Low (concise DSL) | Medium (explicit types) |
| **IDE Support** | Good (auto-complete on DSL) | Excellent (generated types) |
| **Error Messages** | Runtime JSON errors | Compile-time type errors |
| **Dependencies** | elastic4s-client | smithy4s + http4s |
| **Ecosystem** | elastic4s ecosystem | smithy4s + http4s ecosystem |

## When to Choose Each Approach

### Choose Traditional Approach When:
✅ You're building a standard Elasticsearch application  
✅ You want minimal boilerplate and quick setup  
✅ You prefer DSL-style query building  
✅ Your team is already familiar with elastic4s  
✅ You don't need cross-language API definitions  

### Choose Smithy4s Approach When:
✅ You need protocol-agnostic API definitions  
✅ You want maximum type safety (compile-time validation)  
✅ You're building microservices with http4s  
✅ You want to generate clients in multiple languages  
✅ You need machine-readable API contracts  
✅ You prefer explicit over implicit (less magic)  

## Migration Example

You can use both approaches side-by-side:

```scala
// Traditional for quick operations
val quickSearch = client.execute {
  search("products").matchAllQuery().size(100)
}

// Smithy4s for type-safe critical operations
val criticalUpdate = updateService.update(
  index = "products",
  id = criticalProductId,
  body = validatedUpdateRequest  // Type-checked at compile time
)
```

## Conclusion

**Traditional Approach**: Optimized for developer experience with a fluent DSL that makes common operations concise and readable. Best for most Elasticsearch use cases.

**Smithy4s Approach**: Optimized for type safety and protocol independence. Best when you need stronger compile-time guarantees, cross-language support, or integration with the http4s ecosystem.

Both approaches are valid and can coexist in the same codebase for gradual migration or different use cases.
