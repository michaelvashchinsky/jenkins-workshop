 lazy val root = (project in file(".")).
  settings(
    inThisBuild(List(
      organization := "com.example",
      scalaVersion := "2.13.3"
    )),
    name := "scala-CubeCalculator"
  )

libraryDependencies += "org.scalatest" %% "scalatest" % "3.1.0" % Test

testOptions in Test += Tests.Argument("-o", "-u", "target/junit")  // Use JUnitXmlReporter
