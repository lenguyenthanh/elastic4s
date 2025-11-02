package se.thanh.elastic4s.integration

import se.thanh.elastic4cats._
import cats.effect.{IO, Resource}
import com.dimafeng.testcontainers.ElasticsearchContainer
import org.http4s.ember.client.EmberClientBuilder
import org.http4s.client.Client
import smithy4s.http4s.SimpleRestJsonBuilder
import weaver.IOSuite
import org.http4s.Uri

/** Base trait for Smithy4s integration tests using Weaver test framework Provides automatic Elasticsearch container
  * lifecycle management
  */
trait Smithy4sTestSuite extends IOSuite {

  /** Shared resource that creates an Elasticsearch container and HTTP client The container is started once for all
    * tests in the suite and stopped afterwards
    */
  override type Res = ElasticService[IO]

  override def sharedResource: Resource[IO, Res] = {

    ElasticSearchContainer.start.flatMap { uri =>
      EmberClientBuilder.default[IO].build.evalMap { client =>
        createElasticServiceClient(client, uri)
      }
    }
  }

  /** Helper to get the Elasticsearch URL from the container
    */
  def elasticsearchUrl(container: ElasticsearchContainer): String =
    s"http://${container.httpHostAddress}"

  private def createElasticServiceClient(httpClient: Client[IO], baseUri: Uri): IO[ElasticService[IO]] = {

    SimpleRestJsonBuilder(ElasticService)
      .client(httpClient)
      .uri(baseUri)
      .resource
      .use(client => IO.pure(client))
      .handleErrorWith { error =>
        IO.raiseError(new RuntimeException(s"Failed to create ElasticService client: ${error.getMessage}", error))
      }
  }
}

import cats.effect.{IO, Resource}
import com.dimafeng.testcontainers.GenericContainer
import org.testcontainers.containers.wait.strategy.Wait

object ElasticSearchContainer {

  private val PORT      = 9200
  private val container = {
    val env   = Map(
      "discovery.type"         -> "single-node",
      "http.cors.allow-origin" -> "/.*/",
      "http.cors.enabled"      -> "true",
      "xpack.security.enabled" -> "false"
    )
    val start = IO(
      GenericContainer(
        "elasticsearch:7.10.1",
        exposedPorts = Seq(PORT),
        waitStrategy = Wait.forListeningPort(),
        env = env
      )
    )
      .flatTap(cont => IO(cont.start()))
    Resource.make(start)(cont => IO(cont.stop()))
  }

  def parseConfig(container: GenericContainer): Uri =
    org.http4s.Uri.unsafeFromString(s"http://${container.host}:${container.mappedPort(PORT)}")

  def start: Resource[IO, Uri] =
    container.map(parseConfig)
}
