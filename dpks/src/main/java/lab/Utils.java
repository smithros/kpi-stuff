package lab;

public class Utils {

    public static double[][] floydWarshall(int[][] matrix) {
        double[][] paths = new double[matrix.length][matrix.length];
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix.length; j++) {
                paths[i][j] = matrix[i][j];
            }
        }
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix.length; j++) {
                if (paths[i][j] == 0) {
                    paths[i][j] = 10000;
                }
                if (i == j) {
                    paths[i][j] = 0;
                }
            }
        }
        for (int k = 0; k < matrix.length; k++) {
            for (int i = 0; i < matrix.length; i++) {
                for (int j = 0; j < matrix.length; j++) {
                    paths[i][j] = Math.min(paths[i][j], paths[i][k] + paths[k][j]);
                }
            }
        }
        return paths;
    }

    public static int power(int[][] matrix) {
        int S = 0;
        for (final int[] ints : matrix) {
            int r = 0;
            for (int j = 0; j < matrix.length; j++) {
                r += ints[j];
            }
            if (r > S) {
                S = r;
            }
        }
        return S;
    }

    public static double diameter(double[][] matrix) {
        double D = matrix[0][1];
        for (final double[] doubles : matrix) {
            for (int j = 0; j < matrix.length; j++) {
                D = Math.max(D, doubles[j]);
            }
        }
        return D;
    }

    public static double averageDiameter(double[][] matrix, int N) {
        double ds = 0;
        for (final double[] doubles : matrix) {
            for (int j = 0; j < matrix.length; j++) {
                ds += doubles[j];
            }
        }
        return ds / (N * (N - 1));
    }

    public static void getResult(double[][] matrix) {
        System.out.printf("%10s%10s%10s%10s%10s%10s%10s%n", "Cluster#", "Proc#", "S", "D", "Ds", "T", "C");
        for (final double[] doubles : matrix) {
            for (int j = 0; j < matrix[0].length; j++) {
                System.out.printf("%10.3f", doubles[j]);
            }
            System.out.println();
        }
    }
}
