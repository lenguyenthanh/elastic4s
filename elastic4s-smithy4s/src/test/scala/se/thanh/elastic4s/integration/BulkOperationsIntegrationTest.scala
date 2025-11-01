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

/**
 * Integration tests for Bulk operations
 * Mirrors BulkTest from elastic4s-tests
 */
class BulkOperationsIntegrationTest extends AnyFlatSpec with Matchers with Smithy4sTestContainer {

  "Bulk operations" should "index multiple documents" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runBulkIndexTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  "Bulk operations" should "perform mixed operations" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runMixedBulkTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  private def runBulkIndexTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index
      _ <- httpRequest(client, PUT, s"$esUrl/bulk-test", None)
      
      // Bulk index documents (NDJSON format)
      bulkBody = """{"index":{"_index":"bulk-test","_id":"1"}}
{"name":"Document 1","value":100}
{"index":{"_index":"bulk-test","_id":"2"}}
{"name":"Document 2","value":200}
{"index":{"_index":"bulk-test","_id":"3"}}
{"name":"Document 3","value":300}
"""
      
      response <- httpRequest(client, POST, s"$esUrl/_bulk?refresh=true", Some(bulkBody))
      
      // Verify bulk response
      _ = println(s"Bulk response: $response")
      
      // Count documents
      countResponse <- httpRequest(client, GET, s"$esUrl/bulk-test/_count", None)
      
    } yield response.contains("\"errors\":false") && countResponse.contains("\"count\":3"))
  }

  private def runMixedBulkTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index and add initial documents
      _ <- httpRequest(client, PUT, s"$esUrl/mixed-bulk", None)
      _ <- httpRequest(client, POST, s"$esUrl/mixed-bulk/_doc/existing", Some("""{"status":"old"}"""))
      _ <- httpRequest(client, POST, s"$esUrl/mixed-bulk/_doc/to-delete?refresh=true", Some("""{"status":"temporary"}"""))
      
      // Perform mixed bulk operations: index, update, delete
      bulkBody = """{"index":{"_index":"mixed-bulk","_id":"new1"}}
{"status":"new"}
{"update":{"_index":"mixed-bulk","_id":"existing"}}
{"doc":{"status":"updated"}}
{"delete":{"_index":"mixed-bulk","_id":"to-delete"}}
"""
      
      response <- httpRequest(client, POST, s"$esUrl/_bulk?refresh=true", Some(bulkBody))
      
      // Verify operations
      _ = println(s"Mixed bulk response: $response")
      
      // Verify updated document
      getResponse <- httpRequest(client, GET, s"$esUrl/mixed-bulk/_doc/existing", None)
      
      // Verify deleted document
      delResponse <- httpRequest(client, GET, s"$esUrl/mixed-bulk/_doc/to-delete", None)
      
    } yield response.contains("\"errors\":false") && 
            getResponse.contains("updated") && 
            delResponse.contains("\"found\":false"))
  }

  private def httpRequest(client: Client[IO], method: Method, url: String, body: Option[String]): IO[String] = {
    val baseReq = Request[IO](method = method, uri = Uri.unsafeFromString(url))
    
    val req = body match {
      case Some(b) => baseReq
        .withEntity(b)
        .withHeaders(Header.Raw(ci"Content-Type", "application/x-ndjson"))
      case None => baseReq
    }
    
    client.expect[String](req).handleErrorWith { err =>
      IO.pure(s"Error: ${err.getMessage}")
    }
  }
}
