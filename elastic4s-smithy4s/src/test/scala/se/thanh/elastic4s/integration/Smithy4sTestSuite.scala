package se.thanh.elastic4s.integration

import cats.effect.{IO, Resource}
import com.dimafeng.testcontainers.ElasticsearchContainer
import org.http4s.ember.client.EmberClientBuilder
import org.http4s.client.Client
import org.testcontainers.utility.DockerImageName
import weaver.IOSuite

/**
 * Base trait for Smithy4s integration tests using Weaver test framework
 * Provides automatic Elasticsearch container lifecycle management
 */
trait Smithy4sTestSuite extends IOSuite {

  /**
   * Shared resource that creates an Elasticsearch container and HTTP client
   * The container is started once for all tests in the suite and stopped afterwards
   */
  override type Res = (ElasticsearchContainer, Client[IO])

  override def sharedResource: Resource[IO, Res] = {
    Resource.make {
      IO {
        val imageName = DockerImageName.parse("docker.elastic.co/elasticsearch/elasticsearch:8.11.0")
          .asCompatibleSubstituteFor("docker.elastic.co/elasticsearch/elasticsearch")
        
        val container = ElasticsearchContainer(imageName)
        container.start()
        container
      }.flatMap { container =>
        EmberClientBuilder.default[IO].build.allocated.map { case (client, _) =>
          (container, client)
        }
      }
    } { case (container, _) =>
      IO(container.stop())
    }
  }

  /**
   * Helper to get the Elasticsearch URL from the container
   */
  def elasticsearchUrl(container: ElasticsearchContainer): String =
    s"http://${container.httpHostAddress}"

}
