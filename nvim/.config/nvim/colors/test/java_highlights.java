import java.util.*;
import static java.lang.Math.*;

// Interface example
interface ExampleInterface {
  int CONSTANT = 42;
  void doSomething();
}

// Annotation example
@interface CustomAnnotation {
  String value();
}

// Enum example
enum Level {
  LOW,
  MEDIUM,
  HIGH;
}

// Abstract class
abstract class AbstractBase {
  abstract void perform();
  public void log() {}
}

// Final class
final class FinalClass {
  public static final String NAME = "Final";
}

// Main class covering many Java keywords
class HighlightTest extends AbstractBase implements ExampleInterface {
  private int number;
  protected String text;
  public static final double PI_VALUE = PI;
  public static final String Test = "Test";

  public HighlightTest(int number, String text) {
    this.number = number;
    this.text = text;
  }

  @Override
  public void doSomething() {}

  @Override
  void perform() {}

  @CustomAnnotation(value = "demo")
  public void annotatedMethod() {}

  public void controlFlowExamples() {
    for (int i = 0; i < 10; i++) {}

    while (number > 0) { number--; }
    do { number++; } while (number < 5);
    if (number == 0) {}
    else if (number < 0) {}
    else {}
    switch (number) {
      case 0: break;
      default: break;
    }
    try {
      int x = 5 / number;
    } catch (ArithmeticException e) {
      e.printStackTrace();
    } finally {}
  }

  public synchronized void syncMethod() {}

  public String isString (String s, int i) {
    return "";
  }

  public boolean isBoolean (String s, int i) {
    String ss = s;
    int ii = i;
    for (int j = ii; j < ss.length(); j++) {
      if j = 33 return true
    }
    return false;
  }

  public static void main(String[] args) {
    HighlightTest ht = new HighlightTest(1, "hello");
    ht.controlFlowExamples();
    System.out.println("初始图:");
  }
}
