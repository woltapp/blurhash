using System;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Blurhash.Core
{
    /// <summary>
    /// The core encoding algorithm of Blurhash.
    /// To be not specific to any graphics manipulation library this algorithm only operates on <c>double</c> values.
    /// </summary>
    public class CoreEncoder
    {
        /// <summary>
        /// A callback to be called when the progress of the operation changes.
        /// It receives a value between 0.0 and 1.0 that indicates the progress.
        /// </summary>
        public Action<double> ProgressCallback { get; set; }

        /// <summary>
        /// Encodes a 2-dimensional array of pixels into a Blurhash string
        /// </summary>
        /// <param name="pixels">The 2-dimensional array of pixels to encode</param>
        /// <param name="componentsX">The number of components used on the X-Axis for the DCT</param>
        /// <param name="componentsY">The number of components used on the Y-Axis for the DCT</param>
        /// <returns>The resulting Blurhash string</returns>
        protected string CoreEncode(Pixel[,] pixels, int componentsX, int componentsY)
        {
            if (componentsX < 1) throw new ArgumentException("componentsX needs to be at least 1");
            if (componentsX > 9) throw new ArgumentException("componentsX needs to be at most 9");
            if (componentsY < 1) throw new ArgumentException("componentsY needs to be at least 1");
            if (componentsY > 9) throw new ArgumentException("componentsY needs to be at most 9");

            var factors = new Pixel[componentsX, componentsY];

            var components = Enumerable
                .Range(0, componentsX)
                .SelectMany(i => Enumerable.Range(0, componentsY).Select(j => new Coordinate(i, j)))
                .ToArray(); // Create tuples (i,j) for all components

            var factorCount = componentsX * componentsY;
            var factorIndex = 0;

            var locker = new object();

            // Parallel
            Parallel.ForEach(components,
                (coordinate) =>
                {
                    factors[coordinate.X, coordinate.Y] = MultiplyBasisFunction(coordinate.X, coordinate.Y, pixels);

                    lock (locker)
                    {
                        ProgressCallback?.Invoke((double) factorIndex / factorCount);
                        factorIndex++;
                    }
                });

            var dc = factors[0, 0];
            var acCount = componentsX * componentsY - 1;
            var resultBuilder = new StringBuilder();

            var sizeFlag = (componentsX - 1) + (componentsY - 1) * 9;
            resultBuilder.Append(sizeFlag.EncodeBase83(1));

            float maximumValue;
            if(acCount > 0)
            {
                // Get maximum absolute value of all AC components
                var actualMaximumValue = 0.0;
                for (var y = 0; y < componentsY; y++)
                {
                    for (var x = 0; x < componentsX; x++)
                    {
                        // Ignore DC component
                        if (x == 0 && y == 0) continue;

                        actualMaximumValue = Math.Max(Math.Abs(factors[x,y].Red), actualMaximumValue);
                        actualMaximumValue = Math.Max(Math.Abs(factors[x,y].Green), actualMaximumValue);
                        actualMaximumValue = Math.Max(Math.Abs(factors[x,y].Blue), actualMaximumValue);
                    }
                }

                var quantizedMaximumValue = (int) Math.Max(0.0, Math.Min(82.0, Math.Floor(actualMaximumValue * 166 - 0.5)));
                maximumValue = ((float)quantizedMaximumValue + 1) / 166;
                resultBuilder.Append(quantizedMaximumValue.EncodeBase83(1));
            } else {
                maximumValue = 1;
                resultBuilder.Append(0.EncodeBase83(1));
            }

            resultBuilder.Append(EncodeDc(dc.Red, dc.Green, dc.Blue).EncodeBase83(4));


            for (var y = 0; y < componentsY; y++)
            {
                for (var x = 0; x < componentsX; x++)
                {
                    // Ignore DC component
                    if (x == 0 && y == 0) continue;
                    resultBuilder.Append(EncodeAc(factors[x, y].Red, factors[x, y].Green, factors[x, y].Blue, maximumValue).EncodeBase83(2));
                }
            }

            return resultBuilder.ToString();
        }

        private static Pixel MultiplyBasisFunction(int xComponent, int yComponent, Pixel[,] pixels)
        {
            double r = 0, g = 0, b = 0;
            double normalization = (xComponent == 0 && yComponent == 0) ? 1 : 2;

            var width = pixels.GetLength(0);
            var height = pixels.GetLength(1);

            for(var y = 0; y < height; y++)
            {
                for(var x = 0; x < width; x++) {
                    var basis = Math.Cos(Math.PI * xComponent * x / width) * Math.Cos(Math.PI * yComponent * y / height);
                    r += basis * pixels[x,y].Red;
                    g += basis * pixels[x,y].Green;
                    b += basis * pixels[x,y].Blue;
                }
            }

            var scale = normalization / (width * height);
            return new Pixel(r * scale, g * scale, b * scale);
        }

        private static int EncodeAc(double r, double g, double b, double maximumValue) {
            var quantizedR = (int) Math.Max(0, Math.Min(18, Math.Floor(MathUtils.SignPow(r / maximumValue, 0.5) * 9 + 9.5)));
            var quantizedG = (int) Math.Max(0, Math.Min(18, Math.Floor(MathUtils.SignPow(g / maximumValue, 0.5) * 9 + 9.5)));
            var quanzizedB = (int) Math.Max(0, Math.Min(18, Math.Floor(MathUtils.SignPow(b / maximumValue, 0.5) * 9 + 9.5)));

            return quantizedR * 19 * 19 + quantizedG * 19 + quanzizedB;
        }

        private static int EncodeDc(double r, double g, double b) {
            var roundedR = MathUtils.LinearTosRgb(r);
            var roundedG = MathUtils.LinearTosRgb(g);
            var roundedB = MathUtils.LinearTosRgb(b);
            return (roundedR << 16) + (roundedG << 8) + roundedB;
        }
    }
}