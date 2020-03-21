package com.example.rts_lab1;

//import android.support.design.widget.TextInputLayout;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;

public class TestActivity extends AppCompatActivity {

    private EditText input;
    private EditText endResult;
    //private TextInputLayout message;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void onButtonClick(View v) {
        input = findViewById(R.id.number);
        endResult = findViewById(R.id.endResult);
        Button submit = findViewById(R.id.button);

        input.addTextChangedListener(new ValidationTextWatcher(input));

        int number = Integer.parseInt(input.getText().toString());
        String result = factorize(number);


        // Capture button clicks
     /*   submit.setOnClickListener(new View.OnClickListener() {
            public void onClick(View arg0) {
                if (!validateInput()) {
                    return;
                }
            }
        });*/

        endResult.setText(result);
    }

    private class ValidationTextWatcher implements TextWatcher {

        private View view;

        private ValidationTextWatcher(View view) {
            this.view = view;
        }

        public void beforeTextChanged(CharSequence charSequence, int i, int i1, int i2) {
        }

        public void onTextChanged(CharSequence charSequence, int i, int i1, int i2) {
        }

        public void afterTextChanged(Editable editable) {
            switch (view.getId()) {
                case R.id.number:
                    //validateInput();
                    break;
            }
        }
    }

    private void requestFocus(View view) {
        if (view.requestFocus()) {
            getWindow().setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_STATE_ALWAYS_VISIBLE);
        }
    }
/*
    private boolean validateInput() {
        if (input.getText().toString().trim().isEmpty()) {
            message.setError("Number is required");
            requestFocus(input);
            return false;
        } else if (input.getText().toString().length() < 5) {
            message.setError("Number can't be bigger than 5 digit");
            requestFocus(input);
            return false;
        } else {
            message.setErrorEnabled(false);
        }
        return true;
    }*/

    public String factorize(int n) {
        String result = "";

        if (n <= 0) {
            result += n + " ";
            return result;
        }

        if (n % 2 == 0) {
            //result += " "+  n / 2.0 + ", " + 2;
            result += "The number must be odd, not even";
            return result;
        }

        int square_root = (int) Math.ceil(Math.sqrt(n));

        if (square_root * square_root == n) {
            System.out.print("[" + square_root + "," + square_root + "]");
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
