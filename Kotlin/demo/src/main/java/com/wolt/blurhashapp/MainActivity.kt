package com.wolt.blurhashapp

import android.graphics.Bitmap
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.view.View.INVISIBLE
import android.view.View.VISIBLE
import androidx.appcompat.app.AppCompatActivity
import androidx.lifecycle.*
import com.wolt.blurhashkt.BlurHashDecoder
import kotlinx.android.synthetic.main.activity_main.*
import java.util.concurrent.Executors
import kotlin.math.pow

class MainActivity : AppCompatActivity() {

    private lateinit var vm: Vm

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        vm = ViewModelProvider(this).get(Vm::class.java)
        vm.observe(this, Observer {
            when (it) {
                "START" -> progressBar.visibility = VISIBLE
                "END" -> progressBar.visibility = INVISIBLE
                else -> {
                    ivResultBenchmark.append("\n$it")
                    ivResultBenchmark.scrollTo(0, ivResultBenchmark.layout.lineCount)
                }
            }
        })
        tvDecode.setOnClickListener {
            val bitmap = BlurHashDecoder.decode(etInput.text.toString(), 20, 12)
            ivResult.setImageBitmap(bitmap)
            ivResultBenchmark.setText("")
            vm.startBenchMark(etInput.text.toString())
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

class Vm : ViewModel() {
    private val liveData = MutableLiveData<String>()
    private val executor = Executors.newSingleThreadExecutor()
    private val handler = Handler(Looper.getMainLooper())

    fun observe(owner: LifecycleOwner, observer: Observer<in String>) {
        liveData.observe(owner, observer)
    }

    fun startBenchMark(blurHash: String) {
        executor.execute {
            notifyBenchmark("START")
        }
        for (useArray in 1 downTo 0) {
            val useArray1 = useArray == 1
            for (useCache in 1 downTo 0) {
                val useCache1 = useCache == 1
                executor.execute {
                    notifyBenchmark("-----------------------------------")
                    notifyBenchmark("Array: $useArray1, cache: $useCache1")
                    notifyBenchmark("-----------------------------------")
                }
                for (s in 1..3) {
                    val width = 20 * 2.toDouble().pow(s - 1).toInt()
                    val height = 12 * 2.toDouble().pow(s - 1).toInt()
                    executor.execute {
                        notifyBenchmark("width: $width, height: $height")
                    }
                    for (n in 1..3) {
                        executor.execute {
                            benchmark(10.toDouble().pow(n).toInt(), width, height, blurHash, useArray1, useCache1)
                        }
                    }
                    executor.execute {
                        notifyBenchmark("\n")
                    }
                }
                val s = "-----------------------------------\n"
                executor.execute {
                    notifyBenchmark(s)
                }
            }
        }
        executor.execute {
            notifyBenchmark("END")
        }
    }

    private fun benchmark(max: Int, width: Int, height: Int, blurHash: String, useArray: Boolean, useCache: Boolean) {
        notifyBenchmark("-> $max bitmaps")
        var bmp: Bitmap? = null
        val time = timed {
            for (i in 1..max) {
                bmp = BlurHashDecoder.decode(blurHash, width, height, useArray = useArray, useCache = useCache)
            }
        }
        notifyBenchmark("<- $time ms, Avg: ${time / max.toDouble()} ms")
        // log the bitmap size
        println("bmp size: ${bmp?.byteCount}")
    }

    private fun notifyBenchmark(s: String) {
        handler.post {
            liveData.value = s
        }
    }
}
