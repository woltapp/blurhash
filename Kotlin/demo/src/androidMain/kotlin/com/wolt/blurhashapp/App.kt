package com.wolt.blurhashapp

import android.graphics.Bitmap
import android.os.Bundle
import android.os.SystemClock
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.Image
import androidx.compose.foundation.layout.*
import androidx.compose.material.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.asImageBitmap
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.tooling.preview.Preview
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.wolt.blurhashkt.BlurHashDecoder

@Composable
@Preview
fun App() {
    val defaultBlurHash = "LEHV6nWB2yk8pyo0adR*.7kCMdnj"
    var blurHashInput by remember { mutableStateOf(defaultBlurHash) }
    var bitmap by remember { mutableStateOf<Bitmap?>(null) }
    var decodingTime by remember { mutableStateOf<Long>(0) }

    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp),
        horizontalAlignment = Alignment.CenterHorizontally
    ) {
        // Input field for BlurHash
        OutlinedTextField(
            value = blurHashInput,
            onValueChange = { blurHashInput = it },
            label = { Text("Enter BlurHash") },
            singleLine = true,
            textStyle = TextStyle(
                color = MaterialTheme.colors.primary,
                textAlign = TextAlign.Center
            ),
            modifier = Modifier.fillMaxWidth()
        )

        // Decode button
        Button(
            onClick = {
                bitmap = null // Clear current image
                val time = timed {
                    bitmap = BlurHashDecoder.decode(blurHashInput, 20, 12)
                }
                decodingTime = time
            },
            modifier = Modifier
                .padding(top = 12.dp)
                .height(48.dp),
            colors = ButtonDefaults.buttonColors(
                backgroundColor = MaterialTheme.colors.primary
            )
        ) {
            Text(
                "DECODE",
                color = MaterialTheme.colors.secondary,
                fontSize = 16.sp
            )
        }

        // Image result
        bitmap?.let {
            Image(
                bitmap = it.asImageBitmap(),
                contentDescription = "Decoded BlurHash Image",
                modifier = Modifier
                    .padding(top = 24.dp)
                    .fillMaxWidth()
                    .aspectRatio(it.width.toFloat() / it.height.toFloat())
            )
        }

        // Time result
        Text(
            text = "Time: $decodingTime ms",
            fontSize = 16.sp,
            textAlign = TextAlign.Center,
            modifier = Modifier
                .padding(top = 8.dp)
                .fillMaxWidth()
        )
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
