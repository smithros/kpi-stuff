package com.example.lab33;

import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import java.util.Arrays;
import java.util.Objects;

import androidx.appcompat.app.AppCompatActivity;

public class MainActivity extends AppCompatActivity {

    // equation: a*x1 + b*x2 + c*x3 + d*x4 = y

    private int[][] startPopulation = new int[4][4];
    private int[][] resPopulation = new int[4][4];
    private int[] fitness = new int[4];
    private int[] stats = new int[4];
    private double[] diffs = new double[4];

    private EditText a, b, c, d, y;
    private TextView genotype, resTime;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void onButtonClick(View v) {
        findElements();

        int maxRange = getIntValue(y) / 2;

        for (int i = 0; i < startPopulation.length; i++) {
            startPopulation[i] = getRandomArray(maxRange);
        }

        int[] eqCoef = {getIntValue(a), getIntValue(b), getIntValue(c), getIntValue(d)};

        long timeBefore = System.currentTimeMillis();
        int[] result = calculateFitness(eqCoef, getIntValue(y));
        long time = System.currentTimeMillis() - timeBefore;

        resTime.setText(Long.toString(time));
        genotype.setText(Arrays.toString(result));
    }

    private int[] calculateFitness(int[] cor, int maxRange) {

        double sumDelta = 0;

        for (int i = 0; i < fitness.length; i++) {
            fitness[i] += startPopulation[i][0] * cor[i];
            diffs[i] = Math.abs(maxRange - fitness[i]);
        }

        for (int i = 0; i < diffs.length; i++) {
            if (diffs[i] == 0) {
                return startPopulation[i];
            }
            sumDelta += 1 / (diffs[i] + 1);
        }

        for (int i = 0; i < diffs.length; i++) {
            stats[i] = (int) ((1 / diffs[i]) / sumDelta * 100);
        }

        for (int i = 0; i < resPopulation.length; i++) {
            resPopulation[i] = populationRandomize();
        }

        crossOverGenotypes();

        // mutations
        getMutations();

        // recursive algorithm
        return calculateFitness(cor, maxRange);
    }

    public void findElements(){
        a = findViewById(R.id.a);
        b = findViewById(R.id.b);
        c = findViewById(R.id.c);
        d = findViewById(R.id.d);
        y = findViewById(R.id.y);
        resTime = findViewById(R.id.genotype);
        genotype = findViewById(R.id.resTime);
    }


    private int[] getRandomArray(int maxRange) {
        int[] rand = new int[4];
        for (int i = 0; i < rand.length; i++) {
            rand[i] = (int) (Math.random() * maxRange);
        }
        return rand;
    }

    public void crossOverGenotypes() {
        int tmp = Objects.requireNonNull(resPopulation[0])[0];
        resPopulation[0][0] = resPopulation[1][0];
        resPopulation[1][0] = tmp;

        tmp = resPopulation[2][resPopulation[2].length - 1];
        resPopulation[2][resPopulation[2].length - 1] = resPopulation[3][resPopulation[2].length - 1];
        resPopulation[3][resPopulation[2].length - 1] = tmp;
    }

    public void getMutations() {
        int firstMutation = getRandomNumber(resPopulation[2].length - 1);
        int secondMutation = getRandomNumber(resPopulation[2].length - 1);

        for (int i = 0; i < resPopulation.length; i++) {
            if (firstMutation == i) {
                resPopulation[i][secondMutation] += 1;
            }
        }

        System.arraycopy(resPopulation, 0, startPopulation, 0, resPopulation.length);
    }


    private int[] populationRandomize() {
        int genValue = getRandomNumber(100);

        if (genValue <= 100) {
            return startPopulation[3];
        }
        if (genValue < stats[0]) {
            return startPopulation[0];
        }
        if (genValue < stats[0] + stats[1]) {
            return startPopulation[1];
        }
        if (genValue < stats[0] + stats[1] + stats[2]) {
            return startPopulation[2];
        }
        return null;
    }

    public int getRandomNumber(int maxValue){
        return (int) (Math.random() * maxValue);
    }

    public int getIntValue(EditText param){
        return Integer.parseInt(param.getText().toString());
    }
}