package lab;

public class Lab1 {
    public static void main(String[] args) {
        int[][] cluster = {
                {0, 1, 0, 0, 1, 0, 0, 0, 0},
                {1, 0, 1, 0, 0, 1, 0, 0, 0},
                {0, 1, 0, 0, 0, 0, 0, 0, 0},
                {0, 0, 0, 0, 1, 0, 0, 1, 0},
                {1, 0, 0, 1, 0, 1, 0, 0, 1},
                {0, 1, 0, 0, 1, 0, 0, 0, 0},
                {0, 0, 0, 0, 0, 0, 0, 1, 0},
                {0, 0, 0, 1, 0, 0, 1, 0, 1},
                {0, 0, 0, 0, 1, 0, 0, 1, 0},
        };
        int len = cluster.length;
        int steps = 13;
        // 7 - res table width
        double[][] result = new double[steps][7];
        for (int step = 1; step <= steps; step++) {
            int sLen = len * step;
            int[][] system = new int[sLen][sLen];
            for (int k = 0; k < step; k++) {
                for (int i = 0; i < len; i++) {
                    System.arraycopy(cluster[i], 0, system[i + k * len], k * len, len);
                }
            }
            if (step > 1) {
                int i = 6;
                int j = 9;
                while (i < system.length && j < system.length) {
                    // connection between clusters
                    system[i][j] = 1;
                    system[i+1][j+1] = 1;
                    system[i+2][j+2] = 1;
                    i += 9;
                    j += 9;
                }
                // connection between first and last cluster
                system[0][sLen - 3] = 1;
                system[1][sLen - 2] = 1;
                system[2][sLen - 1] = 1;
            }
            for (int i = 0; i < sLen; i++) {
                for (int j = 0; j < sLen; j++) {
                    if (system[i][j] == 1) {
                        system[j][i] = 1;
                    }
                }
            }
            result[step - 1][0] = (float) sLen / len;
            result[step - 1][1] = sLen;
            int S = Utils.power(system);
            result[step - 1][2] = S;
            double[][] paths = Utils.floydWarshall(system);
            double D = Utils.diameter(paths);
            result[step - 1][3] = D;
            double Ds = Utils.averageDiameter(paths, sLen);
            result[step - 1][4] = Ds;
            double T = 2 * Ds / S;
            result[step - 1][5] = T;
            double C = D * sLen * S;
            result[step - 1][6] = C;
        }
        Utils.getResult(result);
    }
}

