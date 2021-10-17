package lab;

public class Lab2 {

    public static void main(String[] args) {
        int[][] cluster = {
                {0, 1, 0, 0, 0, 0, 0, 1},
                {1, 0, 1, 1, 0, 1, 0, 1},
                {0, 1, 0, 1, 0, 0, 0, 0},
                {0, 1, 1, 0, 1, 1, 0, 0},
                {0, 0, 0, 1, 0, 1, 0, 0},
                {0, 1, 0, 1, 1, 0, 1, 1},
                {0, 0, 0, 0, 0, 1, 0, 1},
                {1, 1, 0, 0, 0, 1, 1, 0}
        };
        int n = cluster.length;
        int steps = 6;
        double[][] result = new double[steps][7];
        int numClusters = 0;
        for (int step = 1; step <= steps; step++) {
            numClusters += Math.pow(2, step - 1);
            int N = n * numClusters;
            int[][] system = new int[N][N];
            for (int k = 0; k < numClusters; k++) {
                for (int i = 0; i < n; i++) {
                    System.arraycopy(cluster[i], 0, system[i + k * n], k * n, n);
                }
            }
            if (step > 1) {
                int i = 0;
                int j = 8;
                while (i < system.length && j < system.length) {
                    system[i][j + 4] = 1;
                    system[i + 1][j + 1] = 1;
                    system[i + 5][j + 13] = 1;
                    system[i + 6][j + 10] = 1;
                    system[i + 7][j + 11] = 1;
                    system[i + 7][j + 3] = 1;
                    i += 8;
                    j += 16;
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

