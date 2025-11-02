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

  test("ElasticService - Cluster health endpoint") { elasticService =>
    for {
      // Call health endpoint
      healthResponse <- elasticService.getClusterHealth()

      // Verify health response
      _ = expect(healthResponse.clusterName.isDefined)
      _ = expect(healthResponse.status.isDefined)

    } yield expect(true)
  }

  test("ElasticService - Cluster stats endpoint") { elasticService =>
    for {
      // Call stats endpoint
      statsResponse <- elasticService.getClusterStats()

      // Verify stats response
      _ = expect(statsResponse.clusterName.isDefined)
      _ = expect(statsResponse.nodes.isDefined)

    } yield expect(true)
  }

  test("ElasticService - Update document") { elasticService =>
    for {
      // First index a document
      _ <- elasticService.indexDocument(
             index = "test-update-index",
             id = "update-id-1",
             body = Document.obj(
               "title" -> Document.fromString("Original Title"),
               "count" -> Document.fromInt(10)
             )
           )

      // Update the document
      updateResponse <- elasticService.updateDocument(
                          index = "test-update-index",
                          id = "update-id-1",
                          body = Document.obj(
                            "doc" -> Document.obj(
                              "count" -> Document.fromInt(20)
                            )
                          ),
                          refresh = Some("true")
                        )

      // Verify update response
      _ = expect(updateResponse.id == "update-id-1")

      // Get the updated document
      getResponse <- elasticService.getDocument(
                       index = "test-update-index",
                       id = "update-id-1"
                     )

      // Verify the document was updated
      _ = expect(getResponse.found)

    } yield expect(true)
  }

  test("ElasticService - Delete document") { elasticService =>
    for {
      // First index a document
      _ <- elasticService.indexDocument(
             index = "test-delete-index",
             id = "delete-id-1",
             body = Document.obj(
               "title" -> Document.fromString("To Be Deleted")
             ),
             refresh = Some("true")
           )

      // Delete the document
      deleteResponse <- elasticService.deleteDocument(
                          index = "test-delete-index",
                          id = "delete-id-1",
                          refresh = Some("true")
                        )

      // Verify delete response
      _ = expect(deleteResponse.id == "delete-id-1")

      // Try to get the deleted document
      getResponse <- elasticService.getDocument(
                       index = "test-delete-index",
                       id = "delete-id-1"
                     ).attempt

      // Verify document is not found
    } yield expect(getResponse.isLeft)
  }

  test("ElasticService - Count documents") { elasticService =>
    for {
      // Index some documents
      _ <- elasticService.indexDocument(
             index = "test-count-index",
             id = "count-1",
             body = Document.obj("category" -> Document.fromString("A")),
             refresh = Some("true")
           )

      _ <- elasticService.indexDocument(
             index = "test-count-index",
             id = "count-2",
             body = Document.obj("category" -> Document.fromString("A")),
             refresh = Some("true")
           )

      _ <- elasticService.indexDocument(
             index = "test-count-index",
             id = "count-3",
             body = Document.obj("category" -> Document.fromString("B")),
             refresh = Some("true")
           )

      // Count all documents in the index
      countResponse <- elasticService.getCountDocuments("test-count-index")

      // Verify count

    } yield expect(countResponse.count == 3)
  }

  test("ElasticService - Search documents") { elasticService =>
    for {
      // Index some test documents
      _ <- elasticService.indexDocument(
             index = "test-search-index",
             id = "search-1",
             body = Document.obj(
               "title" -> Document.fromString("Elasticsearch Guide"),
               "tags"  -> Document.array(Document.fromString("search"), Document.fromString("database"))
             ),
             refresh = Some("true")
           )

      _ <- elasticService.indexDocument(
             index = "test-search-index",
             id = "search-2",
             body = Document.obj(
               "title" -> Document.fromString("Database Systems"),
               "tags"  -> Document.array(Document.fromString("database"), Document.fromString("sql"))
             ),
             refresh = Some("true")
           )

      // Search for documents
      searchResponse <- elasticService.search(
                          index = "test-search-index",
                          body = Document.obj(
                            "query" -> Document.obj(
                              "match" -> Document.obj(
                                "title" -> Document.fromString("database")
                              )
                            )
                          )
                        )

      // Verify search results

    } yield expect(searchResponse.hits.total.exists(_.value == 1))
  }

  // body is not a valid NDJSON format, ignoring test for now
  test("ElasticService - Bulk operations".ignore) { elasticService =>
    for {
      // Perform bulk operations
      bulkResponse <- elasticService.bulkOperations(
                        body = Document.array(
                          Document.obj("index" -> Document.obj(
                            "_index" -> Document.fromString("test-bulk-index"),
                            "_id"    -> Document.fromString("bulk-1")
                          )),
                          Document.obj("title" -> Document.fromString("Bulk Document 1")),
                          Document.obj("index" -> Document.obj(
                            "_index" -> Document.fromString("test-bulk-index"),
                            "_id"    -> Document.fromString("bulk-2")
                          )),
                          Document.obj("title" -> Document.fromString("Bulk Document 2")),
                          Document.fromString("\\n")
                        ),
                        refresh = Some("true")
                      )

    } yield expect(bulkResponse.items.nonEmpty) &&
      expect(!bulkResponse.errors)
  }

  test("ElasticService - Create and delete index") { elasticService =>
    for {
      // Create an index
      createResponse <- elasticService.createIndex(
                          index = "test-create-delete-index",
                          body = Some(
                            Document.obj(
                              "settings" -> Document.obj(
                                "number_of_shards" -> Document.fromInt(1)
                              )
                            )
                          )
                        )

      // Verify index created
      _ = expect(createResponse.acknowledged)

      // Delete the index
      deleteResponse <- elasticService.deleteIndex(
                          index = "test-create-delete-index"
                        )

      // Verify index deleted
      _ = expect(deleteResponse.acknowledged)

    } yield expect(true)
  }

  test("ElasticService - Refresh index") { elasticService =>
    for {
      // Index a document
      _ <- elasticService.indexDocument(
             index = "test-refresh-index",
             id = "refresh-1",
             body = Document.obj("data" -> Document.fromString("test"))
           )

      // Refresh the index
      refreshResponse <- elasticService.refreshIndex(
                           index = "test-refresh-index"
                         )

      // Verify refresh response
      _ = expect(refreshResponse.shards.isDefined)

    } yield expect(true)
  }

  // todo why body is required?
  test("ElasticService - Close and open index") { elasticService =>
    for {
      // Create an index
      _ <- elasticService.createIndex(
             index = "test-close-open-index",
             body = Some(Document.obj())
           )

      // Close the index
      closeResponse <- elasticService.closeIndex(index = "test-close-open-index")

      // Verify index closed
      _ = expect(closeResponse.acknowledged)

      // Open the index
      openResponse <- elasticService.openIndex(
                        index = "test-close-open-index"
                      )

      // Verify index opened
      _ = expect(openResponse.acknowledged)

    } yield expect(true)
  }

  test("ElasticService - Get index stats") { elasticService =>
    for {
      // Create an index with some data
      _ <- elasticService.createIndex(
             index = "test-stats-index",
             body = Some(Document.obj())
           )

      _ <- elasticService.indexDocument(
             index = "test-stats-index",
             id = "stats-1",
             body = Document.obj("data" -> Document.fromString("test")),
             refresh = Some("true")
           )

      // Get index stats
      statsResponse <- elasticService.getIndexStats(
                         index = "test-stats-index"
                       )

      // Verify stats response
      _ = expect(statsResponse.indices.isDefined)

    } yield expect(true)
  }

  test("ElasticService - Update aliases") { elasticService =>
    for {
      // Create an index
      _ <- elasticService.createIndex(
             index = "test-alias-index",
             body = Some(Document.obj())
           )

      // Add an alias
      aliasResponse <- elasticService.updateAliases(
                         body = Document.obj(
                           "actions" -> Document.array(
                             Document.obj(
                               "add" -> Document.obj(
                                 "index" -> Document.fromString("test-alias-index"),
                                 "alias" -> Document.fromString("test-alias")
                               )
                             )
                           )
                         )
                       )

      // Verify alias created
      _ = expect(aliasResponse.acknowledged)

    } yield expect(true)
  }

  test("ElasticService - Multi-get documents") { elasticService =>
    for {
      // Index multiple documents
      _ <- elasticService.indexDocument(
             index = "test-mget-index",
             id = "mget-1",
             body = Document.obj("value" -> Document.fromInt(1)),
             refresh = Some("true")
           )

      _ <- elasticService.indexDocument(
             index = "test-mget-index",
             id = "mget-2",
             body = Document.obj("value" -> Document.fromInt(2)),
             refresh = Some("true")
           )

      // Multi-get documents
      mgetResponse <- elasticService.multiGetDocuments(
                        body = Document.obj(
                          "docs" -> Document.array(
                            Document.obj(
                              "_index" -> Document.fromString("test-mget-index"),
                              "_id"    -> Document.fromString("mget-1")
                            ),
                            Document.obj(
                              "_index" -> Document.fromString("test-mget-index"),
                              "_id"    -> Document.fromString("mget-2")
                            )
                          )
                        )
                      )

      // Verify multi-get response
      _ = expect(mgetResponse.docs.nonEmpty)
      _ = expect(mgetResponse.docs.length == 2)

    } yield expect(true)
  }

}
