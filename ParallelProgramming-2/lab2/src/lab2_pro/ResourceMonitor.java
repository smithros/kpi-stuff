package lab2_pro;

public class ResourceMonitor {
    private static int totalX = 0;
    private int N;
    private int e;
    private int[] D;

    public ResourceMonitor(int n) {
        N = n;
        D = new int[N];
    }

    synchronized void write_D(int[] r) {
        for (int i = 0; i < r.length; i++) {
            D[i] = r[i];
        }
    }

    synchronized int[] copy_D() {
        int[] tmpCopy = new int[N];
        System.arraycopy(D, 0, tmpCopy, 0, D.length);
        return tmpCopy;
    }

    synchronized void write_e(int e) {
        this.e = e;
    }

    synchronized int copy_e() {
        int tmpCopy = e;
        return tmpCopy;
    }

    synchronized void addX(int xi) {
        totalX += xi;
    }

    synchronized int copy_x() {
        return totalX;
    }
}
