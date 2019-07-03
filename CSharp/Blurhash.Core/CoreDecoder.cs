using System;
using System.Linq;
using System.Numerics;
using System.Threading.Tasks;

namespace Blurhash.Core
{
    public class CoreDecoder
    {
        public Action<double> ProgressCallback { get; set; }

        protected Pixel[,] CoreDecode(string blurhash, int width, int height, double punch = 1.0) {
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

            var pixels = new Pixel[width, height];
            var pixelCount = height * width;
            var currentPixel = 0;

            var coordinates = Enumerable.Range(0, width)
                .SelectMany(x => Enumerable.Range(0, height).Select(y => new Coordinate(x, y)))
                .ToArray();

            var locker = new object();
            Parallel.ForEach(coordinates,
                (coordinate) =>
                {
                    pixels[coordinate.x, coordinate.y] = DecodePixel(componentsY, componentsX, coordinate.x, coordinate.y, width, height, coefficients);

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
                    r += coefficient.r * basis;
                    g += coefficient.g * basis;
                    b += coefficient.b * basis;
                }
            }

            var result = new Pixel(r, g, b);
            return result;
        }

        static Pixel DecodeDc(BigInteger value)
        {
            var intR = (int)value >> 16;
            var intG = (int)(value >> 8) & 255;
            var intB = (int)value & 255;
            return new Pixel(MathUtils.SRgbToLinear(intR), MathUtils.SRgbToLinear(intG), MathUtils.SRgbToLinear(intB));
        }

        static Pixel DecodeAc(BigInteger value, double maximumValue) {
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