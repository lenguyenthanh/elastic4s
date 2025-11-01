package examples

import com.sksamuel.elastic4s.smithy.update.UpdateResponse
import com.sksamuel.elastic4s.smithy.search.SearchRequest

/**
 * Example showing Smithy4s approach
 * 
 * This demonstrates the protocol-agnostic, code-generation approach
 * using Smithy IDL specifications.
 */
object Smithy4sExample {
  
  // Example 1: Using generated types
  def useGeneratedTypes(): Unit = {
    println("Smithy4s Approach: Auto-generated from Smithy specifications")
    println("=" * 60)
    
    // UpdateResponse is generated from update.smithy:
    //
    // structure UpdateResponse {
    //     @jsonName("_index")
    //     @required
    //     index: String
    //     
    //     @jsonName("_id")
    //     @required  
    //     id: String
    //     
    //     result: String
    //     ...
    // }
    
    val response = UpdateResponse(
      index = "myindex",
      id = "doc123",
      result = "updated",
      version = Some(2L),
      seqNo = Some(5L),
      primaryTerm = Some(1L)
    )
    
    println(s"Created response: $response")
    println("\nPros: Type-safe, auto-generated, no manual coding")
    println("Cons: Less flexibility than hand-written code")
  }
  
  // Example 2: Using HTTP-bound services
  def useHttpBoundService(): Unit = {
    println("\n\nSmithys4s Services: HTTP bindings from Smithy specs")
    println("=" * 60)
    
    // Service definition from services/search.smithy:
    //
    // @http(method: "POST", uri: "/{index}/_search")
    // operation Search {
    //     input: SearchInput
    //     output: SearchResponse
    // }
    //
    // structure SearchInput {
    //     @httpLabel index: String
    //     @httpPayload body: Document
    //     @httpQuery("routing") routing: String
    // }
    
    println("Service operations are automatically generated with HTTP bindings:")
    println("- Path parameters: @httpLabel")
    println("- Query parameters: @httpQuery")
    println("- Request body: @httpPayload")
    println("\nExample service method signature:")
    println("  def search(index: String, body: Document, routing: Option[String]): F[SearchResponse]")
    
    // The generated service can be used like this:
    // val service: ElasticsearchSearchService[IO] = 
    //   SimpleRestJsonBuilder(ElasticsearchSearchService)
    //     .client(httpClient)
    //     .uri(uri"http://localhost:9200")
    //     .build
    //
    // service.search(
    //   index = "myindex",
    //   body = searchQuery,
    //   routing = Some("user123")
    // )
    
    println("\nPros: Type-safe HTTP layer, automatic client generation")
    println("Cons: Requires smithy4s HTTP libraries (http4s)")
  }
  
  // Example 3: JSON serialization with smithy4s
  def jsonSerialization(): Unit = {
    println("\n\nSmithys4s JSON: Built-in codecs from schemas")
    println("=" * 60)
    
    val response = UpdateResponse(
      index = "myindex",
      id = "doc123",
      result = "updated",
      version = Some(2L)
    )
    
    // Smithy4s provides schemas for JSON encoding/decoding
    // The exact API depends on the integration library (http4s, etc.)
    println(s"Response: $response")
    println("\nThe generated UpdateResponse.schema provides:")
    println(s"  - Shape ID: ${UpdateResponse.schema.shapeId}")
    println(s"  - Compile-time schema for validation")
    println(s"  - Integration with smithy4s JSON libraries")
    
    println("\nPros: No Jackson dependency, automatic codecs, schema validation")
    println("Cons: Less control over serialization format")
  }
  
  // Example 4: Schema access for validation
  def schemaValidation(): Unit = {
    println("\n\nSmithys4s Schemas: Runtime schema access")
    println("=" * 60)
    
    // Every generated type has an implicit Schema
    import com.sksamuel.elastic4s.smithy.update.UpdateResponse
    
    val schema = UpdateResponse.schema
    println(s"Schema ID: ${schema.shapeId}")
    println(s"Hints: ${schema.hints}")
    
    println("\nThis enables:")
    println("- Runtime validation")
    println("- Generic serialization")
    println("- Schema evolution")
    println("- OpenAPI/Swagger generation")
  }
  
  def main(args: Array[String]): Unit = {
    useGeneratedTypes()
    useHttpBoundService()
    jsonSerialization()
    schemaValidation()
    
    println("\n" + "=" * 60)
    println("SUMMARY")
    println("=" * 60)
    println("Smithy4s provides:")
    println("✓ Automatic code generation from IDL")
    println("✓ Type-safe HTTP bindings")
    println("✓ Built-in JSON codecs")
    println("✓ Schema validation")
    println("✓ Protocol-agnostic specifications")
    println("✓ Cross-language support")
    println("✓ Integration with http4s ecosystem")
  }
}
