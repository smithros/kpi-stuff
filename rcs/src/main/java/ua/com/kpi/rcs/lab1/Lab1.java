package ua.com.kpi.rcs.lab1;

import java.util.ArrayList;
import java.util.Collections;
import java.util.InputMismatchException;
import java.util.List;
import java.util.Scanner;
import java.util.stream.Collectors;

public class Lab1 {
    public static final int SUM_COUNT = 100;
    public static final int PARTS = 10;
    public static final String T1 =
        "\nЗначення статистичної щільності розподілу ймовірності відмови:";
    public static final String T2 =
        "\nЙмовірності безвідмовної роботи пристрою на час правої границі інтервалу:";

    public static void main(String[] args) {
        final List<Integer> nums = List.of(
            204, 195, 85, 1220, 359, 729, 91, 293, 184,
            62, 264, 187, 340, 60, 717, 1072, 142, 11,
            253, 975, 347, 113, 472, 146, 129, 600,
            2644, 4, 64, 922, 620, 74, 171, 310, 61, 103,
            210, 4, 602, 52, 39, 8, 385, 38, 284, 271,
            156, 23, 1589, 1062, 6, 439, 681, 94, 636,
            814, 212, 6, 104, 102, 653, 141, 108, 378,
            32, 197, 132, 603, 326, 1139, 5, 374, 1020,
            28, 307, 801, 356, 258, 352, 811, 1020, 154,
            23, 293, 148, 269, 168, 634, 131, 123, 183,
            126, 269, 787, 440, 174, 440, 1109, 852, 127
        );
        double y = 0;
        int time = 0;
        int time2 = 0;
        String choice;
        List<Integer> nums2 = new ArrayList<>(100);
        try {
            final Scanner scanner = new Scanner(System.in);
            System.out.println("γ-відсотковий наробіток на відмову Tγ при γ = (Приклад: 0,9)");
            y = scanner.nextDouble(); // 0,9
            System.out.println("Ймовірність безвідмовної роботи на час: ");
            time = scanner.nextInt();
            System.out.println("Інтенсивність відмов на час: ");
            time2 = scanner.nextInt();
            System.out.println("Вводити вибірку вручну?(y/n)");
            choice = scanner.next();
            if (choice.contains("y")) {
                System.out.println("Вхідна вибірка наробітків до відмови (у годинах): ");
                while (scanner.hasNext()) {
                    nums2.add(scanner.nextInt());
                }
            } else {
                nums2 = nums;
            }
        } catch (InputMismatchException cause) {
            System.out.println("Неправильні вхідні данні");
            System.exit(0);
        }
        System.out.println("Список значень:\n" + nums2);
        System.out.println("Середнє значення: " + getAverage(nums));
        final double maxDiv10 = calcAvgDivBy10(nums);
        System.out.println("Tср = " + maxDiv10);
        List<Integer> sorted = nums.stream().sorted().collect(Collectors.toList());

        final List<List<Integer>> intervals = getIntervalsNums(sorted, maxDiv10);
        final List<List<Double>> intervalsBorders = getIntervalsBorders(maxDiv10);
        final List<Double> fs = getFs(maxDiv10, intervals);
        final List<Double> ps = getPs(maxDiv10, fs);

        printIntervals(intervalsBorders);
        printPsFs(fs, Lab1.T1, "f");
        printPsFs(ps, Lab1.T2, "P");

        List<Double> qs = calcQ(y, ps, intervalsBorders);
        double d01 = (qs.get(3) - y) / (qs.get(3) - qs.get(2));
        System.out.println("d = " + d01);
        double t2 = qs.get(0) + maxDiv10 * d01;
        System.out.println("T = " + t2);

        int index = getIndex(intervalsBorders, time);
        double p1 = calcP(maxDiv10, intervalsBorders, fs, time, index);
        System.out.println("Ймовірність безвідмовної роботи на час " + time + " годин = " + p1);

        int index2 = getIndex(intervalsBorders, time2);
        double p2 = calcP(maxDiv10, intervalsBorders, fs, time2, index2);
        double l = fs.get(index2) / p2;
        System.out.println("Інтенсивність відмов на час " + time2 + " годин = " + l);
    }

    private static List<Double> calcQ(double prop, final List<Double> ps, List<List<Double>> intervalsBorders) {
        for (int i = 0; i < ps.size(); i++) {
            if (prop > ps.get(i)) {
                if (i == 0) {
                    return List.of(intervalsBorders.get(0).get(0), intervalsBorders.get(0).get(1), ps.get(i), 1.0);
                } else {
                    return List.of(intervalsBorders.get(i).get(0), intervalsBorders.get(i).get(1), ps.get(i), ps.get(i - 1));
                }
            }
        }
        return Collections.emptyList();
    }

    private static void printIntervals(final List<List<Double>> intervalsBorders) {
        System.out.println("Границі інтервалів:");
        intervalsBorders.forEach((val) -> System.out.println(
            intervalsBorders.indexOf(val) + 1 + "й інтервал від "
                + val.get(0) + " до " + val.get(1)
        ));
    }

    private static void printPsFs(final List<Double> ps, final String value, final String pf) {
        System.out.println(value);
        for (int i = 0; i < ps.size(); i++) {
            System.out.println("для " + (i + 1) + "-го інтервалу " + pf + " = " + ps.get(i));
        }
    }

    private static double getAverage(final List<Integer> nums) {
        return nums.stream()
            .mapToInt(num -> num)
            .average()
            .orElse(0);
    }

    private static double calcAvgDivBy10(final List<Integer> nums) {
        return nums.stream()
            .mapToInt(num -> num).max().stream().mapToDouble(mx -> (double) mx / 10)
            .findFirst()
            .orElse(0);
    }

    private static double calcP(final double maxDiv10,
                                final List<List<Double>> intervalsBorders,
                                final List<Double> fs,
                                final int time,
                                final int range
    ) {
        double qt = 0;
        for (int i = 0; i < range; i++) {
            qt += fs.get(i) * maxDiv10;
        }
        qt += fs.get(range) * (time - intervalsBorders.get(range).get(0));
        return 1 - qt;
    }

    private static List<Double> getFs(final double diff, final List<List<Integer>> intervals) {
        return intervals.stream()
            .map(interval -> interval.size() / (Lab1.SUM_COUNT * diff))
            .collect(Collectors.toList());
    }

    private static List<Double> getPs(final double diff, final List<Double> fs) {
        List<Double> res = new ArrayList<>();
        double pi = 0;
        for (final Double f : fs) {
            pi += f * diff;
            res.add(1 - pi);
        }
        return res;
    }

    private static List<List<Integer>> getIntervalsNums(final List<Integer> sorted, final double diff) {
        final List<List<Integer>> intervals = new ArrayList<>();
        for (int i = 0; i < Lab1.PARTS; i++) {
            List<Integer> tmp = new ArrayList<>();
            for (Integer integer : sorted) {
                if (integer >= i * diff && integer <= (i + 1) * diff) {
                    tmp.add(integer);
                }
            }
            intervals.add(tmp);
        }
        return intervals;
    }

    private static List<List<Double>> getIntervalsBorders(final double div) {
        final List<List<Double>> intervals = new ArrayList<>();
        for (int i = 0; i < Lab1.PARTS; i++) {
            intervals.add(List.of(i * div, (i + 1) * div));
        }
        return intervals;
    }

    private static int getIndex(final List<List<Double>> borders, final int time) {
        int res = 0;
        for (final List<Double> border : borders) {
            if (time >= border.get(0) && time <= border.get(1)) {
                res = borders.indexOf(border);
            }
        }
        return res;
    }
}
