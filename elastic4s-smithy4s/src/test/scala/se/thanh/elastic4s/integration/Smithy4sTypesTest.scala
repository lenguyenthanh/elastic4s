package se.thanh.elastic4s.integration

import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import se.thanh.elastic4cats._
import smithy4s.Document

/**
 * Unit tests demonstrating usage of Smithy4s generated types
 * Complements the existing Smithy4sBasicTest with more comprehensive examples
 */
class Smithy4sTypesTest extends AnyFlatSpec with Matchers {

  "GetRequest" should "be constructed with all parameters" in {
    val request = GetRequest(
      index = "products",
      id = "prod-123",
      routing = Some("user-456"),
      preference = Some("_primary"),
      refresh = Some(true),
      realtime = Some(false),
      storedFields = Some(List("name", "price")),
      version = Some(5L),
      versionType = Some(VersionType.EXTERNAL)
    )
    
    request.index shouldBe "products"
    request.id shouldBe "prod-123"
    request.routing shouldBe Some("user-456")
    request.version shouldBe Some(5L)
    request.versionType shouldBe Some(VersionType.EXTERNAL)
  }

  "IndexRequest" should "support document indexing with options" in {
    val doc = Document.obj(
      "title" -> Document.fromString("Smithy4s Guide"),
      "author" -> Document.fromString("Developer"),
      "tags" -> Document.array(Document.fromString("scala"), Document.fromString("smithy"))
    )
    
    val request = IndexRequest(
      index = "articles",
      source = doc,
      id = Some("article-1"),
      routing = Some("section-tech"),
      refreshPolicy = Some(RefreshPolicy.IMMEDIATE),
      timeout = Some("30s"),
      version = Some(1L),
      versionType = Some(VersionType.INTERNAL)
    )
    
    request.index shouldBe "articles"
    request.id shouldBe Some("article-1")
    request.refreshPolicy shouldBe Some(RefreshPolicy.IMMEDIATE)
  }

  "UpdateRequest" should "support document updates with scripts" in {
    val script = Script(
      source = "ctx._source.counter += params.count",
      lang = Some("painless"),
      params = Some(Document.obj("count" -> Document.fromInt(1)))
    )
    
    val request = UpdateRequest(
      index = "counters",
      id = "counter-1",
      script = Some(script),
      upsert = Some(Document.obj("counter" -> Document.fromInt(0))),
      refreshPolicy = Some(RefreshPolicy.WAIT_FOR),
      retryOnConflict = Some(3)
    )
    
    request.index shouldBe "counters"
    request.id shouldBe "counter-1"
    request.script.isDefined shouldBe true
    request.retryOnConflict shouldBe Some(3)
  }

  "DeleteByIdRequest" should "support conditional deletes" in {
    val request = DeleteByIdRequest(
      index = "documents",
      id = "doc-to-delete",
      routing = Some("shard-1"),
      version = Some(2L),
      versionType = Some(VersionType.EXTERNAL),
      refreshPolicy = Some(RefreshPolicy.IMMEDIATE),
      timeout = Some("10s")
    )
    
    request.index shouldBe "documents"
    request.id shouldBe "doc-to-delete"
    request.version shouldBe Some(2L)
  }

  "CountRequest" should "support count with query" in {
    val query = Document.obj(
      "match" -> Document.obj(
        "status" -> Document.fromString("active")
      )
    )
    
    val request = CountRequest(
      indexes = List("users", "profiles"),
      query = Some(query),
      minScore = Some(1.0)
    )
    
    request.indexes shouldBe List("users", "profiles")
    request.query.isDefined shouldBe true
    request.minScore shouldBe Some(1.0)
  }

