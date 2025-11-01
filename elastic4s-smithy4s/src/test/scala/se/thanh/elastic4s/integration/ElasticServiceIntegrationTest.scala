package se.thanh.elastic4s.integration

import cats.effect._
import cats.syntax.all._
import com.dimafeng.testcontainers.ElasticsearchContainer
import io.circe.Json
import io.circe.syntax._
import org.http4s._
import org.http4s.circe._
import org.http4s.client.Client
import org.http4s.ember.client.EmberClientBuilder
import org.http4s.implicits._
import se.thanh.elastic4cats._
import smithy4s.http4s.SimpleRestJsonBuilder
import weaver._

/** Integration tests for the generated ElasticService using smithy4s http4s client */
object ElasticServiceIntegrationTest extends Smithy4sTestSuite {

  test("ElasticService - Index and Get document through generated service") { case (container, httpClient) =>
    val esUrl = elasticsearchUrl(container)
    
    for {
      // Create smithy4s client for ElasticService
      elasticService <- createElasticServiceClient(httpClient, esUrl)
      
      // Index a document using the generated service
      indexInput = IndexDocumentInput(
        index = "test-index",
        id = "test-id-1",
        refresh = Some(true),
        document = Document(Json.obj(
          "title" -> "Smithy4s Test".asJson,
          "count" -> 42.asJson
        ))
      )
      indexResponse <- elasticService.indexDocument(indexInput)
      
      // Verify index response
      _ = expect(indexResponse.id == "test-id-1")
      _ = expect(indexResponse.index == "test-index")
      
      // Get the document back using the generated service
      getInput = GetDocumentInput(
        index = "test-index",
        id = "test-id-1",
        refresh = Some(true)
      )
      getResponse <- elasticService.getDocument(getInput)
      
      // Verify get response
      _ = expect(getResponse.found == true)
      _ = expect(getResponse.id == "test-id-1")
      _ = expect(getResponse.index == "test-index")
      
    } yield expect(getResponse.source.isDefined)
  }

  test("ElasticService - Search documents through generated service") { case (container, httpClient) =>
    val esUrl = elasticsearchUrl(container)
    
    for {
      elasticService <- createElasticServiceClient(httpClient, esUrl)
      
      // Create index and add documents
      createInput = CreateIndexInput(
        index = "search-index"
      )
      _ <- elasticService.createIndex(createInput)
      
      // Index test documents
      _ <- List(
        ("doc1", Json.obj("title" -> "Smithy4s is awesome".asJson)),
        ("doc2", Json.obj("title" -> "Http4s integration".asJson)),
        ("doc3", Json.obj("title" -> "Smithy4s with http4s".asJson))
      ).traverse { case (id, doc) =>
        elasticService.indexDocument(IndexDocumentInput(
          index = "search-index",
          id = id,
          refresh = Some(true),
          document = Document(doc)
        ))
      }
      
      // Search using the generated service
      searchInput = SearchInput(
        index = "search-index",
        query = Some(QueryContainer(Json.obj(
          "match" -> Json.obj(
            "title" -> "smithy4s".asJson
          ).asJson
        ).asJson)),
        size = Some(10)
      )
      searchResponse <- elasticService.search(searchInput)
      
      // Verify search results
      hits = searchResponse.hits.flatMap(_.hits).getOrElse(List.empty)
      
    } yield expect(hits.length >= 2)
  }

  test("ElasticService - Update document through generated service") { case (container, httpClient) =>
    val esUrl = elasticsearchUrl(container)
    
    for {
      elasticService <- createElasticServiceClient(httpClient, esUrl)
      
      // Index a document first
      _ <- elasticService.indexDocument(IndexDocumentInput(
        index = "update-index",
        id = "update-id",
        refresh = Some(true),
        document = Document(Json.obj("counter" -> 0.asJson))
      ))
      
      // Update using the generated service
      updateInput = UpdateDocumentInput(
        index = "update-index",
        id = "update-id",
        refresh = Some(RefreshPolicy.TRUE),
        doc = Some(Document(Json.obj("counter" -> 10.asJson)))
      )
      updateResponse <- elasticService.updateDocument(updateInput)
      
      // Verify update
      _ = expect(updateResponse.id == "update-id")
      
      // Get updated document
      getResponse <- elasticService.getDocument(GetDocumentInput(
        index = "update-index",
        id = "update-id"
      ))
      
    } yield expect(getResponse.found == true)
  }

