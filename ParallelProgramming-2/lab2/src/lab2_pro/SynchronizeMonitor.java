package lab2_pro;

public class SynchronizeMonitor {
    private int flagInput = 0;
    private int flagSort1 = 0;
    private int flagSort2 = 0;
    private int flagSort3 = 0;
    private int flagCalc1 = 0;
    private int flagCalc2 = 0;

    public synchronized void signalInput() {
        flagInput++;
        notifyAll();
    }

    public synchronized void waitInput() {
        while (flagInput != 3) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public synchronized void signalSort1() {
        flagSort1++;
        notifyAll();
    }

    public synchronized void waitSort1() {
        while (flagSort1 != 4) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public synchronized void signalSort2() {
        flagSort2++;
        notifyAll();
    }

    public synchronized void waitSort2() {
        while (flagSort2 != 2) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public synchronized void signalSort3() {
        flagSort3++;
        notifyAll();
    }

    public synchronized void waitSort3() {
        while (flagSort3 != 1) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public synchronized void signalCalc1() {
        flagCalc1++;
        notifyAll();
    }

    public synchronized void waitCalc1() {
        while (flagCalc1 != 4) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public synchronized void signalCalc2() {
        flagCalc2++;
        notifyAll();
    }

    public synchronized void waitCalc2() {
        while (flagCalc2 != 4) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
