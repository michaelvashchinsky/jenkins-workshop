import org.scalatest.FlatSpec
import org.scalatest.Tag


object UnitTest extends Tag("UnitTest")
object Slow extends Tag("Slow")

class ExampleSpec extends FlatSpec {

  "The Scala language" must "cube correctly" taggedAs(UnitTest) in {
      assert(CubeCalculator.cube(3) === 27)
    }

  it must "power correctly" taggedAs(UnitTest) in {
      assert(CubeCalculator.power(2) === 4)
  }


  it must "double fast" taggedAs(Slow) in {
      assert(CubeCalculator.double(3) === 6)
  }
}

