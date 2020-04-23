package lab2_pro;

import java.util.Arrays;

public class CalcUtils {

    public static void vectorInput(int[] vector, int filler) {
        Arrays.fill(vector, filler);
    }

    public static void matrixInput(int[][] matrix, int filler) {
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix.length; j++) {
                matrix[i][j] = filler;
            }
        }
    }

    public static void matrixInput(Integer[][] matrix, int filler) {
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix.length; j++) {
                matrix[i][j] = filler;
            }
        }
    }

    public static int findMin(int[] vector){
        int min = vector[0];
        for (int value : vector) {
            if (min < value) {
                min = value;
            }
        }
        return min;
    }

}
