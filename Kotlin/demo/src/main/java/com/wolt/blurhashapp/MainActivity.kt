package com.wolt.blurhashapp

import android.graphics.Bitmap
import android.os.Bundle
import android.os.SystemClock
import androidx.appcompat.app.AppCompatActivity
import com.wolt.blurhashapp.databinding.ActivityMainBinding
import com.wolt.blurhashkt.BlurHashDecoder


class MainActivity : AppCompatActivity() {

    private lateinit var binding: ActivityMainBinding

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        binding.tvDecode.setOnClickListener {
            var bitmap: Bitmap? = null
            val time = timed {
                bitmap = BlurHashDecoder.decode(binding.etInput.text.toString(), 20, 12)
            }
            binding.ivResult.setImageBitmap(bitmap)
            binding.ivResultTime.text = "Time: $time ms"
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

