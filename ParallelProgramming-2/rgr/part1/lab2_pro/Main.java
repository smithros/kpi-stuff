package lab2_pro;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * Parallel and Distributed Computing
 * RGR. Java (Monitors)
 * Task: Z = X * (MA * MS) + min(Q) * (R * MF)
 * Koval Rostyslav IO-71
 */
public class Main {
    public static void main(String[] args) {
        final int N = 2400;
        final int P = 4;
        final int H = N / P;
        final int ONE = 1;
        final int[] Z = new int[N];
        final int[] X = new int[N];
        final int[] Q = new int[N];
        final int[] R = new int[N];
        final Integer[][] MA = new Integer[N][N];
        final int[][] MS = new int[N][N];
        final int[][] MF = new int[N][N];

        final ResourceMonitor resourceMonitor = new ResourceMonitor(N);
        final SynchronizeMonitor synchronizeMonitor = new SynchronizeMonitor();

        //temporary
        final int[][] tmp_R_MF_mult = new int[P][N];
        final int[][] MT = new int[P][N];
        final int[] q = new int[P];
        final int[] qi = new int[P];

        //common
        final int[][] Xi = new int[P][N];
        final int[][] Ri = new int[P][N];
        final List<Integer[][]> MA_i = Collections.synchronizedList(new ArrayList<>(5));

        class ThreadTask implements Runnable {
            int threadNumber;

            public ThreadTask(int tn) {
                threadNumber = tn;
            }

            @Override
            public void run() {
                System.out.println("Thread " + (threadNumber + 1) + " started.");

                switch (threadNumber) {
                    case 0: {
                        CalcUtils.matrixInput(MA, ONE);
                        resourceMonitor.write_MA(MA);
                        synchronizeMonitor.signalInput();
                        break;
                    }
                    case 1: {
                        CalcUtils.vectorInput(X, ONE);
                        CalcUtils.vectorInput(Z, ONE);
                        resourceMonitor.write_X(X);
                        synchronizeMonitor.signalInput();
                        break;
                    }
                    case 2: {
                        CalcUtils.vectorInput(R, ONE);
                        CalcUtils.matrixInput(MS, ONE);
                        resourceMonitor.write_R(R);
                        synchronizeMonitor.signalInput();
                        break;
                    }
                    case 3: {
                        CalcUtils.vectorInput(Q, ONE);
                        CalcUtils.matrixInput(MF, ONE);
                        synchronizeMonitor.signalInput();
                        break;
                    }
                    default:
                        break;
                }
                synchronizeMonitor.waitInput();

                Xi[threadNumber] = resourceMonitor.copy_X();
                Ri[threadNumber] = resourceMonitor.copy_R();
                MA_i.add(threadNumber, resourceMonitor.copy_MA());

                for (int i = threadNumber * H; i < (threadNumber + 1) * H; i++) {
                    q[threadNumber] = CalcUtils.findMin(Q);
                }

                resourceMonitor.calc_q(q[threadNumber]);

                synchronizeMonitor.signalCalcQ();

                synchronizeMonitor.waitCalcQ();

                qi[threadNumber] = resourceMonitor.copy_q();
                for (int i = threadNumber * H; i < (threadNumber + 1) * H; i++) {
                    for (int j = 0; j < N; j++) {
                        tmp_R_MF_mult[threadNumber][i] += (Ri[threadNumber][j] * MF[j][i]);
                        MT[threadNumber][i] += N * Xi[threadNumber][i] * (MS[j][i] * MA[j][i]); //MA_i.get(threadNumber)[j][i];
                    }
                    Z[i] = MT[threadNumber][i] + qi[threadNumber] * tmp_R_MF_mult[threadNumber][i];
                }
                synchronizeMonitor.signalCalcZ();
                synchronizeMonitor.waitCalcZ();

                System.out.println("Thread " + (threadNumber + 1) + " finished.");
                if (threadNumber == 1) {
                    System.out.println(Arrays.toString(Z));
                }
            }
        }


        long start = System.currentTimeMillis();
        Thread[] threads = new Thread[P];
        for (int i = 0; i < P; i++) {
            threads[i] = new Thread(new ThreadTask(i));
            threads[i].start();
        }

        try {
            threads[0].join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        long end = System.currentTimeMillis();

        System.out.println("Time: " + (end-start));
    }
}
