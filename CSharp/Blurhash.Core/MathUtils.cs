using System;

namespace Blurhash.Core
{
    /// <summary>
    /// Utility methods for mathematical calculations
    /// </summary>
    public static class MathUtils
    {
        /// <summary>
        /// Calculates <c>Math.Pow(base, exponent)</c> but retains the sign of <c>base</c> in the result.
        /// </summary>
        /// <param name="base">The base of the power. The sign of this value will be the sign of the result</param>
        /// <param name="exponent">The exponent of the power</param>
        public static double SignPow(double @base, double exponent)
        {
            return Math.Sign(@base) * Math.Pow(Math.Abs(@base), exponent);
        }

        /// <summary>
        /// Converts an sRGB input value (0 to 255) into a linear double value
        /// </summary>
        public static double SRgbToLinear(int value) {
            var v = value / 255.0;
            if(v <= 0.04045) return v / 12.92;
            else return Math.Pow((v + 0.055) / 1.055, 2.4);
        }

        /// <summary>
        /// Converts a linear double value into an sRGB input value (0 to 255)
        /// </summary>
        public static int LinearTosRgb(double value) {
            var v = Math.Max(0.0, Math.Min(1.0, value));
            if(v <= 0.0031308) return (int)(v * 12.92 * 255 + 0.5);
            else return (int)((1.055 * Math.Pow(v, 1 / 2.4) - 0.055) * 255 + 0.5);
        }
    }
}