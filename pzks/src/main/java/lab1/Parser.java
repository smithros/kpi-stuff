package lab1;

import java.util.ArrayList;
import java.util.List;

public class Parser {
    private final String[] tokenVars =
            {
                    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p",
                    "q", "r", "s", "t", "u", "w", "v", "x", "y", "z", "A", "B", "C", "D", "E", "F",
                    "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "W",
                    "V", "X", "Y", "Z"
            };
    private final String[] tokenNums = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."};
    private final String[] tokenOperations = {"+", "-", "/", "*", "="};
    private final String[] tokenOpenBrace = {"("};
    private final String[] tokenCloseBrace = {")"};
    private final List<String> tokens;
    private final List<String> types;
    private final List<String> lexicalErrors;
    private final List<String> syntaxErrors;
    private static StringBuilder valToWrite = new StringBuilder();

    public Parser() {
        this.tokens = new ArrayList<>();
        this.types = new ArrayList<>();
        this.lexicalErrors = new ArrayList<>();
        this.syntaxErrors = new ArrayList<>();
    }

    public void parse(String expr) {
        expr = expr.replace(" ", "");
        int charIndex = 0;
        int openBracesCnt = 0;
        int closeBracesCnt = 0;
        int equalitySignsCnt = 0;
        while (charIndex < expr.length()) {
            if (this.has(tokenVars, expr.charAt(charIndex))) {
                while (charIndex < expr.length()
                        && (
                        this.has(tokenVars, expr.charAt(charIndex))
                                || this.has(tokenNums, expr.charAt(charIndex))
                                && expr.charAt(charIndex) != '.'
                        )
                ) {
                    valToWrite.append(expr.charAt(charIndex));
                    charIndex++;
                }
                tokens.add(String.valueOf(valToWrite));
                types.add("Var");
                valToWrite = new StringBuilder();
            } else if (this.has(tokenNums, expr.charAt(charIndex))) {
                while (
                        charIndex < expr.length()
                                && this.has(tokenNums, expr.charAt(charIndex))
                ) {
                    valToWrite.append(expr.charAt(charIndex));
                    charIndex++;
                }
                tokens.add(String.valueOf(valToWrite));
                types.add("Num");
                valToWrite = new StringBuilder();
            } else if (this.has(tokenOperations, expr.charAt(charIndex))) {
                valToWrite.append(expr.charAt(charIndex));
                charIndex++;
                if (String.valueOf(valToWrite).equals("=")) {
                    equalitySignsCnt++;
                }
                tokens.add(String.valueOf(valToWrite));
                types.add("Op");
                valToWrite = new StringBuilder();
            } else if (this.has(tokenOpenBrace, expr.charAt(charIndex))) {
                valToWrite.append(expr.charAt(charIndex));
                charIndex++;
                tokens.add(String.valueOf(valToWrite));
                types.add("(");
                openBracesCnt++;
                valToWrite = new StringBuilder();
            } else if (this.has(tokenCloseBrace, expr.charAt(charIndex))) {
                valToWrite.append(expr.charAt(charIndex));
                charIndex++;
                tokens.add(String.valueOf(valToWrite));
                types.add(")");
                closeBracesCnt++;
                valToWrite = new StringBuilder();
                if (closeBracesCnt > openBracesCnt) {
                    syntaxErrors.add("Error at index " + (charIndex - 1) + ": Not equal amount of open (" + openBracesCnt + ") and closed (" + closeBracesCnt + ") braces");
                }
            } else {
                lexicalErrors.add("Error at index " + charIndex + ": Unknown symbol [" + expr.charAt(charIndex) + "]");
                charIndex++;
            }
            if (charIndex == expr.length()) {
                break;
            }
        }
        if (openBracesCnt < closeBracesCnt) {
            syntaxErrors.add("Expression has excessive closing braces");
        }
        if (openBracesCnt > closeBracesCnt) {
            syntaxErrors.add("Expression has excessive opening braces");
        }
        if (equalitySignsCnt > 1) {
            syntaxErrors.add("Expression has 2 or more equality sign");
        }
    }

