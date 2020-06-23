package com.wolt.blurhashapp

import android.graphics.Bitmap
import android.os.*
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
    val start = SystemClock.elapsedRealtimeNanos()
    function()
    return SystemClock.elapsedRealtimeNanos() - start
}

private const val NANOS = 1000000.0

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
        executor.execute {
            notifyBenchmark("-----------------------------------")
            notifyBenchmark("Device: ${Build.MANUFACTURER} - ${Build.MODEL}")
            notifyBenchmark("OS: Android ${Build.VERSION.CODENAME} - API ${Build.VERSION.SDK_INT}")
        }
        executor.execute {
            notifyBenchmark("-----------------------------------")
        }
        for (tasks in 1..3) {
            executor.execute {
                notifyBenchmark("")
                notifyBenchmark("-----------------------------------")
                notifyBenchmark("Parallel tasks: $tasks")
                notifyBenchmark("-----------------------------------")
            }
            for (size in 1..3) {
                val width = 20 * 2.0.pow(size - 1).toInt()
                val height = 12 * 2.0.pow(size - 1).toInt()
                executor.execute {
                    notifyBenchmark("width: $width, height: $height")
                }
                for (imageCount in 0..2) {
                    executor.execute {
                        benchmark(10.0.pow(imageCount).toInt(), width, height, blurHash, useCache = true, tasks = tasks)
                    }
                }
                executor.execute {
                    notifyBenchmark("\n")
                }
            }
        }
        val s = "-----------------------------------\n"
        executor.execute {
            notifyBenchmark(s)
        }
        executor.execute {
            notifyBenchmark("END")
        }
    }

    private fun benchmark(max: Int, width: Int, height: Int, blurHash: String, useCache: Boolean, tasks: Int) {
        notifyBenchmark("-> $max bitmaps")
        var bmp: Bitmap? = null
        BlurHashDecoder.clearCache()
        val listOfTimes = ArrayList<Long>()
        for (i in 1..max) {
            listOfTimes.add(timed {
                bmp = BlurHashDecoder.decode(blurHash, width, height, useCache = useCache, parallelTasks = tasks)
            })
        }
        notifyBenchmark("<- ${listOfTimes.sum().millis().format()} ms, " +
                "Avg: ${(listOfTimes.sum().millis() / max.toDouble()).format()} ms, " +
                "Max: ${listOfTimes.max().millis().format()}, " +
                "Min: ${listOfTimes.min().millis().format()}")
        // log the bitmap size
        println("bmp size: ${bmp?.byteCount}")
    }

    private fun notifyBenchmark(s: String) {
        handler.post {
            liveData.value = s
        }
    }
}

private fun Long?.millis() = (this?.toDouble() ?: 0.0) / NANOS
private fun Double.format() = "%.${2}f".format(this)
