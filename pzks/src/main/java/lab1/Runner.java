package lab1;

public class Runner {
    public static void main(String[] args) {
        final Analyzer analyzer = new Analyzer();
        analyzer.analyze(".8ui+(-9..55)*(b7)");
        analyzer.analyze("(-bd7)*(-3.89)/(z8)");
        analyzer.analyze("-bn3+(-7.11)(ix3)");
        analyzer.analyze("(+R0)+((-3.11)*(y&7)3");
        analyzer.analyze("6*hj+(--5.71)*(b/2\\7)");
    }
}