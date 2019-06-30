using System;

namespace Blurhash.Core
{
    public static class MathUtils
    {
        public static double SignPow(double val, double exp)
        {
            return Math.Sign(val) * Math.Pow(Math.Abs(val), exp);
        }

        public static double SRgbToLinear(int value) {
            var v = value / 255.0;
            if(v <= 0.04045) return v / 12.92;
            else return Math.Pow((v + 0.055) / 1.055, 2.4);
        }

        public static int LinearTosRgb(double value) {
            var v = Math.Max(0.0, Math.Min(1.0, value));
            if(v <= 0.0031308) return (int)(v * 12.92 * 255 + 0.5);
            else return (int)((1.055 * Math.Pow(v, 1 / 2.4) - 0.055) * 255 + 0.5);
        }
    }
}