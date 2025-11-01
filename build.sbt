import Dependencies._

// Required due to dependency conflict in SBT
// See https://github.com/sbt/sbt/issues/6997
ThisBuild / libraryDependencySchemes ++= Seq(
  "org.scala-lang.modules" %% "scala-xml" % VersionScheme.Always
)

def isGithubActions = sys.env.getOrElse("CI", "false") == "true"

// set by github actions when executing a release build
def releaseVersion: String = sys.env.getOrElse("RELEASE_VERSION", "")
def isRelease              = releaseVersion != ""

// set by github actions and used as the snapshot build number
def githubRunNumber = sys.env.getOrElse("GITHUB_RUN_NUMBER", "local")

val scala2Versions   = Seq("2.13.17")
val scalaAllVersions = scala2Versions :+ "3.3.7"

lazy val commonScalaVersionSettings = Seq(
  scalaVersion       := "2.13.17",
  crossScalaVersions := Nil
)

lazy val warnUnusedImport = Seq(
  scalacOptions += "-Ywarn-unused:imports",
  Compile / console / scalacOptions ~= {
    _.filterNot(Set("-Ywarn-unused-import", "-Ywarn-unused:imports"))
  },
  Test / console / scalacOptions := (Compile / console / scalacOptions).value
)

lazy val commonSettings = Seq(
  organization                  := "nl.gn0s1s",
  resolvers += Resolver.mavenLocal,
  Test / parallelExecution      := false,
  Compile / doc / scalacOptions := (Compile / doc / scalacOptions).value.filter(_ != "-Xfatal-warnings"),
  scalacOptions ++= Seq("-release:17", "-unchecked", "-deprecation", "-encoding", "utf8")
)

lazy val publishSettings = Seq(
  Test / publishArtifact := false
)

lazy val commonJvmSettings = Seq(
  Test / testOptions += {
    val flag = if (isGithubActions) "-oCI" else "-oDF"
    Tests.Argument(TestFrameworks.ScalaTest, flag)
  },
  Test / fork        := true,
  Test / javaOptions := Seq("-Xmx3G"),
  javaOptions ++= Seq("-Xms512M", "-Xmx2048M")
)

lazy val pomSettings = Seq(
  startYear  := Some(2013),
  homepage   := Some(url("https://github.com/philippus/elastic4s")),
  licenses += License.Apache2,
  developers := List(
    Developer(
      id = "Philippus",
      name = "Philippus Baalman",
      email = "",
      url = url("https://github.com/philippus")
    ),
    Developer(
      id = "sksamuel",
      name = "Samuel",
      email = "",
      url = url("https://github.com/sksamuel")
    )
  )
)

lazy val noPublishSettings = Seq(
  publish         := {},
  publishLocal    := {},
  publishArtifact := false
)

lazy val allSettings = commonScalaVersionSettings ++
  commonJvmSettings ++
  commonSettings ++
  commonDeps ++
  pomSettings ++
  warnUnusedImport ++
  publishSettings

lazy val scala2Settings = allSettings :+ (crossScalaVersions := scala2Versions)
lazy val scala3Settings = allSettings :+ (crossScalaVersions := scalaAllVersions)

lazy val root                                  = Project("elastic4s", file("."))
  .settings(name := "elastic4s")
  .settings(allSettings)
  .settings(
    noPublishSettings
  )
  .aggregate(
    smithy4s
  )

lazy val domain = (project in file("elastic4s-domain"))
  .settings(name := "elastic4s-domain")
  .dependsOn(json_builder)
  .settings(scala3Settings)
  .settings(libraryDependencies ++= fasterXmlJacksonScala)

lazy val smithy4s = (project in file("elastic4s-smithy4s"))
  .settings(name := "elastic4s-smithy4s")
  .settings(scala3Settings)
  .enablePlugins(Smithy4sCodegenPlugin)
  .settings(
    libraryDependencies ++= Seq(
      "com.disneystreaming.smithy4s" %% "smithy4s-core" % "0.18.28",
      "com.disneystreaming.smithy4s" %% "smithy4s-json" % "0.18.28"
    )
  )

lazy val json_builder = (project in file("elastic4s-json-builder"))
  .settings(name := "elastic4s-json-builder")
  .settings(scala3Settings)
  .settings(libraryDependencies ++= fasterXmlJacksonScala)

lazy val core = (project in file("elastic4s-core"))
  .settings(name := "elastic4s-core")
  .dependsOn(domain, handlers, json_builder)
  .settings(scala3Settings)
  .settings(
    libraryDependencies += cats,
    libraryDependencies ++= fasterXmlJacksonScala
  )

lazy val handlers = (project in file("elastic4s-handlers"))
  .settings(name := "elastic4s-handlers")
  .dependsOn(domain, json_builder)
  .settings(scala3Settings)
  .settings(libraryDependencies ++= fasterXmlJacksonScala)
