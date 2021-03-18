package ua.com.kpi.rcs.lab23;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Scanner;
import java.util.stream.Collectors;
import java.util.stream.IntStream;
import com.google.common.collect.Lists;
import org.paukov.combinatorics3.Generator;

public class Lab23 {

    public static final String PROB = "src/main/java/ua/com/kpi/rcs/lab23/probabilities.txt";
    public static final String MATRIX = "src/main/java/ua/com/kpi/rcs/lab23/matrix.txt";

    public static void main(String[] args) throws IOException {
        final List<List<Integer>> matrix = getMatrixInput();
        final List<Double> probs = getPsInput(matrix);
        final double lab2Res = lab2(matrix, probs);
        calcLab3(lab2Res, matrix, probs, 1, 1, 1000, "all");
        calcLab3(lab2Res, matrix, probs, 1, 1, 1000, "alone");
    }

    private static double lab2(List<List<Integer>> matrix, List<Double> probs) {
        final DfsPathPrinter dfsPathPrinter = new DfsPathPrinter(matrix.size());
        dfsPathPrinter.printResult(matrix);
        final List<List<Integer>> schemas = getPropTable(dfsPathPrinter.getPaths());
        final List<Double> probList = calcProbabilities(schemas, probs);
        System.out.println("Таблиця працездатних станів системи:");
        for (int i = 0; i < schemas.size(); i++) {
            System.out.println(schemas.get(i) + " = " + probList.get(i));
        }
        final double fres = getSum(probList);
        System.out.printf("Ймовірність відмови P = %s\n", fres);
        System.out.printf("Інтенсивність відмов Lambda = %s\n", calcLambda(probList, 10));
        System.out.printf("Ймовірність відмови T = %s\n", 1 / calcLambda(probList, 10));
        return fres;
    }

    private static List<Double> getPsInput(final List<List<Integer>> matrix) throws FileNotFoundException {
        List<String> input = Arrays.asList(
            new Scanner(
                new File(new File(Lab23.PROB).getPath()))
                .useDelimiter("\\Z").next().split("\\r?\\n")
        );
        List<Double> res = new ArrayList<>();
        for (String value : input) {
            res.add(Double.parseDouble(value));
        }
        if (input.size() + 1 != matrix.size()) {
            System.out.println("Невірно введені дані: кількість ймовірностей не підходить під матрицю");
            System.exit(0);
        }
        for (final String s : input) {
            if (Double.parseDouble(s) < 0 || Double.parseDouble(s) > 1) {
                System.out.println("Невірно введені дані: ймовірність не в межах від 0 до 1");
                System.exit(0);
            }
        }
        return res;
    }

    private static List<List<Integer>> getMatrixInput() throws IOException {
        List<List<Integer>> dynamicMatrix = Lists.newArrayList();
        List<String> input = Arrays.asList(
            new Scanner(
                new File(new File(Lab23.MATRIX).getPath()))
                .useDelimiter("\\Z").next().split("\\r?\\n")
        );
        input
            .forEach(line -> dynamicMatrix.add(
                Arrays.stream(line.split(" "))
                    .mapToInt(Integer::parseInt)
                    .boxed()
                    .collect(Collectors.toList())
            ));
        for (final List<Integer> matrix : dynamicMatrix) {
            for (final Integer val : matrix) {
                if (dynamicMatrix.size() != matrix.size()) {
                    System.out.println("Невірно введені дані: не квадратна матриця");
                    System.exit(0);
                }
                if (val != 0 && val != 1) {
                    System.out.println("Невірно введені дані: значення в матриці не рівне 0 або 1");
                    System.exit(0);
                }
            }
        }
        return dynamicMatrix;
    }

