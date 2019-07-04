using System;
using System.Linq;
using System.Numerics;
using System.Threading.Tasks;

namespace Blurhash.Core
{
    /// <summary>
    /// The core decoding algorithm of Blurhash.
    /// To be not specific to any graphics manipulation library this algorithm only operates on <c>double</c> values.
    /// </summary>
    public class CoreDecoder
    {
        /// <summary>
        /// A callback to be called when the progress of the operation changes.
        /// It receives a value between 0.0 and 1.0 that indicates the progress.
        /// </summary>
        public Action<double> ProgressCallback { get; set; }

        /// <summary>
        /// Decodes a Blurhash string into a 2-dimensional array of pixels
        /// </summary>
        /// <param name="blurhash">The blurhash string to decode</param>
        /// <param name="outputWidth">The desired width of the output in pixels</param>
        /// <param name="outputHeight">The desired height of the output in pixels</param>
        /// <param name="punch">A value that affects the contrast of the decoded image. 1 means normal, smaller values will make the effect more subtle, and larger values will make it stronger.</param>
        /// <returns>A 2-dimensional array of <see cref="Pixel"/>s </returns>
        protected Pixel[,] CoreDecode(string blurhash, int outputWidth, int outputHeight, double punch = 1.0) {
            if (blurhash.Length < 6) {
                throw new ArgumentException("Blurhash value needs to be at least 6 characters", nameof(blurhash));
            }

            var sizeFlag = (int) new[] {blurhash[0]}.DecodeBase83Integer();

            var componentsY = sizeFlag / 9 + 1;
            var componentsX = sizeFlag % 9 + 1;

            if (blurhash.Length != 4 + 2 * componentsX * componentsY) {
                throw new ArgumentException("Blurhash value is missing data", nameof(blurhash));
            }

            var quantizedMaximumValue = (double) new[] {blurhash[1]}.DecodeBase83Integer();
            var maximumValue = (quantizedMaximumValue + 1.0) / 166.0;

            var coefficients = new Pixel[componentsX, componentsY];
            {
                var i = 0;
                for (var y = 0; y < componentsY; y++)
                {
                    for (var x = 0; x < componentsX; x++)
                    {
                        if (x == 0 && y == 0)
                        {
                            var substring = blurhash.Substring(2, 4);
                            var value = substring.DecodeBase83Integer();
                            coefficients[x, y] = DecodeDc(value);
                        }
                        else
                        {
                            var substring = blurhash.Substring(4 + i * 2, 2);
                            var value = substring.DecodeBase83Integer();
                            coefficients[x, y] = DecodeAc(value, maximumValue * punch);
                        }

                        i++;
                    }
                }
            }

            var pixels = new Pixel[outputWidth, outputHeight];
            var pixelCount = outputHeight * outputWidth;
            var currentPixel = 0;

            var coordinates = Enumerable.Range(0, outputWidth)
                .SelectMany(x => Enumerable.Range(0, outputHeight).Select(y => new Coordinate(x, y)))
                .ToArray();

            var locker = new object();
            Parallel.ForEach(coordinates,
                (coordinate) =>
                {
                    pixels[coordinate.X, coordinate.Y] = DecodePixel(componentsY, componentsX, coordinate.X, coordinate.Y, outputWidth, outputHeight, coefficients);

                    lock (locker)
                    {
                        ProgressCallback?.Invoke((double) currentPixel / pixelCount);
                        currentPixel++;
                    }
                });
 
            return pixels;
        }

        private Pixel DecodePixel(
            int componentsY, int componentsX, 
            int x, int y,
            int width, int height,
            Pixel[,] coefficients)
        {
            var r = 0.0;
            var g = 0.0;
            var b = 0.0;

            for (var j = 0; j < componentsY; j++)
            {
                for (var i = 0; i < componentsX; i++)
                {
                    var basis = Math.Cos((Math.PI * x * i) / width) * Math.Cos((Math.PI * y * j) / height);
                    var coefficient = coefficients[i, j];
                    r += coefficient.Red * basis;
                    g += coefficient.Green * basis;
                    b += coefficient.Blue * basis;
                }
            }

            var result = new Pixel(r, g, b);
            return result;
        }

        private static Pixel DecodeDc(BigInteger value)
        {
            var intR = (int)value >> 16;
            var intG = (int)(value >> 8) & 255;
            var intB = (int)value & 255;
            return new Pixel(MathUtils.SRgbToLinear(intR), MathUtils.SRgbToLinear(intG), MathUtils.SRgbToLinear(intB));
        }

        private static Pixel DecodeAc(BigInteger value, double maximumValue) {
            var quantizedR = (double) (value / (19 * 19));
            var quantizedG = (double) ((value / 19) % 19);
            var quantizedB = (double) (value % 19);

            var result = new Pixel(
                MathUtils.SignPow((quantizedR - 9.0) / 9.0, 2.0) * maximumValue, 
                MathUtils.SignPow((quantizedG - 9.0) / 9.0, 2.0) * maximumValue,
                MathUtils.SignPow((quantizedB - 9.0) / 9.0, 2.0) * maximumValue
                );

            return result;
        }

    }
}