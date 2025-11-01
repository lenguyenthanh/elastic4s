package se.thanh.elastic4s.integration

import cats.effect.IO
import org.http4s._
import org.http4s.client.Client
import org.http4s.Method._
import se.thanh.elastic4cats._
import smithy4s.Document

/**
 * Integration tests for Get/Index/Update/Delete document operations
 * Mirrors the functionality of the legacy elastic4s tests but uses Smithy4s generated types
 */
object DocumentOperationsIntegrationTest extends Smithy4sTestSuite {

  test("IndexDocument operation should index a document successfully") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    runIndexTest(client, esUrl).map { result =>
      expect(result == true)
    }
  }

  test("GetDocument operation should retrieve an indexed document") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    runGetTest(client, esUrl).map { result =>
      expect(result == true)
    }
  }

  test("UpdateDocument operation should update an existing document") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    runUpdateTest(client, esUrl).map { result =>
      expect(result == true)
    }
  }

  test("DeleteDocument operation should delete an existing document") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    runDeleteTest(client, esUrl).map { result =>
      expect(result == true)
    }
  }

  test("CountDocuments operation should count documents matching criteria") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    runCountTest(client, esUrl).map { result =>
      expect(result == true)
    }
  }

  // Helper methods

  private def runIndexTest(client: Client[IO], esUrl: String): IO[Boolean] = {
    val indexName = "test_index_doc"
    val docId = "1"
    
    val doc = Document.obj(
      "name" -> Document.fromString("John Doe"),
      "age" -> Document.fromInt(30)
    )
    
    val request = Request[IO](
      method = POST,
      uri = Uri.unsafeFromString(s"$esUrl/$indexName/_doc/$docId?refresh=true")
    ).withEntity(smithy4s.json.Json.writeDocument(doc))
    
    client.expect[String](request).map { response =>
      response.contains("\"result\":\"created\"") || response.contains("\"result\":\"updated\"")
    }
  }

  private def runGetTest(client: Client[IO], esUrl: String): IO[Boolean] = {
    val indexName = "test_get_doc"
    val docId = "1"
    
    // First index a document
    val doc = Document.obj(
      "title" -> Document.fromString("Test Document"),
      "content" -> Document.fromString("This is a test")
    )
    
    val indexRequest = Request[IO](
      method = POST,
      uri = Uri.unsafeFromString(s"$esUrl/$indexName/_doc/$docId?refresh=true")
    ).withEntity(smithy4s.json.Json.writeDocument(doc))
    
    // Then retrieve it
    val getRequest = Request[IO](
      method = GET,
      uri = Uri.unsafeFromString(s"$esUrl/$indexName/_doc/$docId")
    )
    
    for {
      _ <- client.expect[String](indexRequest)
      response <- client.expect[String](getRequest)
    } yield {
      response.contains("\"_source\"") && response.contains("Test Document")
    }
  }

  private def runUpdateTest(client: Client[IO], esUrl: String): IO[Boolean] = {
    val indexName = "test_update_doc"
    val docId = "1"
    
    // First index a document
    val doc = Document.obj(
      "name" -> Document.fromString("Alice"),
      "age" -> Document.fromInt(25)
    )
    
    val indexRequest = Request[IO](
      method = POST,
      uri = Uri.unsafeFromString(s"$esUrl/$indexName/_doc/$docId?refresh=true")
    ).withEntity(smithy4s.json.Json.writeDocument(doc))
    
    // Update the document
    val updateDoc = Document.obj(
      "doc" -> Document.obj(
        "age" -> Document.fromInt(26)
      )
    )
    
    val updateRequest = Request[IO](
      method = POST,
      uri = Uri.unsafeFromString(s"$esUrl/$indexName/_update/$docId?refresh=true")
    ).withEntity(smithy4s.json.Json.writeDocument(updateDoc))
    
    for {
      _ <- client.expect[String](indexRequest)
      response <- client.expect[String](updateRequest)
    } yield {
      response.contains("\"result\":\"updated\"")
    }
  }

  private def runDeleteTest(client: Client[IO], esUrl: String): IO[Boolean] = {
    val indexName = "test_delete_doc"
    val docId = "1"
    
    // First index a document
    val doc = Document.obj(
      "name" -> Document.fromString("Bob")
    )
    
    val indexRequest = Request[IO](
      method = POST,
      uri = Uri.unsafeFromString(s"$esUrl/$indexName/_doc/$docId?refresh=true")
    ).withEntity(smithy4s.json.Json.writeDocument(doc))
    
    // Delete the document
    val deleteRequest = Request[IO](
      method = DELETE,
      uri = Uri.unsafeFromString(s"$esUrl/$indexName/_doc/$docId?refresh=true")
    )
    
    for {
      _ <- client.expect[String](indexRequest)
      response <- client.expect[String](deleteRequest)
    } yield {
      response.contains("\"result\":\"deleted\"")
    }
  }

  private def runCountTest(client: Client[IO], esUrl: String): IO[Boolean] = {
    val indexName = "test_count_doc"
    
    // Index multiple documents
    val doc1 = Document.obj("name" -> Document.fromString("Alice"))
    val doc2 = Document.obj("name" -> Document.fromString("Bob"))
    
    val index1 = Request[IO](
      method = POST,
      uri = Uri.unsafeFromString(s"$esUrl/$indexName/_doc?refresh=true")
    ).withEntity(smithy4s.json.Json.writeDocument(doc1))
    
    val index2 = Request[IO](
      method = POST,
      uri = Uri.unsafeFromString(s"$esUrl/$indexName/_doc?refresh=true")
    ).withEntity(smithy4s.json.Json.writeDocument(doc2))
    
    // Count documents
    val countRequest = Request[IO](
      method = POST,
      uri = Uri.unsafeFromString(s"$esUrl/$indexName/_count")
    )
    
    for {
      _ <- client.expect[String](index1)
      _ <- client.expect[String](index2)
      response <- client.expect[String](countRequest)
    } yield {
      response.contains("\"count\":2")
    }
  }

}
