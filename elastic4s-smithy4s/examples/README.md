# Examples: Smithy4s vs Traditional Approach

This directory contains examples comparing the Smithy4s approach with the traditional elastic4s-domain approach.

## Files

### 1. COMPARISON.md (in parent directory)
Comprehensive written comparison covering:
- Approach overview
- Detailed examples for responses, services, and usage
- Benefits summary table
- When to use each approach
- Migration path

### 2. TraditionalExample.scala
Demonstrates the traditional hand-written approach:
- Manual case class definitions
- Jackson annotations
- Manual HTTP handler construction
- Manual JSON serialization

### 3. Smithy4sExample.scala
Demonstrates the Smithy4s approach:
- Auto-generated types from Smithy specs
- HTTP-bound service operations
- Built-in JSON codecs
- Schema validation

### 4. SideBySideComparison.scala
**Runnable example** showing side-by-side comparison:
- Type definitions
- JSON serialization (working code!)
- Type safety comparison
- Documentation & tooling

## Running the Examples

The `SideBySideComparison.scala` example can be run to see actual working code:

```bash
cd /home/runner/work/elastic4s/elastic4s
sbt "smithy4s/runMain examples.SideBySideComparison"
```

Or run the Smithy4sExample:

```bash
sbt "smithy4s/runMain examples.Smithy4sExample"
```

## Quick Comparison

| Aspect | Traditional | Smithy4s |
|--------|------------|----------|
| **Definition** | Hand-written Scala | Smithy IDL → Generated Scala |
| **JSON** | Jackson (manual) | Built-in (auto) |
| **HTTP** | Manual handlers | `@http` traits → Generated |
| **Type Safety** | Data layer only | Data + HTTP layer |
| **Maintenance** | Manual updates | Update Smithy specs |
| **Dependencies** | Jackson | smithy4s-core, smithy4s-json |
| **Learning Curve** | Lower | Higher (learn Smithy) |
| **Cross-language** | No | Yes (via Smithy) |

## Key Takeaways

**Traditional Approach (elastic4s-domain):**
- ✓ Familiar Scala patterns
- ✓ Fine-grained control
- ✓ Lower learning curve
- ✗ Manual maintenance
- ✗ No schema validation
- ✗ Scattered HTTP logic

**Smithy4s Approach (elastic4s-smithy4s):**
- ✓ Automatic code generation
- ✓ Type-safe HTTP bindings
- ✓ Schema validation
- ✓ Protocol-agnostic
- ✓ Cross-language support
- ✗ Higher learning curve
- ✗ Less flexibility

## Example Output

When you run `SideBySideComparison`, you'll see:

```
================================================================================
SIDE-BY-SIDE COMPARISON: Traditional vs Smithy4s
================================================================================

1. TYPE DEFINITIONS
--------------------------------------------------------------------------------

Traditional (elastic4s-domain):
// Hand-written Scala case class with Jackson annotations
case class UpdateResponse(...)

Smithy4s (elastic4s-smithy4s):
// Smithy IDL specification
structure UpdateResponse {...}
// Auto-generates: Scala case class, Schema, JSON codecs

2. JSON SERIALIZATION
--------------------------------------------------------------------------------

Smithy4s (auto-generated JSON codec):
JSON: {"_index":"products","_id":"123","result":"updated","_version":5,...}
Decoded: UpdateResponse(products,123,updated,Some(5),...)
✓ No Jackson configuration needed
✓ Type-safe serialization
✓ Schema validation

...
```

## See Also

- [../COMPARISON.md](../COMPARISON.md) - Detailed written comparison
- [../README.md](../README.md) - Module overview
- [../HANDLERS.md](../HANDLERS.md) - Handler-to-Smithy mapping
