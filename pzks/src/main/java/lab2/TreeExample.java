package lab2;

import lab1.Analyzer;
import lab1.Parser;

public class TreeExample {
    public static void main(String[] args) {
//        final String expr = "x-y+z*5+v+2*(m-n/4-l)+3+b+c+d";
        final String expr = "a-b-c-d-e-y-u-i";
        new Analyzer().analyze(expr);
        final Parser psr = new Parser();
        psr.parse(expr);
        psr.getErrors(psr.getTokens(), psr.getTypes());
        System.out.printf("Input expression: %s%n", expr);
        if (!psr.hasErrors()) {
            new ParallelTree().constructTree(psr.getTokens(), psr.getTypes());
        } else {
            System.err.println("The expression is incorrect, not able to create tree");
        }
    }
}
