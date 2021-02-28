package ua.com.kpi.rcs.lab2;

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

public class Lab2 {

    public static final String PROB = "src/main/java/ua/com/kpi/rcs/lab2/probabilities.txt";
    public static final String MATRIX = "src/main/java/ua/com/kpi/rcs/lab2/matrix.txt";

    public static void main(String[] args) throws IOException {
        List<List<Integer>> matrix = getMatrixInput();
        List<Double> res = getPsInput(matrix);
        final DfsPathPrinter dfsPathPrinter = new DfsPathPrinter(matrix.size());
        dfsPathPrinter.printResult(matrix);
        final List<List<Integer>> schemas = getSchemas(dfsPathPrinter.getPaths());
        final List<Double> probList = calcProbabilities(schemas, res);
        for (int i = 0; i < schemas.size(); i++) {
            System.out.println(schemas.get(i) + " = " + probList.get(i));
        }
        System.out.printf("Ймовірність відмови P = %s\n", getSum(probList));
        System.out.printf("Інтинсивність відмов Lambda = %s\n", calcLambda(probList, 10));
        System.out.printf("Ймовірність відмови T = %s\n", 1 / calcLambda(probList, 10));
    }

    private static List<Double> getPsInput(final List<List<Integer>> matrix) throws FileNotFoundException {
        List<String> input = Arrays.asList(
            new Scanner(
                new File(new File(Lab2.PROB).getPath()))
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
                new File(new File(Lab2.MATRIX).getPath()))
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

    private static List<List<Integer>> getSchemas(final List<List<Integer>> paths) {
        List<List<Integer>> schemas = new ArrayList<>();
        int maxNodes = 0;
        List<Integer> allNodes = new ArrayList<>();

        for (List<Integer> path : new ArrayList<>(paths)) {
            List<Integer> tmp = new ArrayList<>(path);
            tmp.remove(0);
            tmp.remove(tmp.size() - 1);
            schemas.add(tmp);
            if (calcMax(tmp) > maxNodes) {
                maxNodes = calcMax(tmp);
            }
        }
        IntStream.range(1, maxNodes + 1).forEach(allNodes::add);
        schemas.add(allNodes);
        List<List<Integer>> test = new ArrayList<>(schemas);
        for (final List<Integer> path : schemas) {
            List<Integer> tmp = new ArrayList<>(allNodes);
            tmp.removeAll(path);
            for (int i = 1; i < tmp.size(); i++) {
                for (final List<Integer> comb : getCombinations(tmp, i)) {
                    List<Integer> newTmp = new ArrayList<>(path);
                    newTmp.addAll(new ArrayList<>(comb));
                    newTmp.sort(Comparator.naturalOrder());
                    if (!schemas.contains(newTmp)) {
                        test.add(new ArrayList<>(newTmp));
                    }
                }
            }
        }
        test.sort(Comparator.comparingInt(List::size));
        Collections.reverse(test);
        return test.stream().distinct().collect(Collectors.toList());
    }

    private static List<Double> calcProbabilities(final List<List<Integer>> schemas, List<Double> inputPs) {
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
}
