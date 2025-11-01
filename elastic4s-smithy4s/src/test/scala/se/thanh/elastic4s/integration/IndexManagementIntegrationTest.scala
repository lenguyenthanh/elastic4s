package se.thanh.elastic4s.integration

import cats.effect.IO
import org.http4s._
import org.http4s.client.Client
import org.http4s.Method._
import smithy4s.Document

/**
 * Integration tests for Index Management operations
 * Mirrors legacy elastic4s index management tests
 */
object IndexManagementIntegrationTest extends Smithy4sTestSuite {

  test("CreateIndex should create an index with mappings and settings") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    val indexName = "test_create_index"
    
    val createBody = Document.obj(
      "settings" -> Document.obj(
        "number_of_shards" -> Document.fromInt(1),
        "number_of_replicas" -> Document.fromInt(0)
      ),
      "mappings" -> Document.obj(
        "properties" -> Document.obj(
          "title" -> Document.obj("type" -> Document.fromString("text"))
        )
      )
    )
    
    val createReq = Request[IO](PUT, Uri.unsafeFromString(s"$esUrl/$indexName"))
      .withEntity(smithy4s.json.Json.writeDocument(createBody))
    
    client.expect[String](createReq).map { response =>
      expect(response.contains("\"acknowledged\":true"))
    }
  }

  test("DeleteIndex should delete an existing index") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    val indexName = "test_delete_index"
    
    // First create the index
    val createReq = Request[IO](PUT, Uri.unsafeFromString(s"$esUrl/$indexName"))
    val deleteReq = Request[IO](DELETE, Uri.unsafeFromString(s"$esUrl/$indexName"))
    
    (for {
      _ <- client.expect[String](createReq)
      response <- client.expect[String](deleteReq)
    } yield {
      expect(response.contains("\"acknowledged\":true"))
    })
  }

  test("OpenIndex should open a closed index") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    val indexName = "test_open_index"
    
    val createReq = Request[IO](PUT, Uri.unsafeFromString(s"$esUrl/$indexName"))
    val closeReq = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/$indexName/_close"))
    val openReq = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/$indexName/_open"))
    
    (for {
      _ <- client.expect[String](createReq)
      _ <- client.expect[String](closeReq)
      response <- client.expect[String](openReq)
    } yield {
      expect(response.contains("\"acknowledged\":true"))
    })
  }

  test("CloseIndex should close an open index") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    val indexName = "test_close_index"
    
    val createReq = Request[IO](PUT, Uri.unsafeFromString(s"$esUrl/$indexName"))
    val closeReq = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/$indexName/_close"))
    
    (for {
      _ <- client.expect[String](createReq)
      response <- client.expect[String](closeReq)
    } yield {
      expect(response.contains("\"acknowledged\":true"))
    })
  }

  test("RefreshIndex should refresh an index") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    val indexName = "test_refresh_index"
    
    val createReq = Request[IO](PUT, Uri.unsafeFromString(s"$esUrl/$indexName"))
    val refreshReq = Request[IO](POST, Uri.unsafeFromString(s"$esUrl/$indexName/_refresh"))
    
    (for {
      _ <- client.expect[String](createReq)
      response <- client.expect[String](refreshReq)
    } yield {
      expect(response.contains("\"_shards\""))
    })
  }

  test("GetIndexStats should return index statistics") { case (container, client) =>
    val esUrl = elasticsearchUrl(container)
    val indexName = "test_stats_index"
    
    val createReq = Request[IO](PUT, Uri.unsafeFromString(s"$esUrl/$indexName"))
    val statsReq = Request[IO](GET, Uri.unsafeFromString(s"$esUrl/$indexName/_stats"))
    
    (for {
      _ <- client.expect[String](createReq)
      response <- client.expect[String](statsReq)
    } yield {
      expect(response.contains("\"_all\"") || response.contains("\"indices\""))
    })
  }

}
