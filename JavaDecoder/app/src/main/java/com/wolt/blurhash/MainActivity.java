package com.wolt.blurhash;

import androidx.appcompat.app.AppCompatActivity;

import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.SystemClock;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;

import com.wolt.blurhash.decoder.BlurHashDecoder;

/**
 * @author Ilanthirayan Paramanathan <theebankala@gmail.com>
 * @version 2.0.0
 * @since 22nd of November 2020
 */
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        EditText etInput = findViewById(R.id.etInput);
        TextView tvDecode = findViewById(R.id.tvDecode);
        ImageView ivResult = findViewById(R.id.ivResult);
        TextView ivResultTime = findViewById(R.id.ivResultTime);

        tvDecode.setOnClickListener(view -> {
            long tStart = SystemClock.elapsedRealtime();
            Bitmap bitmap = BlurHashDecoder.getInstance().decode(etInput.getText().toString(), 20, 12, 1.0F, true);
            long tEnd = SystemClock.elapsedRealtime();
            long tRes = tEnd - tStart; // time in milliseconds
            ivResult.setImageBitmap(bitmap);
            ivResultTime.setText(String.format("Time : %dms", tRes));
        });
    }
}