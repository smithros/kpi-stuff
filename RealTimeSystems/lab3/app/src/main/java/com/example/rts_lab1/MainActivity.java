package com.example.rts_lab1;

import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.basgeekball.awesomevalidation.AwesomeValidation;
import com.basgeekball.awesomevalidation.ValidationStyle;

public class MainActivity extends AppCompatActivity {

    // Виконано дане раніше завдання про валідацію вводу:
    // Не можна вводити великі числа, або жодного символу
    private static final String LESS_THAN_AND_EMPTY = "^((?!(0))[0-9]{1,5})$";

    private EditText input;
    private EditText endResult;
    private Button button;
    private AwesomeValidation awesomeValidation;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void onButtonClick(View v) {
        endResult = findViewById(R.id.endResult);
        input = findViewById(R.id.number);
        button = findViewById(R.id.button);

        awesomeValidation = new AwesomeValidation(ValidationStyle.BASIC);
        awesomeValidation.addValidation(this, R.id.number, LESS_THAN_AND_EMPTY,
                R.string.bigger_than);

        String result = factorize();
        endResult.setText(result);

        button.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (awesomeValidation.validate()) {
                    Toast.makeText(getApplicationContext(),
                            "Validation success",
                            Toast.LENGTH_SHORT).show();
                } else {
                    Toast.makeText(getApplicationContext(),
                            "Validation failed",
                            Toast.LENGTH_SHORT).show();
                }
            }
        });
    }

    public String factorize() {
        String result = "";
        String text = input.getText().toString();

        if (text.isEmpty()){
            text = "0";
        }
        int n = Integer.parseInt(text);

        if (n <= 0) {
            result += n + " ";
            return result;
        }

        int square_root = (int) Math.ceil(Math.sqrt(n));

        if (square_root * square_root == n) {
            result += " " + square_root + ", " + square_root;
            return result;
        }

        int b;

        while (true) {
            int b1 = square_root * square_root - n;
            b = (int) (Math.sqrt(b1));

            if (b * b == b1)
                break;
            else
                square_root += 1;
        }
        result += " " + (square_root - b) + "," + (square_root + b) + " ";
        return result;
    }
}
