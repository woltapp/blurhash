package com.wolt.blurhashapp

import android.os.Bundle
import android.view.View
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.wolt.blurhashkt.BlurHashDecoder

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        val etInput: EditText = findViewById(R.id.etInput)
        val ivResult: ImageView = findViewById(R.id.ivResult)
        findViewById<View>(R.id.tvDecode).setOnClickListener {
            val bitmap = BlurHashDecoder.decode(etInput.text.toString(), 20, 12)
            ivResult.setImageBitmap(bitmap)
        }
    }

}
