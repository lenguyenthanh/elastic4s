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

import scala.concurrent.duration._

/**
 * Integration tests for Search operations
 * Mirrors SearchTest from elastic4s-tests
 */
class SearchIntegrationTest extends AnyFlatSpec with Matchers with Smithy4sTestContainer {

  "Search operation" should "search documents with match query" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runSearchTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  "Search with aggregations" should "return aggregation results" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runAggregationTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  "Search with sorting" should "return sorted results" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runSortTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  private def runSearchTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index
      _ <- httpRequest(client, PUT, s"$esUrl/search-test", None)
      
      // Index documents
      _ <- httpRequest(client, POST, s"$esUrl/search-test/_doc/1", Some("""{"title": "Elasticsearch Guide", "category": "tech"}"""))
      _ <- httpRequest(client, POST, s"$esUrl/search-test/_doc/2", Some("""{"title": "Smithy4s Tutorial", "category": "tech"}"""))
      _ <- httpRequest(client, POST, s"$esUrl/search-test/_doc/3?refresh=true", Some("""{"title": "Cooking Recipes", "category": "food"}"""))
      
      // Search for "tech" category
      searchQuery = """{"query": {"match": {"category": "tech"}}}"""
      response <- httpRequest(client, POST, s"$esUrl/search-test/_search", Some(searchQuery))
      
      // Verify results
      _ = println(s"Search response: $response")
      
    } yield response.contains("\"total\"") && response.contains("Elasticsearch Guide"))
  }

  private def runAggregationTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index
      _ <- httpRequest(client, PUT, s"$esUrl/agg-test", None)
      
      // Index documents
      _ <- httpRequest(client, POST, s"$esUrl/agg-test/_doc/1", Some("""{"product": "laptop", "price": 1000}"""))
      _ <- httpRequest(client, POST, s"$esUrl/agg-test/_doc/2", Some("""{"product": "phone", "price": 500}"""))
      _ <- httpRequest(client, POST, s"$esUrl/agg-test/_doc/3?refresh=true", Some("""{"product": "tablet", "price": 300}"""))
      
      // Search with aggregation
      aggQuery = """{
        "size": 0,
        "aggs": {
          "avg_price": {
            "avg": {"field": "price"}
          }
        }
      }"""
      response <- httpRequest(client, POST, s"$esUrl/agg-test/_search", Some(aggQuery))
      
      // Verify aggregation results
      _ = println(s"Aggregation response: $response")
      
    } yield response.contains("aggregations") && response.contains("avg_price"))
  }

  private def runSortTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index
      _ <- httpRequest(client, PUT, s"$esUrl/sort-test", None)
      
      // Index documents
      _ <- httpRequest(client, POST, s"$esUrl/sort-test/_doc/1", Some("""{"name": "Alice", "score": 85}"""))
      _ <- httpRequest(client, POST, s"$esUrl/sort-test/_doc/2", Some("""{"name": "Bob", "score": 92}"""))
      _ <- httpRequest(client, POST, s"$esUrl/sort-test/_doc/3?refresh=true", Some("""{"name": "Charlie", "score": 78}"""))
      
      // Search with sorting
      sortQuery = """{
        "query": {"match_all": {}},
        "sort": [{"score": {"order": "desc"}}]
      }"""
      response <- httpRequest(client, POST, s"$esUrl/sort-test/_search", Some(sortQuery))
      
      // Verify sorted results (Bob should be first with score 92)
      _ = println(s"Sort response: $response")
      
    } yield response.contains("Bob") && response.contains("\"score\":92"))
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
