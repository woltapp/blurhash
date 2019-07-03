using System.Drawing.Imaging;
using System.Linq;
using Blurhash.Core;

namespace System.Drawing.Blurhash
{
    public class Decoder : CoreDecoder
    {
        public Image Decode(string blurhash, int width, int height, double punch = 1.0)
        {
            var pixelData = base.CoreDecode(blurhash, width, height, punch);
            return ConvertToBitmap(pixelData);
        }

        internal static unsafe Bitmap ConvertToBitmap(global::Blurhash.Core.Pixel[,] pixelData)
        {
            var width = pixelData.GetLength(0);
            var height = pixelData.GetLength(1);

            var data = Enumerable.Range(0, height)
                .SelectMany(y => Enumerable.Range(0, width).Select(x => (x, y)))
                .Select(tuple => pixelData[tuple.x, tuple.y])
                .SelectMany(pixel => new byte[]
                {
                    (byte) MathUtils.LinearTosRgb(pixel.b), (byte) MathUtils.LinearTosRgb(pixel.g),
                    (byte) MathUtils.LinearTosRgb(pixel.r), 0
                })
                .ToArray();

            Bitmap bmp;

            fixed (byte* ptr = data)
            {
                bmp = new Bitmap(width, height, width * 4, PixelFormat.Format32bppRgb, new IntPtr(ptr));
            }

            return bmp;
        }
    }
}