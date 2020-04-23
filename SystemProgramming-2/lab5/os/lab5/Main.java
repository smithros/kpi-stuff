package os.lab5;

public class Main {
    public static void main(String[] args) {
        int[][] b = new int[100][100];
        int res = 0;
        long startTime = System.nanoTime();
        for (int j = 0; j < 100; j++) {
            for (int k = 0; k < 100; k++) {
                b[j][k]++;
            }
        }
        long endTime = System.nanoTime();
        System.out.println(endTime-startTime);
    }
}
