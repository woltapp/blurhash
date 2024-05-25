package com.wolt.blurhash.decoder;

import android.graphics.Bitmap;
import android.graphics.Color;
import android.os.Build;

import androidx.annotation.Nullable;

import java.util.HashMap;
import java.util.Map;

/**
 * @author Ilanthirayan Paramanathan <theebankala@gmail.com>
 * @version 2.0.0
 * @since 22nd of November 2020
 */
public class BlurHashDecoder {

    // cache Math.cos() calculations to improve performance.
    // The number of calculations can be huge for many bitmaps: width * height * numCompX * numCompY * 2 * nBitmaps
    // the cache is enabled by default, it is recommended to disable it only when just a few images are displayed
    private final HashMap<Integer, double[]> cacheCosinesX = new HashMap<>();
    private final HashMap<Integer, double[]> cacheCosinesY = new HashMap<>();
    private static Map<Character, Integer> charMap = new HashMap();

    private static final BlurHashDecoder INSTANCE = new BlurHashDecoder();

    public static BlurHashDecoder getInstance() {
        return INSTANCE;
    }

    private BlurHashDecoder() {
    }

    static {
        Character[] characters = {
                '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R',
                'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't',
                'u', 'v', 'w', 'x', 'y', 'z', '#', '$', '%', '*', '+', ',', '-', '.', ':', ';', '=', '?', '@', '[', ']', '^', '_', '{', '|', '}', '~'
        };
        for (int i = 0; i < characters.length; i++) {
            charMap.put(characters[i], i);
        }
    }

    /**
     * Clear calculations stored in memory cache.
     * The cache is not big, but will increase when many image sizes are used,
     * if the app needs memory it is recommended to clear it.
     */
    private void clearCache() {
        cacheCosinesX.clear();
        cacheCosinesY.clear();
    }

    /**
     * Decode a blur hash into a new bitmap.
     *
     * @param useCache use in memory cache for the calculated math, reused by images with same size.
     *                 if the cache does not exist yet it will be created and populated with new calculations.
     *                 By default it is true.
     */
    public Bitmap decode(@Nullable String blurHash, int width, int height, float punch, boolean useCache) {
        if (blurHash == null || blurHash.length() <= 6) {
            return null;
        }

        int numCompEnc = decode83(blurHash, 0, 1);
        int numCompX = numCompEnc % 9 + 1;
        int numCompY = numCompEnc / 9 + 1;
        if (blurHash.length() != 4 + 2 * numCompX * numCompY) {
            return null;
        } else {
            int maxAcEnc = this.decode83(blurHash, 1, 2);
            float maxAc = (float)(maxAcEnc + 1) / 166.0F;
            float[][] colors = new float[numCompX * numCompY][];

            for(int i = 0; i < numCompX * numCompY; ++i) {
                if (i == 0) {
                    int colorEnc = decode83(blurHash, 2, 6);
                    colors [i] = decodeDc(colorEnc);
                } else {
                    int from = 4 + i * 2;
                    int colorEnc = decode83(blurHash, from, from + 2);
                    colors [i] = decodeAc(colorEnc, maxAc * punch);
                }
            }
            return composeBitmap(width, height, numCompX, numCompY, colors, useCache);
        }
    }

    private int decode83(String str, int from, int to) {
        int result = 0;
        for (int i = from; i < to; i++) {
            int index = charMap.get(str.charAt(i));
            if (index != -1) {
                result = result * 83 + index;
            }
        }
        return result;
    }


    private float[] decodeDc(int colorEnc) {
        int r = colorEnc >> 16;
        int g = colorEnc >> 8 & 255;
        int b = colorEnc & 255;
        return new float[]{sRGBToLinear(r), sRGBToLinear(g), sRGBToLinear(b)};
    }

    private float sRGBToLinear(double colorEnc) {
        float v = (float)colorEnc / 255.0F;
        if (v <= 0.04045F) {
            return v / 12.92F;
        } else {
            return (float)Math.pow((v + 0.055F) / 1.055F, 2.4F);
        }
    }

    private float[] decodeAc(int value, float maxAc) {
        int r = value / 361;
        int g = (value / 19) % 19;
        int b = value % 19;
        return new float[]{
                signedPow2((r - 9) / 9.0F) * maxAc,
                signedPow2((g - 9) / 9.0F) * maxAc,
                signedPow2((b - 9) / 9.0F) * maxAc
        };
    }

    private float signedPow2(float value) {
        return Math.copySign((float)Math.pow((double)value, (double)2.0F), value);
    }

    private Bitmap composeBitmap(int width, int height, int numCompX, int numCompY, float[][] colors , boolean useCache) {
        // use an array for better performance when writing pixel colors
        int[] imageArray = new int[width * height];
        boolean calculateCosX = !useCache || !cacheCosinesX.containsKey(width * numCompX);
        double[] cosinesX = getArrayForCosinesX(calculateCosX, width, numCompX);
        boolean calculateCosY = !useCache || !cacheCosinesY.containsKey(height * numCompY);
        double[] cosinesY = getArrayForCosinesY(calculateCosY, height, numCompY);
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                float r = 0.0F;
                float g = 0.0F;
                float b = 0.0F;
                for (int j = 0; j < numCompY; j++) {
                    for (int i = 0; i < numCompX; i++) {
                        double cosX = getCos(cosinesX, calculateCosX, i, numCompX, x, width);
                        double cosY = getCos(cosinesY, calculateCosY, j, numCompY, y, height);
                        float basis = (float)(cosX * cosY);
                        float[] color = colors[j * numCompX + i];
                        r += color[0] * basis;
                        g += color[1] * basis;
                        b += color[2] * basis;
                    }
                }

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    imageArray[x + width * y] = Color.rgb(linearToSRGB(r), linearToSRGB(g), linearToSRGB(b));
                } else {
                    imageArray[x + width * y] = Color.argb(255, linearToSRGB(r), linearToSRGB(g), linearToSRGB(b));
                }
            }
        }
        return Bitmap.createBitmap(imageArray, width, height, Bitmap.Config.ARGB_8888);
    }

    private double[] getArrayForCosinesY(boolean calculate, int height, int numCompY)  {
        if (calculate) {
            double[] cosinesY = new double[height * numCompY];
            cacheCosinesY.put(height * numCompY, cosinesY);
            return cosinesY;
        } else {
            return (double[]) cacheCosinesY.get(height * numCompY);
        }
    }

    private double[] getArrayForCosinesX(boolean calculate, int width, int numCompX) {
        if (calculate) {
            double[] cosinesX = new double[width * numCompX];
            cacheCosinesX.put(width * numCompX, cosinesX);
            return cosinesX;
        } else {
            return (double[]) cacheCosinesX.get(width * numCompX);
        }
    }

    private double getCos(double[] getCos, boolean calculate, int x, int numComp, int y, int size) {
        if (calculate) {
            getCos[x + numComp * y] = Math.cos(Math.PI * y * x / size);
        }
        return getCos[x + numComp * y];
    }

    private int linearToSRGB(double value) {
        double v = Math.max(0, Math.min(1, value));
        if (v <= 0.0031308F) {
            return (int) (v * 12.92F * 255.0F + 0.5F);
        } else {
            return (int) ((1.055F * Math.pow(v, (1 / 2.4F)) - 0.055F) * 255 + 0.5F);
        }
    }
}
