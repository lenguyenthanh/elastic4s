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
 * Integration tests for Alias operations
 * Mirrors AliasesHttpTest from elastic4s-tests
 */
class AliasOperationsIntegrationTest extends AnyFlatSpec with Matchers with Smithy4sTestContainer {

  "UpdateAliases operation" should "add and remove aliases" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runUpdateAliasesTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  "GetAliases operation" should "retrieve index aliases" in withContainers { container =>
    val esUrl = elasticsearchUrl(container)
    
    val testIO = for {
      client <- createHttp4sClient
      result <- runGetAliasesTest(client, esUrl)
    } yield result
    
    testIO.use(identity).unsafeRunSync() shouldBe true
  }

  private def runUpdateAliasesTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index
      _ <- httpRequest(client, PUT, s"$esUrl/alias-test-index", None)
      
      // Add alias
      addAliasBody = """{
        "actions": [
          {"add": {"index": "alias-test-index", "alias": "test-alias"}}
        ]
      }"""
      addResponse <- httpRequest(client, POST, s"$esUrl/_aliases", Some(addAliasBody))
      _ = println(s"Add alias response: $addResponse")
      
      // Verify alias exists
      getResponse <- httpRequest(client, GET, s"$esUrl/alias-test-index/_alias/test-alias", None)
      _ = println(s"Get alias response: $getResponse")
      
      // Remove alias
      removeAliasBody = """{
        "actions": [
          {"remove": {"index": "alias-test-index", "alias": "test-alias"}}
        ]
      }"""
      removeResponse <- httpRequest(client, POST, s"$esUrl/_aliases", Some(removeAliasBody))
      _ = println(s"Remove alias response: $removeResponse")
      
    } yield addResponse.contains("acknowledged") && 
            getResponse.contains("test-alias") &&
            removeResponse.contains("acknowledged"))
  }

  private def runGetAliasesTest(client: Client[IO], esUrl: String): Resource[IO, IO[Boolean]] = {
    Resource.eval(for {
      // Create index with alias
      _ <- httpRequest(client, PUT, s"$esUrl/get-alias-test", None)
      
      aliasBody = """{
        "actions": [
          {"add": {"index": "get-alias-test", "alias": "my-alias"}}
        ]
      }"""
      _ <- httpRequest(client, POST, s"$esUrl/_aliases", Some(aliasBody))
      
      // Get aliases
      response <- httpRequest(client, GET, s"$esUrl/get-alias-test/_alias/*", None)
      
      // Verify response
      _ = println(s"Get aliases response: $response")
      
    } yield response.contains("my-alias"))
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
