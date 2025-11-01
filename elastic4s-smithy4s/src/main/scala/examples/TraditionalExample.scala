package examples

/**
 * Example showing traditional elastic4s-domain approach
 * 
 * This demonstrates how you would typically use elastic4s with
 * hand-written domain models and handlers.
 */
object TraditionalExample {
  
  // Example 1: Using domain case classes (hand-written)
  def createUpdateRequest(): Unit = {
    // In traditional approach, you write case classes like this:
    // 
    // case class UpdateResponse(
    //   @JsonProperty("_index") index: String,
    //   @JsonProperty("_id") id: String,
    //   @JsonProperty("_version") version: Long,
    //   result: String,
    //   @JsonProperty("_shards") shards: Shards
    // )
    
    println("Traditional approach uses hand-written case classes with Jackson annotations")
    println("Pros: Fine-grained control, familiar Scala patterns")
    println("Cons: Manual maintenance, no schema validation, Jackson dependency")
  }
  
  // Example 2: Building search requests manually
  def buildSearchRequest(): Unit = {
    // Traditional approach requires manual construction:
    //
    // val request = SearchRequest(
    //   indexes = Seq("myindex"),
    //   query = Some(matchQuery("title", "elasticsearch")),
    //   size = Some(10)
    // )
    //
    // val handler = SearchHandler()
    // val httpEntity = handler(request) // Manual HTTP entity creation
    
    println("\nTraditional approach requires manual HTTP handler invocation")
    println("Pros: Flexible, easy to customize")
    println("Cons: No compile-time validation of HTTP layer, scattered logic")
  }
  
  // Example 3: JSON serialization
  def serializeToJson(): Unit = {
    // Uses Jackson ObjectMapper:
    //
    // val mapper = new ObjectMapper()
    // val json = mapper.writeValueAsString(response)
    
    println("\nTraditional approach uses Jackson for JSON")
    println("Pros: Mature library, widely used")
    println("Cons: Runtime errors, extra dependency, manual configuration")
  }
}
