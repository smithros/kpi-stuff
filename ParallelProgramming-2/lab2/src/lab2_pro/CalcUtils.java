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

    public static void bubbleSort(int[] vector, int start, int end) {
        for (int i = start; i < end - 1; i++) {
            for (int j = start + 1; j < end; j++) {
                if (vector[i] > vector[j]) {
                    int tmp = vector[i];
                    vector[i] = vector[j];
                    vector[j] = tmp;
                }
            }
        }
    }

    public static void mergeSort(int[] vector, int low, int high) {
        if (low < high) {
            int middle = (low / 2) + (high / 2);
            mergeSort(vector, low, middle);
            mergeSort(vector, middle + 1, high);
            mergeParts(vector, low, middle, high);
        }
    }

    private static void mergeParts(int[] vector, int low, int middle, int high) {
        int left = low;
        int right = middle + 1;
        int[] tmp = new int[(high - low) + 1];
        int tmpIndex = 0;

        if (high != vector.length) {
            while ((left <= middle) && (right <= high)) {
                if (vector[left] < vector[right]) {
                    tmp[tmpIndex] = vector[left];
                    left = left + 1;
                } else {
                    tmp[tmpIndex] = vector[right];
                    right = right + 1;
                }
                tmpIndex = tmpIndex + 1;
            }

            if (left <= middle) {
                while (left <= middle) {
                    tmp[tmpIndex] = vector[left];
                    left = left + 1;
                    tmpIndex = tmpIndex + 1;
                }
            }

            if (right <= high) {
                while (right <= high) {
                    tmp[tmpIndex] = vector[right];
                    right = right + 1;
                    tmpIndex = tmpIndex + 1;
                }
            }

            for (int i = 0; i < tmp.length; i++) {
                vector[low + i] = tmp[i];
            }
        }
      /*  else {
            System.out.println("kek");
        }*/
    }
}
