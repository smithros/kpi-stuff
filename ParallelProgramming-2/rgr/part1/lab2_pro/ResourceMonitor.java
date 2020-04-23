package lab2_pro;

import java.util.ArrayList;
import java.util.List;

public class ResourceMonitor {
    private int N;
    private int q = Integer.MAX_VALUE;
    private int[] R;
    private int[] X;
    private Integer[][] MA;

    public ResourceMonitor(int n) {
        N = n;
        R = new int[N];
        X = new int[N];
        MA = new Integer[N][N];
    }

    synchronized void write_X(int[] vector) {
        System.arraycopy(vector, 0, X, 0, vector.length);
    }

    synchronized int[] copy_X() {
        int[] tmpCopy = new int[N];
        System.arraycopy(X, 0, tmpCopy, 0, X.length);
        return tmpCopy;
    }

    synchronized void write_R(int[] vector) {
        System.arraycopy(vector, 0, R, 0, vector.length);
    }

    synchronized int[] copy_R() {
        int[] tmpCopy = new int[N];
        System.arraycopy(R, 0, tmpCopy, 0, R.length);
        return tmpCopy;
    }

    synchronized void write_MA(Integer[][] matrix) {
        for (int i = 0; i < matrix.length; i++) {
            System.arraycopy(matrix[i], 0, MA[i], 0, matrix[i].length);
        }
    }

    synchronized Integer[][] copy_MA() {
        Integer[][] tmpCopy = new Integer[N][N];
        for (int i = 0; i < MA.length; i++) {
            System.arraycopy(MA[i], 0, tmpCopy[i], 0, MA[i].length);
        }
        return tmpCopy;
    }

    synchronized void calc_q(int num) {
        this.q = Math.min(this.q, num);
    }

    synchronized int copy_q() {
        return q;
    }
}
