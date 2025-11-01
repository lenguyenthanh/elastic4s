package se.thanh.elastic4s.integration

import cats.effect.IO
import org.http4s._
import org.http4s.client.Client
import org.http4s.Method._

/**
 * Integration tests for Cluster operations
 * Mirrors legacy ClusterStatsTest and ClusterStateTest
 */
object ClusterOperationsIntegrationTest extends Smithy4sTestSuite {

  test("GetClusterHealth should return cluster health status") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    val healthReq = Request[IO](GET, Uri.unsafeFromString(s"$esUrl/_cluster/health"))
    
    client.expect[String](healthReq).map { response =>
      expect(
        response.contains("\"status\":\"green\"") ||
        response.contains("\"status\":\"yellow\"") ||
        response.contains("\"status\":\"red\"")
      )
    }
  }

  test("GetClusterStats should return cluster statistics") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    val statsReq = Request[IO](GET, Uri.unsafeFromString(s"$esUrl/_cluster/stats"))
    
    client.expect[String](statsReq).map { response =>
      expect(response.contains("\"cluster_name\"") && response.contains("\"nodes\""))
    }
  }

}
