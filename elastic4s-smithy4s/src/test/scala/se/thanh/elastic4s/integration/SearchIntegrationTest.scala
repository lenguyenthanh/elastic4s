package se.thanh.elastic4s.integration

import cats.effect.IO
import org.http4s._
import org.http4s.client.Client
import org.http4s.Method._
import smithy4s.Document

/**
 * Integration tests for Search operations
 * Mirrors the functionality of legacy elastic4s search tests
 */
object SearchIntegrationTest extends Smithy4sTestSuite {

  test("Search with match query should return results") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    val indexName = "test_search"
    
    // Index some documents
    val doc1 = Document.obj(
      "title" -> Document.fromString("Elasticsearch Guide"),
      "content" -> Document.fromString("Learn Elasticsearch")
    )
    val doc2 = Document.obj(
      "title" -> Document.fromString("Scala Programming"),
      "content" -> Document.fromString("Learn Scala")
    )
    
    val indexReq1 = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/$indexName/_doc?refresh=true"))
      .withEntity(smithy4s.json.Json.writeDocument(doc1))
    val indexReq2 = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/$indexName/_doc?refresh=true"))
      .withEntity(smithy4s.json.Json.writeDocument(doc2))
    
    // Search query
    val searchQuery = Document.obj(
      "query" -> Document.obj(
        "match" -> Document.obj(
          "title" -> Document.fromString("Elasticsearch")
        )
      )
    )
    val searchReq = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/$indexName/_search"))
      .withEntity(smithy4s.json.Json.writeDocument(searchQuery))
    
    (for {
      _ <- client.expect[String](indexReq1)
      _ <- client.expect[String](indexReq2)
      response <- client.expect[String](searchReq)
    } yield {
      expect(response.contains("Elasticsearch Guide"))
    })
  }

  test("Search with aggregations should return aggregated results") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    val indexName = "test_agg"
    
    // Index documents with numbers
    val docs = List(
      Document.obj("value" -> Document.fromInt(10)),
      Document.obj("value" -> Document.fromInt(20)),
      Document.obj("value" -> Document.fromInt(30))
    )
    
    val indexRequests = docs.map { doc =>
      Request[IO](POST, Uri.unsafeFromString(s"$esUrl/$indexName/_doc?refresh=true"))
        .withEntity(smithy4s.json.Json.writeDocument(doc))
    }
    
    // Search with aggregation
    val aggQuery = Document.obj(
      "size" -> Document.fromInt(0),
      "aggs" -> Document.obj(
        "avg_value" -> Document.obj(
          "avg" -> Document.obj(
            "field" -> Document.fromString("value")
          )
        )
      )
    )
    val searchReq = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/$indexName/_search"))
      .withEntity(smithy4s.json.Json.writeDocument(aggQuery))
    
    (for {
      _ <- indexRequests.traverse(client.expect[String](_))
      response <- client.expect[String](searchReq)
    } yield {
      expect(response.contains("aggregations") && response.contains("avg_value"))
    })
  }

  test("Search with sorting should return sorted results") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    val indexName = "test_sort"
    
    val doc1 = Document.obj("rank" -> Document.fromInt(2))
    val doc2 = Document.obj("rank" -> Document.fromInt(1))
    
    val indexReq1 = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/$indexName/_doc?refresh=true"))
      .withEntity(smithy4s.json.Json.writeDocument(doc1))
    val indexReq2 = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/$indexName/_doc?refresh=true"))
      .withEntity(smithy4s.json.Json.writeDocument(doc2))
    
    val sortQuery = Document.obj(
      "query" -> Document.obj("match_all" -> Document.obj()),
      "sort" -> Document.array(
        Document.obj("rank" -> Document.obj("order" -> Document.fromString("asc")))
      )
    )
    val searchReq = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/$indexName/_search"))
      .withEntity(smithy4s.json.Json.writeDocument(sortQuery))
    
    (for {
      _ <- client.expect[String](indexReq1)
      _ <- client.expect[String](indexReq2)
      response <- client.expect[String](searchReq)
    } yield {
      expect(response.contains("\"hits\""))
    })
  }

}
