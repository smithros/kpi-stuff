package com.example.lab32;

import android.os.Build;
import android.os.Bundle;
import android.support.annotation.RequiresApi;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.EditText;
import android.widget.Spinner;

import java.time.LocalDateTime;

public class MainActivity extends AppCompatActivity {

    private EditText endResult;
    private Spinner spinner1;
    private Spinner spinner2;
    private Spinner spinner3;

    private static String[] learnRate = {"0.001", "0.01", "0.05", "0.1", "0.2", "0.3"};
    private static String[] deadline = {"0.5", "1", "2", "5"};
    private static String[] iterations = {"100", "200", "500", "1000",};

    private double learnRateVal;
    private double deadlineVal;
    private int iterVal;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        endResult = findViewById(R.id.editText);

        spinner1 = findViewById(R.id.learnRate);
        spinner2 = findViewById(R.id.deadline);
        spinner3 = findViewById(R.id.iter);

        spinner(spinner1, learnRate);
        spinner(spinner2, deadline);
        spinner(spinner3, iterations);
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    public void onButtonClick(View v) {
        Perceptron perceptron = new Perceptron();

        double[][] inputs = {{0, 6}, {1, 5}, {3, 3}, {2, 4}};
        int[] outputs = {0, 0, 0, 1};
        LocalDateTime dateTime = LocalDateTime.now();
        int seconds = dateTime.toLocalTime().toSecondOfDay();
        int currTime = dateTime.toLocalTime().toSecondOfDay();

        while (currTime <= seconds + deadlineVal) {
            currTime = dateTime.toLocalTime().toSecondOfDay();
            perceptron.train(inputs, outputs, 0.2, learnRateVal, iterVal);
        }

        endResult.setText(perceptron.showRes());
    }

    public void spinner(final Spinner spinner, String[] data) {

        ArrayAdapter<String> adapter = new ArrayAdapter<>(this, android.R.layout.simple_spinner_item, data);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);

        AdapterView.OnItemSelectedListener itemSelectedListener = new AdapterView.OnItemSelectedListener() {
            @Override
            public void onItemSelected(AdapterView<?> parent, View view, int position, long id) {
                if (spinner.equals(spinner1)) {
                    learnRateVal = Double.parseDouble(spinner1.getSelectedItem().toString());
                } else if (spinner.equals(spinner2)) {
                    deadlineVal = Double.parseDouble(spinner2.getSelectedItem().toString());
                } else if (spinner.equals(spinner3)) {
                    iterVal = Integer.parseInt(spinner3.getSelectedItem().toString());
                }
            }

            @Override
            public void onNothingSelected(AdapterView<?> parent) {

            }
        };
        spinner.setOnItemSelectedListener(itemSelectedListener);
    }
}
