package com.wolt.blurhashapp

import android.graphics.Bitmap
import android.os.Bundle
import android.view.View
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.wolt.blurhashkt.BlurHashDecoder
import kotlin.time.measureTime

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val tvDecode: View = findViewById(R.id.tvDecode)
        val etInput: EditText = findViewById(R.id.etInput)
        val ivResult: ImageView = findViewById(R.id.ivResult)
        val ivResultTime: TextView = findViewById(R.id.ivResultTime)

        tvDecode.setOnClickListener {
            val bitmap: Bitmap?
            val time = measureTime {
                bitmap = BlurHashDecoder.decode(etInput.text.toString(), 20, 12)
            }
            ivResult.setImageBitmap(bitmap)
            ivResultTime.text = "Time: ${time.inWholeMilliseconds} ms"
        }
    }

}