  test("ElasticService - Delete document through generated service") { case (container, httpClient) =>
    val esUrl = elasticsearchUrl(container)
    
    for {
      elasticService <- createElasticServiceClient(httpClient, esUrl)
      
      // Index a document first
      _ <- elasticService.indexDocument(IndexDocumentInput(
        index = "delete-index",
        id = "delete-id",
        refresh = Some(true),
        document = Document(Json.obj("data" -> "to be deleted".asJson))
      ))
      
      // Delete using the generated service
      deleteInput = DeleteDocumentInput(
        index = "delete-index",
        id = "delete-id",
        refresh = Some(RefreshPolicy.TRUE)
      )
      deleteResponse <- elasticService.deleteDocument(deleteInput)
      
      // Verify deletion
      _ = expect(deleteResponse.result.exists(_ == "deleted"))
      
      // Try to get deleted document
      getResponse <- elasticService.getDocument(GetDocumentInput(
        index = "delete-index",
        id = "delete-id"
      ))
      
    } yield expect(getResponse.found == false)
  }

  test("ElasticService - Bulk operations through generated service") { case (container, httpClient) =>
    val esUrl = elasticsearchUrl(container)
    
    for {
      elasticService <- createElasticServiceClient(httpClient, esUrl)
      
      // Create bulk operations
      bulkInput = BulkOperationsInput(
        refresh = Some(RefreshPolicy.TRUE),
        operations = List(
          BulkOperation.IndexOp(BulkIndexOperation(
            index = Some("bulk-index"),
            id = Some("bulk-1"),
            document = Document(Json.obj("name" -> "Item 1".asJson))
          )),
          BulkOperation.IndexOp(BulkIndexOperation(
            index = Some("bulk-index"),
            id = Some("bulk-2"),
            document = Document(Json.obj("name" -> "Item 2".asJson))
          ))
        )
      )
      
      bulkResponse <- elasticService.bulkOperations(bulkInput)
      
      // Verify bulk response
      items = bulkResponse.items.getOrElse(List.empty)
      
    } yield expect(items.length == 2 && bulkResponse.errors == Some(false))
  }

  test("ElasticService - Index management through generated service") { case (container, httpClient) =>
    val esUrl = elasticsearchUrl(container)
    
    for {
      elasticService <- createElasticServiceClient(httpClient, esUrl)
      
      // Create index
      createResponse <- elasticService.createIndex(CreateIndexInput(
        index = "mgmt-index"
      ))
      _ = expect(createResponse.acknowledged == Some(true))
      
      // Refresh index
      refreshResponse <- elasticService.refreshIndex(RefreshIndexInput(
        index = "mgmt-index"
      ))
      _ = expect(refreshResponse.shards.isDefined)
      
      // Close index
      closeResponse <- elasticService.closeIndex(CloseIndexInput(
        index = "mgmt-index"
      ))
      _ = expect(closeResponse.acknowledged == Some(true))
      
      // Open index
      openResponse <- elasticService.openIndex(OpenIndexInput(
        index = "mgmt-index"
      ))
      _ = expect(openResponse.acknowledged == Some(true))
      
      // Delete index
      deleteResponse <- elasticService.deleteIndex(DeleteIndexInput(
        index = "mgmt-index"
      ))
      
    } yield expect(deleteResponse.acknowledged == Some(true))
  }

  test("ElasticService - Cluster operations through generated service") { case (container, httpClient) =>
    val esUrl = elasticsearchUrl(container)
    
    for {
      elasticService <- createElasticServiceClient(httpClient, esUrl)
      
      // Get cluster health
      healthResponse <- elasticService.getClusterHealth(GetClusterHealthInput())
      
      // Verify health response
      _ = expect(healthResponse.clusterName.isDefined)
      _ = expect(healthResponse.status.isDefined)
      
      // Get cluster stats
      statsResponse <- elasticService.getClusterStats(GetClusterStatsInput())
      
    } yield expect(statsResponse.clusterName.isDefined)
  }

  test("ElasticService - Count documents through generated service") { case (container, httpClient) =>
    val esUrl = elasticsearchUrl(container)
    
    for {
      elasticService <- createElasticServiceClient(httpClient, esUrl)
      
      // Index some documents
      _ <- List.range(0, 5).traverse { i =>
        elasticService.indexDocument(IndexDocumentInput(
          index = "count-index",
          id = s"doc-$i",
          refresh = Some(true),
          document = Document(Json.obj("value" -> i.asJson))
        ))
      }
      
      // Count documents
      countResponse <- elasticService.countDocuments(CountDocumentsInput(
        index = Some("count-index")
      ))
      
    } yield expect(countResponse.count == 5)
  }

  /** Create a smithy4s client for ElasticService using http4s */
  private def createElasticServiceClient(httpClient: Client[IO], baseUri: String): IO[ElasticService[IO]] = {
    val uri = Uri.unsafeFromString(baseUri)
    
    SimpleRestJsonBuilder(ElasticService)
      .client(httpClient)
      .uri(uri)
      .resource
      .use(client => IO.pure(client))
      .handleErrorWith { error =>
        IO.raiseError(new RuntimeException(s"Failed to create ElasticService client: ${error.getMessage}", error))
      }
  }
}
