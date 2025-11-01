# elastic4s-smithy4s

This module provides an alternative domain model for elastic4s using [Smithy4s](https://disneystreaming.github.io/smithy4s/), a code generator and framework for [Smithy](https://smithy.io/2.0/index.html).

## Overview

The `elastic4s-smithy4s` module is equivalent to the `elastic4s-domain` module but uses Smithy IDL (Interface Definition Language) specifications to define the Elasticsearch domain models. The Scala code is generated from these Smithy specifications at compile time.

## Benefits

- **Protocol-agnostic**: Smithy specifications are language and protocol agnostic
- **Automatic code generation**: Reduces boilerplate and ensures consistency
- **Type safety**: Smithy4s generates type-safe Scala code with proper validation
- **Documentation**: Smithy specifications serve as machine-readable documentation
- **Interoperability**: Smithy models can be used to generate code for other languages

## Structure

The module contains Smithy specifications in `src/main/smithy/` that define:

- **Common types**: Enums and structures used across the API (HealthStatus, RefreshPolicy, etc.)
- **Request/Response models**: Data structures for various Elasticsearch operations
  - Get operations (`get.smithy`)
  - Count operations (`count.smithy`)
  - Delete operations (`delete.smithy`)
  - Index operations (`index.smithy`)
  - Update operations (`update.smithy`)
  - Bulk operations (`bulk.smithy`)
  - Search operations (`search.smithy`)
  - Index management operations (`indices.smithy`)

## Usage

Add the dependency to your `build.sbt`:

```scala
libraryDependencies += "nl.gn0s1s" %% "elastic4s-smithy4s" % elastic4sVersion
```

The generated Scala code will be available in the `com.sksamuel.elastic4s.smithy.*` packages.

Example usage:

```scala
import com.sksamuel.elastic4s.smithy.get.GetRequest
import com.sksamuel.elastic4s.smithy.common.RefreshPolicy

val getRequest = GetRequest(
  index = "myindex",
  id = "doc123",
  refresh = Some(true)
)
```

## Smithy Specifications

Smithy specifications follow the [Smithy IDL syntax](https://smithy.io/2.0/spec/idl.html). Key files:

- `common.smithy` - Common types and enums (HealthStatus, RefreshPolicy, VersionType, DistanceUnit, etc.)
- `get.smithy` - Get and MultiGet operations
- `count.smithy` - Count operations
- `delete.smithy` - Delete and DeleteByQuery operations
- `index.smithy` - Index operations
- `update.smithy` - Update and UpdateByQuery operations
- `bulk.smithy` - Bulk operations
- `search.smithy` - Search operations with full support for queries, aggregations, highlights, etc.
- `indices.smithy` - Index management (create, delete, open, close, stats, etc.)

## Building

The Smithy4s SBT plugin automatically generates Scala code from the Smithy specifications during compilation:

```bash
sbt smithy4s/compile
```

This generates approximately 175 Scala files from the Smithy specifications.

## Comparison with elastic4s-domain

Both modules provide the same functionality but with different approaches:

- **elastic4s-domain**: Hand-written Scala case classes and traits
- **elastic4s-smithy4s**: Generated from Smithy IDL specifications

Choose `elastic4s-smithy4s` if you:
- Want protocol-agnostic specifications
- Need to generate clients in multiple languages
- Prefer IDL-based definitions over hand-written code
- Want automatic validation and serialization
- Need to maintain API contracts in a structured format

Choose `elastic4s-domain` if you:
- Prefer traditional Scala code
- Need full control over implementation details
- Want to avoid build-time code generation

## Generated Code

The Smithy4s plugin generates:
- Case classes for all structures
- Sealed traits for enums and unions
- Type-safe schemas using Smithy4s Schema API
- JSON codecs for serialization/deserialization
- Documentation from Smithy comments
