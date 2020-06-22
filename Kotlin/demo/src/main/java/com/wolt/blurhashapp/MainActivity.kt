package com.wolt.blurhashapp

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.os.Bundle
import android.view.View
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.wolt.blurhashkt.BlurHashDecoder
import com.wolt.blurhashkt.BlurHashEncoder
import kotlinx.android.synthetic.main.activity_main.*

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        btnDecode.setOnClickListener {
            val bitmap = BlurHashDecoder.decode(etInput.text.toString(), 20, 12)
            ivResult.setImageBitmap(bitmap)
        }

        val buttons = listOf(btnEncode1, btnEncode2, btnEncode3, btnEncode4, btnEncode5)
        val drawableResList = listOf(R.drawable.img1, R.drawable.img2, R.drawable.img3, R.drawable.img4, R.drawable.img5)
        val onClickListener = View.OnClickListener {
            val bitmap = drawableToBitmap(ContextCompat.getDrawable(this, drawableResList[buttons.indexOf(it)])!!)
            etInput.setText(BlurHashEncoder.encode(bitmap))
        }
        for (button in buttons) {
            button.setOnClickListener(onClickListener)
        }
    }

    private fun drawableToBitmap(drawable: Drawable): Bitmap {
        return drawableToBitmap(drawable, drawable.intrinsicWidth,
                drawable.intrinsicHeight)
    }

    private fun drawableToBitmap(drawable: Drawable, w: Int, h: Int): Bitmap {
        if (drawable is BitmapDrawable) {
            return drawable.bitmap
        }
        val bitmap = Bitmap.createBitmap(w, h, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)
        return bitmap
    }

}
