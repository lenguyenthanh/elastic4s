package com.sksamuel.elastic4s.smithy

import com.sksamuel.elastic4s.smithy.common._
import com.sksamuel.elastic4s.smithy.get._
import com.sksamuel.elastic4s.smithy.count._
import com.sksamuel.elastic4s.smithy.delete._
import com.sksamuel.elastic4s.smithy.index._
import org.scalatest.funsuite.AnyFunSuite
import org.scalatest.matchers.should.Matchers
import smithy4s.Document

class Smithy4sBasicTest extends AnyFunSuite with Matchers {

  test("HealthStatus enum values") {
    HealthStatus.values should contain allOf (
      HealthStatus.GREEN,
      HealthStatus.YELLOW,
      HealthStatus.RED
    )
    
    HealthStatus.GREEN.value shouldBe "green"
    HealthStatus.YELLOW.value shouldBe "yellow"
    HealthStatus.RED.value shouldBe "red"
  }

  test("RefreshPolicy enum values") {
    RefreshPolicy.values should contain allOf (
      RefreshPolicy.NONE,
      RefreshPolicy.IMMEDIATE,
      RefreshPolicy.WAIT_FOR
    )
    
    RefreshPolicy.NONE.value shouldBe "none"
    RefreshPolicy.IMMEDIATE.value shouldBe "immediate"
    RefreshPolicy.WAIT_FOR.value shouldBe "wait_for"
  }

  test("VersionType enum values") {
    VersionType.values should contain allOf (
      VersionType.INTERNAL,
      VersionType.EXTERNAL,
      VersionType.EXTERNAL_GTE,
      VersionType.FORCE
    )
  }

  test("GetRequest creation") {
    val request = GetRequest(
      index = "test-index",
      id = "doc123",
      routing = Some("route1"),
      refresh = Some(true)
    )
    
    request.index shouldBe "test-index"
    request.id shouldBe "doc123"
    request.routing shouldBe Some("route1")
    request.refresh shouldBe Some(true)
  }

  test("GetResponse creation") {
    val response = GetResponse(
      id = "doc123",
      index = "test-index",
      found = true,
      _type = Some("_doc"),
      version = Some(1L),
      seqNo = Some(0L),
      primaryTerm = Some(1L)
    )
    
    response.id shouldBe "doc123"
    response.index shouldBe "test-index"
    response.found shouldBe true
    response.version shouldBe Some(1L)
  }

  test("CountRequest creation") {
    val request = CountRequest(
      indexes = List("index1", "index2"),
      query = None,
      minScore = Some(1.5)
    )
    
    request.indexes shouldBe List("index1", "index2")
    request.minScore shouldBe Some(1.5)
  }

  test("CountResponse creation") {
    val response = CountResponse(count = 42L)
    response.count shouldBe 42L
  }

  test("DeleteByIdRequest creation") {
    val request = DeleteByIdRequest(
      index = "test-index",
      id = "doc123",
      routing = Some("route1"),
      version = Some(2L),
      versionType = Some(VersionType.EXTERNAL)
    )
    
    request.index shouldBe "test-index"
    request.id shouldBe "doc123"
    request.routing shouldBe Some("route1")
    request.version shouldBe Some(2L)
    request.versionType shouldBe Some(VersionType.EXTERNAL)
  }

  test("IndexRequest creation") {
    val request = IndexRequest(
      index = "test-index",
      source = Document.obj(),
      id = Some("doc123"),
      refreshPolicy = Some(RefreshPolicy.IMMEDIATE)
    )
    
    request.index shouldBe "test-index"
    request.id shouldBe Some("doc123")
    request.refreshPolicy shouldBe Some(RefreshPolicy.IMMEDIATE)
  }

  test("DocumentRef creation") {
    val docRef = DocumentRef(
      index = "test-index",
      id = "doc123",
      routing = Some("route1")
    )
    
    docRef.index shouldBe "test-index"
    docRef.id shouldBe "doc123"
    docRef.routing shouldBe Some("route1")
  }

  test("FetchSourceContext creation") {
    val context = FetchSourceContext(
      fetchSource = true,
      includes = Some(List("field1", "field2")),
      excludes = Some(List("field3"))
    )
    
    context.fetchSource shouldBe true
    context.includes shouldBe Some(List("field1", "field2"))
    context.excludes shouldBe Some(List("field3"))
  }

  test("Shards creation") {
    val shards = Shards(
      total = Some(5),
      successful = Some(5),
      skipped = Some(0),
      failed = Some(0)
    )
    
    shards.total shouldBe Some(5)
    shards.successful shouldBe Some(5)
    shards.failed shouldBe Some(0)
  }
}
