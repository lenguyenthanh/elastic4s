package se.thanh.elastic4s.integration

import smithy4s.Document

/** Integration tests for the generated ElasticService using smithy4s http4s client */
object ElasticServiceIntegrationTest extends Smithy4sTestSuite {

  test("ElasticService - Index and Get document through generated service") { elasticService =>
    for {
      // Index a document using the generated service
      indexResponse <- elasticService.indexDocument(
                         index = "test-index",
                         id = "test-id-1",
                         body = Document.obj(
                           "title" -> Document.fromString("Smithy4s Test"),
                           "count" -> Document.fromInt(42)
                         )
                       )

      // Verify index response
      _ = expect(indexResponse.id == "test-id-1")
      _ = expect(indexResponse.index == "test-index")

      // Get the document back using the generated service
      getResponse <- elasticService.getDocument(
                       index = "test-index",
                       id = "test-id-1",
                       refresh = Some(true)
                     )

      // Verify get response
      _ = expect(getResponse.found)
      _ = expect(getResponse.id == "test-id-1")
      _ = expect(getResponse.index == "test-index")

    } yield expect(true)
  }

  test("health endpoint") { elasticService =>
    for {
      // Call health endpoint
      healthResponse <- elasticService.getClusterHealth()

      // Verify health response
      _ = expect(healthResponse.clusterName.isDefined)
      _ = expect(healthResponse.status.isDefined)

    } yield expect(true)
  }

}
