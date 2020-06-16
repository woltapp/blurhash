package com.wolt.blurhashapp

import android.os.Bundle
import android.os.SystemClock
import android.view.View
import android.widget.EditText
import android.widget.ImageView
import androidx.appcompat.app.AppCompatActivity
import com.wolt.blurhashkt.BlurHashDecoder
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val etInput: EditText = findViewById(R.id.etInput)
        val ivResult: ImageView = findViewById(R.id.ivResult)
        findViewById<View>(R.id.tvDecode).setOnClickListener {
            val start = SystemClock.elapsedRealtime()
            val bitmap = BlurHashDecoder.decode(etInput.text.toString(), 20, 12)
            val time = SystemClock.elapsedRealtime() - start
            ivResult.setImageBitmap(bitmap)
            ivResultMs.text = "Decode time: $time ms"
        }
    }

}