    private static List<List<Integer>> getPropTable(final List<List<Integer>> paths) {
        List<List<Integer>> rows = new ArrayList<>();
        int maxNodes = 0;
        List<Integer> allNodes = new ArrayList<>();

        for (final List<Integer> path : new ArrayList<>(paths)) {
            List<Integer> tmp = new ArrayList<>(path);
            tmp.remove(0);
            tmp.remove(tmp.size() - 1);
            rows.add(tmp);
            if (calcMax(tmp) > maxNodes) {
                maxNodes = calcMax(tmp);
            }
        }
        IntStream.range(1, maxNodes + 1).forEach(allNodes::add);
        rows.add(allNodes);
        List<List<Integer>> test = new ArrayList<>(rows);
        for (final List<Integer> path : rows) {
            List<Integer> tmp = new ArrayList<>(allNodes);
            tmp.removeAll(path);
            for (int i = 1; i < tmp.size(); i++) {
                for (final List<Integer> comb : getCombinations(tmp, i)) {
                    List<Integer> newTmp = new ArrayList<>(path);
                    newTmp.addAll(new ArrayList<>(comb));
                    newTmp.sort(Comparator.naturalOrder());
                    if (!rows.contains(newTmp)) {
                        test.add(new ArrayList<>(newTmp));
                    }
                }
            }
        }
        test.sort(Comparator.comparingInt(List::size));
        Collections.reverse(test);
        return test.stream().distinct().collect(Collectors.toList());
    }

    private static List<Double> calcProbabilities(final List<List<Integer>> schemas,
                                                  final List<Double> inputPs
    ) {
        List<Integer> allNodes = new ArrayList<>(schemas.get(0));
        List<Double> res = new ArrayList<>();
        for (final List<Integer> schema : schemas) {
            double pVal = 1;
            List<Integer> tmp = new ArrayList<>(allNodes);
            for (final Integer node : schema) {
                pVal *= inputPs.get(node);
                tmp.remove(node);
            }
            for (final Integer integer : tmp) {
                pVal *= 1 - inputPs.get(integer);
            }
            res.add(pVal);
        }
        return res;
    }

    private static List<List<Integer>> getCombinations(final List<Integer> tmp, final int times) {
        return Generator.combination(new HashSet<>(tmp))
            .simple(times)
            .stream()
            .collect(Collectors.toList());
    }

    private static Double calcLambda(final List<Double> probs, final int time) {
        return (-Math.log(getSum(probs)) / time);
    }

    private static double getSum(final List<Double> probs) {
        return probs.stream().mapToDouble(val -> val).sum();
    }

    private static Integer calcMax(final List<? extends Number> numbers) {
        return numbers.stream().mapToInt(Number::intValue).max().orElse(0);
    }

    // Lab3 part starts here

    private static Double getTSystem(final Double prob, final int time) {
        return (-time / Math.log(prob));
    }

    private static double getQReserved(final int k, final double q) {
        return Math.pow(q, k) / factorial(k + 1);
    }

    private static int factorial(final int n) {
        if (n == 0) {
            return 1;
        } else {
            return (n * factorial(n - 1));
        }
    }

    private static void calcLab3(final double p,
                                 final List<List<Integer>> matrix,
                                 final List<Double> probsFile,
                                 final int k1,
                                 final int k2,
                                 final int time,
                                 final String choice
    ) {
        final double q = 1 - p;
        final double t = getTSystem(p, time);
        double qRes;
        double pRes;
        double tRes;
        if ("all".equals(choice)) {
            qRes = getQReserved(k1, q);
            pRes = 1 - qRes;
        } else {
            List<Double> p2List = calcNewProbs(probsFile, k2);
            pRes = lab2(matrix, p2List);
            qRes = 1 - pRes;
        }
        tRes = getTSystem(pRes, time);
        double g1_q = qRes / q;
        double g1_p = pRes / p;
        double g1_t = tRes / t;

        System.out.println("\nРезультати 3 ЛР:");
        System.out.printf("\nP = %f", p);
        System.out.printf("\nQ = %f", q);
        System.out.printf("\nT = %f", t);
        System.out.printf("\nP reserved system = %f", pRes);
        System.out.printf("\nQ reserved system = %f", qRes);
        System.out.printf("\nT reserved system = %f", tRes);
        System.out.printf("\nG_q = %f", g1_q);
        System.out.printf("\nG_p = %f", g1_p);
        System.out.printf("\nG_t = %f", g1_t);
    }

    private static List<Double> calcNewProbs(final List<Double> probs,
                                             final int range
    ) {
        List<Double> res = new ArrayList<>();
        for (final Double prob : probs) {
            double value;
            value = Math.pow(1 - prob, range + 1);
            res.add(1 - value);
        }
        return res;
    }
}
