package lab2_pro;

public class SynchronizeMonitor {
    private int flagInput = 0;
    private int flagCalcQ = 0;
    private int flagCalcZ = 0;

    public synchronized void signalInput() {
        flagInput++;
        notifyAll();
    }

    public synchronized void waitInput() {
        while (flagInput != 4) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public synchronized void signalCalcQ() {
        flagCalcQ++;
        notifyAll();
    }

    public synchronized void waitCalcQ() {
        while (flagCalcQ != 4) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public synchronized void signalCalcZ() {
        flagCalcZ++;
        notifyAll();
    }

    public synchronized void waitCalcZ() {
        while (flagCalcZ != 4) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}