  "SearchRequest" should "support complex search with aggregations" in {
    val query = Document.obj(
      "bool" -> Document.obj(
        "must" -> Document.array(
          Document.obj("term" -> Document.obj("status" -> Document.fromString("published")))
        )
      )
    )
    
    val aggs = Document.obj(
      "categories" -> Document.obj(
        "terms" -> Document.obj("field" -> Document.fromString("category.keyword"))
      )
    )
    
    val request = SearchRequest(
      index = "articles",
      query = Some(query),
      from = Some(0),
      size = Some(20),
      sort = Some(List(Document.obj("date" -> Document.obj("order" -> Document.fromString("desc"))))),
      aggregations = Some(aggs),
      trackTotalHits = Some(true),
      timeout = Some("5s")
    )
    
    request.index shouldBe "articles"
    request.from shouldBe Some(0)
    request.size shouldBe Some(20)
    request.query.isDefined shouldBe true
    request.aggregations.isDefined shouldBe true
  }

  "BulkRequest" should "support mixed operations" in {
    val indexOp = BulkOperation.IndexOp(BulkIndexOperation(
      index = Some("products"),
      id = Some("prod-1"),
      source = Document.obj("name" -> Document.fromString("Product 1"))
    ))
    
    val updateOp = BulkOperation.UpdateOp(BulkUpdateOperation(
      index = Some("products"),
      id = Some("prod-2"),
      doc = Some(Document.obj("price" -> Document.fromDouble(29.99)))
    ))
    
    val deleteOp = BulkOperation.DeleteOp(BulkDeleteOperation(
      index = Some("products"),
      id = Some("prod-3")
    ))
    
    val request = BulkRequest(
      operations = List(indexOp, updateOp, deleteOp),
      refresh = Some(RefreshPolicy.IMMEDIATE),
      timeout = Some("30s")
    )
    
    request.operations.length shouldBe 3
    request.refresh shouldBe Some(RefreshPolicy.IMMEDIATE)
  }

  "CreateIndexRequest" should "support index creation with settings and mappings" in {
    val settings = IndexSettings(
      numberOfShards = Some(3),
      numberOfReplicas = Some(1),
      refreshInterval = Some("5s")
    )
    
    val properties = Document.obj(
      "title" -> Document.obj("type" -> Document.fromString("text")),
      "count" -> Document.obj("type" -> Document.fromString("integer")),
      "timestamp" -> Document.obj("type" -> Document.fromString("date"))
    )
    
    val mappings = Mappings(properties = Some(properties))
    
    val request = CreateIndexRequest(
      index = "my-index",
      settings = Some(settings),
      mappings = Some(mappings)
    )
    
    request.index shouldBe "my-index"
    request.settings.isDefined shouldBe true
    request.mappings.isDefined shouldBe true
  }

  "Enums" should "have correct string values" in {
    RefreshPolicy.NONE.value shouldBe "false"
    RefreshPolicy.IMMEDIATE.value shouldBe "true"
    RefreshPolicy.WAIT_FOR.value shouldBe "wait_for"
    
    VersionType.INTERNAL.value shouldBe "internal"
    VersionType.EXTERNAL.value shouldBe "external"
    VersionType.EXTERNAL_GTE.value shouldBe "external_gte"
    VersionType.FORCE.value shouldBe "force"
    
    HealthStatus.GREEN.value shouldBe "green"
    HealthStatus.YELLOW.value shouldBe "yellow"
    HealthStatus.RED.value shouldBe "red"
  }

  "Common structures" should "be reusable across operations" in {
    val docRef = DocumentRef(
      index = "test-index",
      id = "doc-id",
      routing = Some("routing-key")
    )
    
    docRef.index shouldBe "test-index"
    docRef.id shouldBe "doc-id"
    
    val shards = Shards(
      total = Some(5),
      successful = Some(5),
      skipped = Some(0),
      failed = Some(0)
    )
    
    shards.total shouldBe Some(5)
    shards.successful shouldBe Some(5)
    
    val fetchSource = FetchSourceContext(
      fetchSource = true,
      includes = Some(List("field1", "field2")),
      excludes = Some(List("internal.*"))
    )
    
    fetchSource.fetchSource shouldBe true
    fetchSource.includes.get.length shouldBe 2
  }
}
