package lab2_pro;

import java.util.Arrays;
/**
 * Parallel and Distributed Computing
 * Laboratory work #2. Java (Monitors)
 * Task: A = sort(Z)*e +(B·C)*(D*MO)
 * Koval Rostyslav IO-71
 */
public class Lab2 {
    public static void main(String[] args) {
        final int N = 8;
        final int P = 4;
        final int H = N / P;
        final int ONE = 1;
        final int[] A = new int[N];
        final int[] Z = new int[N];
        final int[] B = new int[N];
        final int[] C = new int[N];
        final int[] D = new int[N];
        final int[][] MO = new int[N][N];

        final ResourceMonitor resourceMonitor = new ResourceMonitor(N);
        final SynchronizeMonitor synchronizeMonitor = new SynchronizeMonitor();

        //temporary
        final int[][] tmp_D_MO_mult = new int[P][N];
        final int[] x = new int[P];
        final int[] xi = new int[P];

        //common
        final int[] ei = new int[P];
        final int[][] Di = new int[P][N];

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
                        //Введення Z, MO
                        CalcUtils.vectorInput(Z, ONE);
                        CalcUtils.matrixInput(MO, ONE);
                        //Сигнал до T2,T3,T4 про введення Z, MO
                        synchronizeMonitor.signalInput();
                        break;
                    }
                    case 2: {
                        //Введення e, B
                        int e = ONE;
                        CalcUtils.vectorInput(B, ONE);
                        resourceMonitor.write_e(e);
                        synchronizeMonitor.signalInput();
                        break;
                    }
                    case 3: {
                        //Введення C,D
                        CalcUtils.vectorInput(C, ONE);
                        CalcUtils.vectorInput(D, ONE);
                        resourceMonitor.write_D(D);
                        synchronizeMonitor.signalInput();
                        break;
                    }
                    default:
                        break;
                }

                //Чекати завершення введення у T1, T3, T4
                synchronizeMonitor.waitInput();

                //Копіювання ei = e, Di = D
                ei[threadNumber] = resourceMonitor.copy_e();
                Di[threadNumber] = resourceMonitor.copy_D();

                //Сортування 1
                CalcUtils.bubbleSort(Z, threadNumber * H, (threadNumber + 1) * H);

                //Cигнал до Ti про завершення сортування 1
                synchronizeMonitor.signalSort1();

                //Чекати завершення сортування 1
                synchronizeMonitor.waitSort1();

                //Сортування 2
                if (threadNumber < 2) {
                    CalcUtils.mergeSort(Z, threadNumber * 2 * H, (threadNumber + 1) * 2 * H);

                    //Cигнал до Ti про завершення сортування 2
                    synchronizeMonitor.signalSort2();
                }

                //Чекати завершення сортування 2
                synchronizeMonitor.waitSort2();

                //Сортування 3
                if (threadNumber == 1) {
                    CalcUtils.mergeSort(Z, 0, N);

                    //Cигнал до Ti про завершення сортування 3
                    synchronizeMonitor.signalSort3();
                }

                //Чекати завершення сортування 3
                synchronizeMonitor.waitSort3();

                //Обчислення 1
                for (int i = threadNumber * H; i < (threadNumber + 1) * H; i++) {
                    x[threadNumber] += B[i] * C[i];
                }
                //Обчислення 2
                resourceMonitor.addX(x[threadNumber]);

                //Cигнал до Ti про завершення обчислення 2
                synchronizeMonitor.signalCalc1();

                //Чекати завершення обчислення 1
                synchronizeMonitor.waitCalc1();

                //Копіювання xi = x
                xi[threadNumber] = resourceMonitor.copy_x();

                //Обчислення 2
                for (int i = threadNumber * H; i < (threadNumber + 1) * H; i++) {
                    for (int j = 0; j < N; j++) {
                        tmp_D_MO_mult[threadNumber][i] += Di[threadNumber][j] * MO[j][i];
                    }
                    A[i] = Z[i] * ei[threadNumber] + xi[threadNumber] * tmp_D_MO_mult[threadNumber][i];
                }
                synchronizeMonitor.signalCalc2();

                //Чекати завершення обчислення 2
                synchronizeMonitor.waitCalc2();

                System.out.println("Thread " + (threadNumber + 1) + " finished.");
                if (threadNumber == 2) {
                    System.out.println(Arrays.toString(A));
                }
            }
        }

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
    }
}