    public void getErrors(final List<String> tokens, final List<String> types) {
        int tokenTypeIndex = 0;
        int dotCnt = 0;
        String error;
        StringBuilder buf = new StringBuilder();
        //Beginning with (, number, variable or ending with ), number, variable
        if (!types.get(0).equals("Num") && !types.get(0).equals("Var") && !types.get(0).equals("(")) {
            syntaxErrors.add("id0: Expression can not start with symbol [" + tokens.get(0) + "]");
        }
        int size = types.size() - 1;
        if (!types.get(size).equals("Num") && !types.get(size).equals("Var") && !types.get(size).equals(")")) {
            syntaxErrors.add("id" + size + ": Expression can not end with symbol [" + tokens.get(size) + "]");
        }
        while (tokenTypeIndex < size) {
            //No double operators
            if (types.get(tokenTypeIndex).equals("Op")) {
                if (!types.get(tokenTypeIndex + 1).equals("Var") && !types.get(tokenTypeIndex + 1).equals("Num") && !types.get(tokenTypeIndex + 1).equals("(")) {
                    syntaxErrors.add("id" + tokenTypeIndex + ": After operation [" + tokens.get(tokenTypeIndex) + "] should be a variable, " +
                            "constant or brace, not " + fullTypeName(types.get(tokenTypeIndex + 1)) + " [" + tokens.get(tokenTypeIndex + 1) + "]");
                }
            }
            //No empty brackets, no wrong start after (, no absent operators before (
            if (types.get(tokenTypeIndex).equals("(")) {
                //Check for negative numbers or variables
                if (types.get(tokenTypeIndex + 1).equals("Op")) {
                    if (tokens.get(tokenTypeIndex + 1).equals("-")) {
                        if (types.get(tokenTypeIndex + 2).equals("Num") || types.get(tokenTypeIndex + 2).equals("Var")) {
                            tokens.set(tokenTypeIndex + 2, tokens.get(tokenTypeIndex + 1) + tokens.get(tokenTypeIndex + 2));
                            tokens.remove(tokenTypeIndex + 1);
                            types.remove(tokenTypeIndex + 1);
                        }
                    }
                }
                if (!types.get(tokenTypeIndex + 1).equals("Var") && !types.get(tokenTypeIndex + 1).equals("Num") && !types.get(tokenTypeIndex + 1).equals("(")) {
                    syntaxErrors.add("id" + tokenTypeIndex + ": After open brace should be a variable, " +
                            "constant or brace, not " + fullTypeName(types.get(tokenTypeIndex + 1)) + " [" + tokens.get(tokenTypeIndex + 1) + "]");
                }
                if (tokenTypeIndex != 0)
                    if (!types.get(tokenTypeIndex - 1).equals("Op") && !types.get(tokenTypeIndex - 1).equals("(")) {
                        syntaxErrors.add("id" + tokenTypeIndex + ": Before open brace should be an operator " +
                                "or other open brace, not " + fullTypeName(types.get(tokenTypeIndex - 1)) + " [" + tokens.get(tokenTypeIndex - 1) + "]");
                    }
                if (types.get(tokenTypeIndex + 1).equals(")")) {
                    syntaxErrors.add("id" + tokenTypeIndex + ": Empty braces on position " + tokenTypeIndex + "-" + (tokenTypeIndex + 1) + " in token list");
                }
            }
            //No absent operators after )
            if (types.get(tokenTypeIndex).equals(")")) {
                if (!types.get(tokenTypeIndex + 1).equals("Op") && !types.get(tokenTypeIndex + 1).equals(")")) {
                    syntaxErrors.add("id" + tokenTypeIndex + ": After close brace should be an operator or " +
                            "other close brace, not " + fullTypeName(types.get(tokenTypeIndex + 1)) + " [" + tokens.get(tokenTypeIndex + 1) + "]");
                }
            }
            if (types.get(tokenTypeIndex).equals("Num")) {
                if (!types.get(tokenTypeIndex + 1).equals("Op") && !types.get(tokenTypeIndex + 1).equals(")") && !tokens.get(tokenTypeIndex + 1).equals(".")) {
                    if (types.get(tokenTypeIndex + 1).equals("Var")) {
                        lexicalErrors.add("id" + (tokenTypeIndex + 1) + ": Variable [" + tokens.get(tokenTypeIndex + 1) + "] can not start with constant [" + tokens.get(tokenTypeIndex) + "]");
                    } else {
                        syntaxErrors.add("id" + tokenTypeIndex + ": After constant [" + tokens.get(tokenTypeIndex) + "] must be an operator, close brace," +
                                " or sign [.], not " + fullTypeName(types.get(tokenTypeIndex + 1)) + " [" + tokens.get(tokenTypeIndex + 1) + "]");
                    }
                }
            }
            tokenTypeIndex++;
        }
        //Dot in correct place, in correct count
        tokenTypeIndex = 0;
        while (tokenTypeIndex < tokens.size()) {
            if (types.get(tokenTypeIndex).equals("Num") || types.get(tokenTypeIndex).equals("Var")) {
                buf.append(tokens.get(tokenTypeIndex));
                int sbuf = (tokens.get(tokenTypeIndex).length());
                int j;
                for (j = 0; j < (tokens.get(tokenTypeIndex).length()); j++) {
                    if (buf.charAt(j) == '.') {
                        if (j == 0) {
                            if (tokens.get(tokenTypeIndex).length() == 1) {
                                error = "id" + tokenTypeIndex + ": Dot can not be on its own";
                            } else {
                                error = "id" + tokenTypeIndex + ": Dot can not be a start of token [" + tokens.get(tokenTypeIndex) + "]";
                            }
                            lexicalErrors.add(error);
                        } else if (j == sbuf - 1) {
                            lexicalErrors.add("id" + tokenTypeIndex + ": Dot can not be at the end of the token [" + tokens.get(tokenTypeIndex) + "]");
                        }
                        dotCnt++;
                    }
                }
                if (dotCnt > 1) {
                    lexicalErrors.add("id" + tokenTypeIndex + ": Token [" + tokens.get(tokenTypeIndex) + "] can not have more than one dot");
                }
            }
            tokenTypeIndex++;
            dotCnt = 0;
            buf = new StringBuilder();
        }
        if (this.syntaxErrors.size() == 0 && this.lexicalErrors.size() == 0) {
            System.out.println("Expression is correct");
        } else {
            System.out.println("Expression is NOT correct");
        }
    }

    private boolean has(final String[] arr, final char charToFind) {
        for (String element : arr) {
            if (element.equals(String.valueOf(charToFind))) {
                return true;
            }
        }
        return false;
    }

    public String fullTypeName(final String type) {
        return switch (type) {
            case "Var" -> "variable";
            case "Num" -> "constant";
            case "Op" -> "operator";
            case "(" -> "opening brace";
            case ")" -> "closing brace";
            default -> "";
        };
    }

    public List<String> getTokens() {
        return this.tokens;
    }

    public List<String> getTypes() {
        return this.types;
    }

    public List<String> getLexicalErrors() {
        return this.lexicalErrors;
    }

    public List<String> getSyntaxErrors() {
        return this.syntaxErrors;
    }

    public boolean hasErrors() {
        return this.getLexicalErrors().size() != 0 || this.getSyntaxErrors().size() != 0;
    }
}
