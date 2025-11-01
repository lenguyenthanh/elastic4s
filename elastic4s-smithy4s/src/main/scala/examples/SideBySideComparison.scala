package examples

import com.sksamuel.elastic4s.smithy.search.{SearchRequest, SearchResponse}
import com.sksamuel.elastic4s.smithy.update.UpdateResponse

/**
 * Side-by-side comparison of both approaches with runnable examples
 */
object SideBySideComparison {

  def main(args: Array[String]): Unit = {
    println("=" * 80)
    println("SIDE-BY-SIDE COMPARISON: Traditional vs Smithy4s")
    println("=" * 80)
    
    example1_TypeDefinitions()
    example2_JsonSerialization()
    example3_TypeSafety()
    example4_Documentation()
  }
  
  def example1_TypeDefinitions(): Unit = {
    println("\n1. TYPE DEFINITIONS")
    println("-" * 80)
    
    println("\nTraditional (elastic4s-domain):")
    println("""
      |// Hand-written Scala case class
      |case class UpdateResponse(
      |  @JsonProperty("_index") index: String,
      |  @JsonProperty("_id") id: String,
      |  @JsonProperty("_version") version: Long,
      |  result: String,
      |  @JsonProperty("_shards") shards: Shards
      |)
      |
      |// Requires: Manual coding, Jackson annotations, maintenance
    """.stripMargin)
    
    println("\nSmithy4s (elastic4s-smithy4s):")
    println("""
      |// Smithy IDL specification (update.smithy)
      |structure UpdateResponse {
      |    @jsonName("_index")
      |    @required
      |    index: String
      |    
      |    @jsonName("_id")
      |    @required
      |    id: String
      |    
      |    @jsonName("_version")
      |    version: Long
      |    
      |    result: String
      |}
      |
      |// Auto-generates: Scala case class, Schema, JSON codecs
      |// Result: Less code, single source of truth
    """.stripMargin)
  }
  
  def example2_JsonSerialization(): Unit = {
    println("\n2. JSON SERIALIZATION")
    println("-" * 80)
    
    // Smithy4s example
    val response = UpdateResponse(
      index = "products",
      id = "123",
      result = "updated",
      version = Some(5L),
      seqNo = Some(10L),
      primaryTerm = Some(1L)
    )
    
    println("\nSmithy4s (auto-generated schema & codecs):")
    println(s"Response: $response")
    println(s"Schema: ${UpdateResponse.schema.shapeId}")
    println("✓ No Jackson configuration needed")
    println("✓ Type-safe serialization via generated schemas")
    println("✓ Schema validation built-in")
    println("✓ Integration with smithy4s JSON libraries")
    
    println("\nTraditional (requires Jackson setup):")
    println("// ObjectMapper configuration")
    println("// Manual error handling")
    println("// Runtime type errors possible")
  }
  
  def example3_TypeSafety(): Unit = {
    println("\n3. TYPE SAFETY")
    println("-" * 80)
    
    println("\nSmithy4s HTTP Services:")
    println("""
      |// Service definition with HTTP bindings
      |@http(method: "POST", uri: "/{index}/_search")
      |operation Search {
      |    input: SearchInput
      |    output: SearchResponse
      |}
      |
      |structure SearchInput {
      |    @httpLabel index: String
      |    @httpQuery("size") size: Integer
      |    @httpPayload body: Document
      |}
      |
      |// Generated service method:
      |def search(
      |  index: String,           // Path parameter
      |  body: Document,          // Request body
      |  size: Option[Int] = None // Query parameter
      |): F[SearchResponse]
      |
      |✓ Compile-time validation of HTTP bindings
      |✓ Type-safe path/query parameters
      |✓ Automatic client generation
    """.stripMargin)
    
    println("\nTraditional:")
    println("""
      |// Manual handler construction
      |val endpoint = s"/${index}/_search"
      |val params = Map("size" -> size.toString)
      |
      |// No compile-time validation
      |// Manual URL/parameter building
      |// Error-prone string concatenation
    """.stripMargin)
  }
  
  def example4_Documentation(): Unit = {
    println("\n4. DOCUMENTATION & TOOLING")
    println("-" * 80)
    
    println("\nSmithy4s:")
    println("✓ Smithy specs serve as machine-readable API documentation")
    println("✓ Can generate OpenAPI/Swagger specs")
    println("✓ Schemas available at runtime for validation")
    println("✓ Cross-language client generation possible")
    println("✓ Protocol-agnostic (can target different protocols)")
    
    println("\nTraditional:")
    println("• Documentation in comments/separate docs")
    println("• Manual OpenAPI generation if needed")
    println("• Scala-specific")
    println("• JSON-specific")
  }
}
