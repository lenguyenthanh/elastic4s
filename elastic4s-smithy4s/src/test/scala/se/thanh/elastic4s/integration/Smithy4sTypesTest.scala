package se.thanh.elastic4s.integration

import se.thanh.elastic4cats._
import smithy4s.Document
import weaver.SimpleIOSuite

/**
 * Demonstrates usage of Smithy4s generated types
 * Shows comprehensive examples of request construction with generated types
 */
object Smithy4sTypesTest extends SimpleIOSuite {

  test("RefreshPolicy enum should have all expected values") {
    expect(RefreshPolicy.values.nonEmpty)
  }

  test("HealthStatus enum should have all expected values") {
    val statuses = HealthStatus.values
    expect(statuses.exists(_.value == "green")) and
    expect(statuses.exists(_.value == "yellow")) and
    expect(statuses.exists(_.value == "red"))
  }

  test("IndexRequest should be constructable with all fields") {
    val doc = Document.obj("field" -> Document.fromString("value"))
    val request = IndexRequest(
      index = "test-index",
      id = Some("doc-1"),
      document = Some(doc),
      refresh = Some("true"),
      routing = Some("routing-key")
    )
    expect(request.index == "test-index") and
    expect(request.id.contains("doc-1"))
  }

  test("GetRequest should be constructable with optional parameters") {
    val request = GetRequest(
      index = "test-index",
      id = "doc-1",
      routing = Some("routing-key"),
      refresh = Some(true)
    )
    expect(request.index == "test-index") and
    expect(request.id == "doc-1")
  }

  test("UpdateRequest should support script updates") {
    val script = Script(
      source = "ctx._source.counter += params.count",
      lang = Some("painless"),
      params = Some(Document.obj("count" -> Document.fromInt(1)))
    )
    val request = UpdateRequest(
      index = "test-index",
      id = "doc-1",
      script = Some(script),
      refresh = Some("true")
    )
    expect(request.script.isDefined) and
    expect(request.script.get.source.contains("counter"))
  }

  test("DeleteRequest should be constructable") {
    val request = DeleteRequest(
      index = "test-index",
      id = "doc-1",
      refresh = Some("true")
    )
    expect(request.index == "test-index")
  }

  test("SearchRequest should support complex queries") {
    val query = Document.obj(
      "match" -> Document.obj(
        "title" -> Document.fromString("elasticsearch")
      )
    )
    val request = SearchRequest(
      index = "test-index",
      query = Some(query),
      size = Some(10),
      from = Some(0)
    )
    expect(request.query.isDefined) and
    expect(request.size.contains(10))
  }

  test("BulkRequest should support multiple operation types") {
    val indexOp = BulkOperation.IndexOpCase(
      IndexOp(
        index = Some("test-index"),
        id = Some("1")
      )
    )
    val request = BulkRequest(
      operations = List(indexOp),
      refresh = Some("true")
    )
    expect(request.operations.nonEmpty)
  }

  test("CountRequest should be constructable with query") {
    val query = Document.obj(
      "term" -> Document.obj(
        "status" -> Document.fromString("published")
      )
    )
    val request = CountRequest(
      index = "test-index",
      query = Some(query)
    )
    expect(request.query.isDefined)
  }

  test("Document structures should be reusable across requests") {
    val fetchSource = FetchSourceContext(
      fetchSource = true,
      includes = Some(List("field1", "field2")),
      excludes = Some(List("field3"))
    )
    
    val getRequest = GetRequest(
      index = "test-index",
      id = "doc-1",
      source = Some(fetchSource)
    )
    
    expect(getRequest.source.isDefined) and
    expect(getRequest.source.get.includes.exists(_.contains("field1")))
  }

}
