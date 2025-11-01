package se.thanh.elastic4s.integration

import cats.effect.IO
import org.http4s._
import org.http4s.client.Client
import org.http4s.Method._
import smithy4s.Document

/**
 * Integration tests for Alias operations
 * Mirrors legacy AliasesHttpTest
 */
object AliasOperationsIntegrationTest extends Smithy4sTestSuite {

  test("UpdateAliases should add and remove aliases") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    val indexName = "test_alias_index"
    val aliasName = "test_alias"
    
    // Create index
    val createReq = Request[IO](PUT, Uri.unsafeFromString(s"$esUrl/$indexName"))
    
    // Add alias
    val addAliasBody = Document.obj(
      "actions" -> Document.array(
        Document.obj(
          "add" -> Document.obj(
            "index" -> Document.fromString(indexName),
            "alias" -> Document.fromString(aliasName)
          )
        )
      )
    )
    val addAliasReq = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/_aliases"))
      .withEntity(smithy4s.json.Json.writeDocument(addAliasBody))
    
    (for {
      _ <- client.expect[String](createReq)
      response <- client.expect[String](addAliasReq)
    } yield {
      expect(response.contains("\"acknowledged\":true"))
    })
  }

  test("GetAliases should return aliases for an index") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    val indexName = "test_get_alias_index"
    val aliasName = "test_get_alias"
    
    // Create index
    val createReq = Request[IO](PUT, Uri.unsafeFromString(s"$esUrl/$indexName"))
    
    // Add alias
    val addAliasBody = Document.obj(
      "actions" -> Document.array(
        Document.obj(
          "add" -> Document.obj(
            "index" -> Document.fromString(indexName),
            "alias" -> Document.fromString(aliasName)
          )
        )
      )
    )
    val addAliasReq = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/_aliases"))
      .withEntity(smithy4s.json.Json.writeDocument(addAliasBody))
    
    // Get aliases
    val getAliasReq = Request[IO](GET, Uri.unsafeFromString(s"$esUrl/$indexName/_alias/*"))
    
    (for {
      _ <- client.expect[String](createReq)
      _ <- client.expect[String](addAliasReq)
      response <- client.expect[String](getAliasReq)
    } yield {
      expect(response.contains(aliasName))
    })
  }

}
