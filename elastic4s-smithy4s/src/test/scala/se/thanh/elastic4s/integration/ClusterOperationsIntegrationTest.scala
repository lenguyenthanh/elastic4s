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
 * Integration tests for Cluster operations
 * Mirrors ClusterStatsTest and ClusterStateTest from elastic4s-tests
 */
class ClusterOperationsIntegrationTest extends AnyFlatSpec with Matchers with Smithy4sTestContainer {

  "GetClusterHealth operation" should "retrieve cluster health" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runClusterHealthTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  "GetClusterStats operation" should "retrieve cluster statistics" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runClusterStatsTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  private def runClusterHealthTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Get cluster health
      response <- httpRequest(client, GET, s"$esUrl/_cluster/health", None)
      
      // Verify health response
      _ = println(s"Cluster health response: $response")
      
    } yield response.contains("cluster_name") && 
            response.contains("status") &&
            (response.contains("green") || response.contains("yellow") || response.contains("red")))
  }

  private def runClusterStatsTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Get cluster stats
      response <- httpRequest(client, GET, s"$esUrl/_cluster/stats", None)
      
      // Verify stats response
      _ = println(s"Cluster stats response: $response")
      
    } yield response.contains("cluster_name") && 
            response.contains("nodes") &&
            response.contains("indices"))
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
