package se.thanh.elastic4s.integration

import cats.effect.IO
import org.http4s._
import org.http4s.client.Client
import org.http4s.Method._
import smithy4s.Document

/**
 * Integration tests for Bulk operations
 * Mirrors the functionality of legacy elastic4s BulkTest
 */
object BulkOperationsIntegrationTest extends Smithy4sTestSuite {

  test("Bulk index should index multiple documents") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    val indexName = "test_bulk_index"
    
    // NDJSON format for bulk request
    val bulkBody = 
      s"""{"index":{"_index":"$indexName","_id":"1"}}
         |{"name":"Alice"}
         |{"index":{"_index":"$indexName","_id":"2"}}
         |{"name":"Bob"}
         |""".stripMargin
    
    val bulkReq = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/_bulk?refresh=true"))
      .withEntity(bulkBody)
      .withHeaders(Header.Raw(headers.`Content-Type`.name, "application/x-ndjson"))
    
    client.expect[String](bulkReq).map { response =>
      expect(response.contains("\"errors\":false"))
    }
  }

  test("Bulk mixed operations should handle index, update, and delete") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    val indexName = "test_bulk_mixed"
    
    // First, create a document to update/delete
    val doc = Document.obj("name" -> Document.fromString("Initial"))
    val createReq = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/$indexName/_doc/1?refresh=true"))
      .withEntity(smithy4s.json.Json.writeDocument(doc))
    
    // Mixed bulk operations
    val bulkBody = 
      s"""{"index":{"_index":"$indexName","_id":"2"}}
         |{"name":"New"}
         |{"update":{"_index":"$indexName","_id":"1"}}
         |{"doc":{"name":"Updated"}}
         |{"delete":{"_index":"$indexName","_id":"3"}}
         |""".stripMargin
    
    val bulkReq = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/_bulk?refresh=true"))
      .withEntity(bulkBody)
      .withHeaders(Header.Raw(headers.`Content-Type`.name, "application/x-ndjson"))
    
    (for {
      _ <- client.expect[String](createReq)
      response <- client.expect[String](bulkReq)
    } yield {
      expect(response.contains("\"items\""))
    })
  }

}
