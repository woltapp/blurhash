package com.wolt.blurhashapp

import android.graphics.Bitmap
import android.os.Bundle
import android.os.SystemClock
import androidx.appcompat.app.AppCompatActivity
import com.wolt.blurhashkt.BlurHashDecoder
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        tvDecode.setOnClickListener {
            var bitmap: Bitmap? = null
            val time = timed {
                bitmap = BlurHashDecoder.decode(etInput.text.toString(), 20, 12)
            }
            ivResult.setImageBitmap(bitmap)
            ivResultTime.text = "Time: $time ms"
        }
    }

}

/**
 * Executes a function and return the time spent in milliseconds.
 */
private inline fun timed(function: () -> Unit): Long {
    val start = SystemClock.elapsedRealtime()
    function()
    return SystemClock.elapsedRealtime() - start
}

