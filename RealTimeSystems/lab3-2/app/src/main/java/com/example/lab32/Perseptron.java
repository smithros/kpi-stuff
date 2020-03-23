package com.example.lab32;

import java.util.Random;


class Perceptron {

    private double[] weights;
    private double threshold;

    /**
     * @param inputs    - вхідні точки
     * @param outputs   - outputs.length - поріг спрацювання
     * @param threshold - контрольна сума
     * @param lrate     - швидкість навчання
     * @param epoch     - кількість ітерацій
     */
    public void train(double[][] inputs, int[] outputs,
                      double threshold, double lrate, int epoch) {

        this.threshold = threshold;
        int n = inputs[0].length;
        int p = outputs.length;
        this.weights = new double[n];
        Random r = new Random();

        for (int i = 0; i < n; i++) {
            weights[i] = r.nextDouble();
        }

        for (int i = 0; i < epoch; i++) {
            int totalError = 0;

            for (int j = 0; j < p; j++) {
                int output = output(inputs[j]);
                int error = outputs[j] - output;

                totalError += error;

                for (int k = 0; k < n; k++) {
                    double delta = lrate * inputs[j][k] * error;
                    weights[k] += delta;
                }
            }
            if (totalError == 0) break;
        }
    }

    public int output(double[] input) {
        double sum = 0.0;
        for (int i = 0; i < input.length; i++) {
            sum += weights[i] * input[i];
        }
        if (sum > threshold) {
            return 1;
        } else {
            return 0;
        }
    }

    public String showRes() {
        return "W1= " + weights[0] + " \nW2= " + weights[1];
    }
}