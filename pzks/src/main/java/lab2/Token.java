package lab2;

public class Token {
    int index;
    String op;

    public Token(final int index, final String op) {
        this.index = index;
        this.op = op;
    }

    public int getIndex() {
        return index;
    }

    public void setIndex(final int index) {
        this.index = index;
    }

    public String getOp() {
        return op;
    }

    public void setOp(final String op) {
        this.op = op;
    }

    @Override
    public String toString() {
        return "Token{" +
                "index=" + index +
                ", op='" + op + '\'' +
                '}';
    }
}