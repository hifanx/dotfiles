import static java.lang.Math.*;

import java.util.*;

interface ExampleInterface {
    int CONSTANT = 42;

    void doSomething();
}

@interface CustomAnnotation {
    String value();
}

enum Level {
    LOW,
    MEDIUM,
    HIGH;
}

abstract class AbstractBase {
    abstract void perform();

    public void log() {
        System.out.println("I can do stuff in abstract class");
    }
}

final class FinalClass {
    public static final String NAME = "Final";
}

class HighlightTest extends AbstractBase implements ExampleInterface {
    private int number;
    protected String text;
    public static final double PI_VALUE = PI;
    public static final String Test = "Test";

    private boolean enabled = true;
    private long bigNumber = 123_456_789L;

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

    public int mathAndTernary(int a, int b) {
        int sum = a + b;
        int diff = a - b;
        int max = a > b ? a : b;
        return enabled ? max : sum;
    }

    public void controlFlowExamples() {
        for (int i = 0; i < 10; i++) {}

        while (number > 0) {
            number--;
        }
        do {
            number++;
        } while (number < 5);
        if (number == 0) {
        } else if (number < 0) {
        } else {
        }
        switch (number) {
            case 0:
                break;
            default:
                break;
        }
        try {
            int x = 5 / number;
        } catch (ArithmeticException e) {
            e.printStackTrace();
        } finally {
        }
    }

    public synchronized void syncMethod() {}

    public String isString(String s, int i) {
        String local = "plain";
        String path = "/tmp/file.txt";
        String url = "https://example.com";
        return local + s + path + url;
    }

    public boolean isBoolean(String s, int i) {
        String ss = s;
        int ii = i;
        for (int j = ii; j < ss.length(); j++) {
            if (j == 33) return true;
        }

        switch (s) {
            case 'A':
                System.out.println("A");
                break;
            case 'B':
                System.out.println("B");
                break;
            default:
                System.out.println("Default");
        }

        return false;
    }

    public void collectionExamples() {
        List<String> names = new ArrayList<>();
        names.add("Alice");
        names.add("Bob");
        names.add("Carol");

        List<Integer> numbers = Arrays.asList(1, 2, 3, 4);

        Map<String, Integer> scores = new HashMap<>();

        scores.put("Alice", 90);
        scores.put("Bob", 75);
        scores.put("Carol", 82);

        int[] primes = {2, 3, 5, 7};
        String[] words = new String[] {"one", "two", "three"};

        for (String name : names) {
            System.out.println("name: " + name);
        }

        for (int value : primes) {
            System.out.println("prime: " + value);
        }

        System.out.println("names list = " + names);
        System.out.println("numbers list = " + numbers);
        System.out.println("scores map = " + scores);
        System.out.println("primes array = " + Arrays.toString(primes));
        System.out.println("words array = " + Arrays.toString(words));
    }

    public static void main(String[] args) {
        HighlightTest ht = new HighlightTest(1, "hello");
        ht.controlFlowExamples();
        ht.collectionExamples();
        System.out.println("初始图:");
    }
}
