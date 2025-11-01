package se.thanh.elastic4s.integration

import cats.effect.{IO, Resource}
import com.dimafeng.testcontainers.ElasticsearchContainer
import com.dimafeng.testcontainers.scalatest.TestContainerForAll
import org.http4s.ember.client.EmberClientBuilder
import org.http4s.client.Client
import org.scalatest.Suite
import org.testcontainers.utility.DockerImageName

import scala.concurrent.duration._

/**
 * Base trait for Smithy4s integration tests using Testcontainers
 */
trait Smithy4sTestContainer extends TestContainerForAll { self: Suite =>
  
  override val containerDef = ElasticsearchContainer.Def(
    dockerImageName = DockerImageName.parse("docker.elastic.co/elasticsearch/elasticsearch:8.11.0"),
    exposedPorts = Seq(9200),
    env = Map(
      "discovery.type" -> "single-node",
      "xpack.security.enabled" -> "false",
      "ES_JAVA_OPTS" -> "-Xms512m -Xmx512m"
    )
  )

  /**
   * Get the Elasticsearch HTTP endpoint URL
   */
  def elasticsearchUrl(container: ElasticsearchContainer): String = {
    s"http://${container.host}:${container.mappedPort(9200)}"
  }

  /**
   * Create an HTTP4s client for making requests to Elasticsearch
   */
  def createHttp4sClient: Resource[IO, Client[IO]] = {
    EmberClientBuilder
      .default[IO]
      .withTimeout(30.seconds)
      .withIdleTimeInPool(60.seconds)
      .build
  }
}
