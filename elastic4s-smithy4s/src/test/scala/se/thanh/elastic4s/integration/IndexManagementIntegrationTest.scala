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
 * Integration tests for Index Management operations
 * Mirrors index management tests from elastic4s-tests
 */
class IndexManagementIntegrationTest extends AnyFlatSpec with Matchers with Smithy4sTestContainer {

  "CreateIndex operation" should "create an index with settings" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runCreateIndexTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  "DeleteIndex operation" should "delete an existing index" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runDeleteIndexTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  "OpenIndex and CloseIndex operations" should "open and close an index" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runOpenCloseTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  "RefreshIndex operation" should "refresh an index" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runRefreshTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  "GetIndexStats operation" should "retrieve index statistics" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runIndexStatsTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  private def runCreateIndexTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index with settings
      settings = """{
        "settings": {
          "number_of_shards": 1,
          "number_of_replicas": 0
        },
        "mappings": {
          "properties": {
            "title": {"type": "text"},
            "count": {"type": "integer"}
          }
        }
      }"""
      
      response <- httpRequest(client, PUT, s"$esUrl/create-index-test", Some(settings))
      
      // Verify index creation
      _ = println(s"Create index response: $response")
      
      // Check if index exists
      existsResponse <- httpRequest(client, HEAD, s"$esUrl/create-index-test", None)
      
    } yield response.contains("acknowledged") && !existsResponse.contains("Error"))
  }

  private def runDeleteIndexTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index
      _ <- httpRequest(client, PUT, s"$esUrl/delete-me", None)
      
      // Delete index
      response <- httpRequest(client, DELETE, s"$esUrl/delete-me", None)
      
      // Verify deletion
      _ = println(s"Delete index response: $response")
      
    } yield response.contains("acknowledged"))
  }

  private def runOpenCloseTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index
      _ <- httpRequest(client, PUT, s"$esUrl/open-close-test", None)
      
      // Close index
      closeResponse <- httpRequest(client, POST, s"$esUrl/open-close-test/_close", None)
      _ = println(s"Close index response: $closeResponse")
      
      // Open index
      openResponse <- httpRequest(client, POST, s"$esUrl/open-close-test/_open", None)
      _ = println(s"Open index response: $openResponse")
      
    } yield closeResponse.contains("acknowledged") && openResponse.contains("acknowledged"))
  }

  private def runRefreshTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index and add document
      _ <- httpRequest(client, PUT, s"$esUrl/refresh-test", None)
      _ <- httpRequest(client, POST, s"$esUrl/refresh-test/_doc/1", Some("""{"data":"test"}"""))
      
      // Refresh index
      response <- httpRequest(client, POST, s"$esUrl/refresh-test/_refresh", None)
      
      // Verify refresh
      _ = println(s"Refresh response: $response")
      
    } yield response.contains("_shards"))
  }

  private def runIndexStatsTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index with documents
      _ <- httpRequest(client, PUT, s"$esUrl/stats-test", None)
      _ <- httpRequest(client, POST, s"$esUrl/stats-test/_doc/1?refresh=true", Some("""{"data":"test"}"""))
      
      // Get index stats
      response <- httpRequest(client, GET, s"$esUrl/stats-test/_stats", None)
      
      // Verify stats
      _ = println(s"Index stats response: $response")
      
    } yield response.contains("_all") && response.contains("primaries"))
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
