package lab;

public class Lab3 {
    public static void main(String[] args) {
        int[][] cluster = {
                {0, 0, 1, 1, 0, 0, 0, 0},
                {0, 0, 0, 1, 1, 0, 0, 0},
                {1, 0, 0, 0, 1, 0, 0, 0},
                {1, 1, 0, 0, 0, 1, 1, 0},
                {0, 1, 1, 0, 0, 0, 1, 1},
                {0, 0, 0, 1, 0, 0, 0, 1},
                {0, 0, 0, 1, 1, 0, 0, 0},
                {0, 0, 0, 0, 1, 1, 0, 0},
        };
        int n = cluster.length;
        int steps = 4;
        double[][] result = new double[steps][7];
        for (int step = 1; step <= steps; step++) {
            int numClusters = (int) Math.pow(step, 2);
            int N = n * numClusters;
            int[][] system = new int[N][N];
            for (int k = 0; k < numClusters; k++) {
                for (int i = 0; i < n; i++) {
                    System.arraycopy(cluster[i], 0, system[i + k * n], k * n, n);
                }
            }
            if (step > 1) {
                for (int k = 0; k < step; k++) {
                    for (int i = 0; i < step - 1; i++) {
                        system[n * step * k + n * i + 5][n * step * k + n * (i + 1)] = 1; // 5-8
                        system[n * step * k + n * i + 6][n * step * k + n * (i + 1) + 1] = 1; // 6-9

                        system[n * step * i + n * k + 2][n * step * (i + 1) + n * k] = 1; // 2-16
                        system[n * step * i + n * k + 7][n * step * (i + 1) + n * k + 5] = 1; // 7-21

                        system[n * step * k + 1][n * step * (k + 1) - 2] = 1; // 1-14
                        system[n * step * k][n * step * (k + 1) - 3] = 1; // 0-13

                        system[n * k + 1][n * step * (step - 1) + n * k + 1] = 1; // 1-17
                        system[n * k + 6][n * step * (step - 1) + n * k + 6] = 1; // 6-22

                        system[n * k][n * step * (step - 1) + n * k + 2] = 1; // 0-18
                        system[n * k + 5][n * step * (step - 1) + n * k + 7] = 1; // 5-23

                    }
                }
            }
            for (int i = 0; i < N; i++) {
                for (int j = 0; j < N; j++) {
                    if (system[i][j] == 1) {
                        system[j][i] = 1;
                    }
                }
            }
            result[step - 1][0] = numClusters;
            result[step - 1][1] = N;
            int S = Utils.power(system);
            result[step - 1][2] = S;
            double[][] paths = Utils.floydWarshall(system);
            double D = Utils.diameter(paths);
            result[step - 1][3] = D;
            double Ds = Utils.averageDiameter(paths, N);
            result[step - 1][4] = Ds;
            double T = 2 * Ds / S;
            result[step - 1][5] = T;
            double C = D * N * S;
            result[step - 1][6] = C;
        }
        Utils.getResult(result);
    }
}
