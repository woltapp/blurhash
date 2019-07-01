package com.wolt.blurhashapp

import android.os.Bundle
import android.widget.EditText
import android.widget.ImageView
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity
import com.wolt.blurhashkt.BlurHashDecoder.decode

class MainActivity : AppCompatActivity() {

    private lateinit var etBlurHash: EditText
    private lateinit var tvDecode: TextView
    private lateinit var ivBlurHash: ImageView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        etBlurHash = findViewById(R.id.etBlurHash)
        tvDecode = findViewById(R.id.tvDecode)
        ivBlurHash = findViewById(R.id.ivBlurHash)

        tvDecode.setOnClickListener { decodeBlurHash(etBlurHash.text.toString()) }
    }

    private fun decodeBlurHash(blurHashString: String) {
        Thread(Runnable {
            val bitmap = decode(blurHashString, 20, 20, 1f)
            ivBlurHash.post { ivBlurHash.setImageBitmap(bitmap) }
        }).start()
    }

}
