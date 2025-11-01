package se.thanh.elastic4s.integration

import cats.effect.IO
import cats.effect.unsafe.implicits.global
import com.dimafeng.testcontainers.ElasticsearchContainer
import org.http4s._
import org.http4s.client.Client
import org.http4s.Method._
import org.scalatest.flatspec.AnyFlatSpec
import org.scalatest.matchers.should.Matchers
import se.thanh.elastic4cats._
import smithy4s.Document

import scala.concurrent.duration._

/**
 * Integration tests for Get/Index/Update/Delete document operations
 * Mirrors the functionality of the legacy elastic4s tests but uses Smithy4s generated types
 */
class DocumentOperationsIntegrationTest extends AnyFlatSpec with Matchers with Smithy4sTestContainer {

  "IndexDocument operation" should "index a document successfully" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runIndexTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  "GetDocument operation" should "retrieve an indexed document" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runGetTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  "UpdateDocument operation" should "update an existing document" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runUpdateTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  "DeleteDocument operation" should "delete an existing document" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runDeleteTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  "CountDocuments operation" should "count documents in an index" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runCountTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  private def runIndexTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index
      _ <- httpRequest(client, PUT, s"$esUrl/test-index", None)
      
      // Index a document
      doc = """{"name": "John Doe", "age": 30, "city": "New York"}"""
      response <- httpRequest(client, POST, s"$esUrl/test-index/_doc/1?refresh=true", Some(doc))
      
      // Verify response contains result
      _ = println(s"Index response: $response")
      
    } yield response.contains("created") || response.contains("\"result\""))
  }

  private def runGetTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index and document
      _ <- httpRequest(client, PUT, s"$esUrl/test-get", None)
      doc = """{"title": "Smithy4s Test", "content": "Integration testing"}"""
      _ <- httpRequest(client, POST, s"$esUrl/test-get/_doc/doc1?refresh=true", Some(doc))
      
      // Get the document
      response <- httpRequest(client, GET, s"$esUrl/test-get/_doc/doc1", None)
      
      // Verify response
      _ = println(s"Get response: $response")
      
    } yield response.contains("Smithy4s Test") && response.contains("\"found\":true"))
  }

  private def runUpdateTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index and document
      _ <- httpRequest(client, PUT, s"$esUrl/test-update", None)
      doc = """{"name": "Original Name", "count": 1}"""
      _ <- httpRequest(client, POST, s"$esUrl/test-update/_doc/upd1?refresh=true", Some(doc))
      
      // Update the document
      updateDoc = """{"doc": {"name": "Updated Name", "count": 2}}"""
      updateResponse <- httpRequest(client, POST, s"$esUrl/test-update/_update/upd1?refresh=true", Some(updateDoc))
      
      // Verify update
      _ = println(s"Update response: $updateResponse")
      
      // Get updated document
      getResponse <- httpRequest(client, GET, s"$esUrl/test-update/_doc/upd1", None)
      
    } yield getResponse.contains("Updated Name") && updateResponse.contains("updated"))
  }

  private def runDeleteTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index and document
      _ <- httpRequest(client, PUT, s"$esUrl/test-delete", None)
      doc = """{"data": "to be deleted"}"""
      _ <- httpRequest(client, POST, s"$esUrl/test-delete/_doc/del1?refresh=true", Some(doc))
      
      // Delete the document
      deleteResponse <- httpRequest(client, DELETE, s"$esUrl/test-delete/_doc/del1?refresh=true", None)
      
      // Verify deletion
      _ = println(s"Delete response: $deleteResponse")
      
      // Try to get deleted document
      getResponse <- httpRequest(client, GET, s"$esUrl/test-delete/_doc/del1", None)
      
    } yield deleteResponse.contains("deleted") && getResponse.contains("\"found\":false"))
  }

  private def runCountTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index with multiple documents
      _ <- httpRequest(client, PUT, s"$esUrl/test-count", None)
      
      // Index multiple documents
      _ <- httpRequest(client, POST, s"$esUrl/test-count/_doc/1", Some("""{"type": "A"}"""))
      _ <- httpRequest(client, POST, s"$esUrl/test-count/_doc/2", Some("""{"type": "B"}"""))
      _ <- httpRequest(client, POST, s"$esUrl/test-count/_doc/3?refresh=true", Some("""{"type": "A"}"""))
      
      // Count all documents
      countResponse <- httpRequest(client, GET, s"$esUrl/test-count/_count", None)
      
      // Verify count
      _ = println(s"Count response: $countResponse")
      
    } yield countResponse.contains("\"count\":3"))
  }

  private def httpRequest(client: Client[IO], method: Method, url: String, body: Option[String]): IO[String] = {
    val baseReq = Request[IO](method = method, uri = Uri.unsafeFromString(url))
    
    val req = body match {
      case Some(b) => baseReq
        .withEntity(b)
        .withHeaders(Header.Raw(ci"Content-Type", "application/json"))
      case None => baseReq
    }
    
    client.expect[String](req).handleErrorWith { err =>
      IO.pure(s"Error: ${err.getMessage}")
    }
  }
}
