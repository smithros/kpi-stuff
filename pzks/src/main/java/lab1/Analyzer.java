package lab1;

public class Analyzer {
    public void analyze(final String expr) {
        System.out.println("Input expression:\t" + expr);
        final Parser prs = new Parser();
        prs.parse(expr);
        prs.getErrors(prs.getTokens(), prs.getTypes());
        if (prs.getLexicalErrors().size() == 0 && prs.getSyntaxErrors().size() == 0) {
            System.out.printf("%-10s%-10s%-10s\n", "uuid", "token", "type");
            for (int id = 0; id < prs.getTokens().size(); id++) {
                System.out.printf("%-10d%-10s%-10s\n", id, prs.getTokens().get(id), prs.fullTypeName(prs.getTypes().get(id)));
            }
        } else {
            for (int i = 0; i < prs.getTokens().size(); i++) {
                if ((i + 1) % 3 != 0) {
                    System.out.printf("uuid%2d:  %-7s\t", i, prs.getTokens().get(i));
                } else {
                    System.out.printf("uuid%2d:  %-7s\n", i, prs.getTokens().get(i));
                }
            }
            if (prs.getSyntaxErrors().size() > 0) {
                System.out.println("\nSyntax analysis errors:");
                prs.getSyntaxErrors().forEach(System.out::println);
            }
            if (prs.getLexicalErrors().size() > 0) {
                System.out.println("\nLexical analysis errors:");
                prs.getLexicalErrors().forEach(System.out::println);
            }
        }
        System.out.printf("%s%n", "*".repeat(90));
    }
}
