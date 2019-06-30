using System.Drawing.Imaging;
using System.Linq;
using System.Threading.Tasks;
using Blurhash.Core;

namespace System.Drawing.Blurhash
{
    public class Encoder : CoreEncoder 
    {
        public string Encode(Image image, int componentsX, int componentsY)
        {
            var bmp = image as Bitmap ?? new Bitmap(image);
            (double r, double g, double b)[,] convertedBitmap;

            convertedBitmap = ConvertBitmap(bmp);

            return CoreEncode(convertedBitmap, componentsX, componentsY);
        }

        public static (double r, double g, double b)[,] ConvertBitmap(Bitmap sourceBitmap)
        {
            var width = sourceBitmap.Width;
            var height = sourceBitmap.Height;

            using (var temporaryBitmap = new Bitmap(width, height, PixelFormat.Format24bppRgb))
            {
                using (var graphics = Graphics.FromImage(temporaryBitmap))
                {
                    graphics.DrawImageUnscaled(sourceBitmap, 0, 0);
                }

                // Lock the bitmap's bits.  
                var bmpData = temporaryBitmap.LockBits(new Rectangle(0, 0, width, height), ImageLockMode.ReadOnly, temporaryBitmap.PixelFormat);

                // Get the address of the first line.
                var ptr = bmpData.Scan0;

                // Declare an array to hold the bytes of the bitmap.
                var bytes  = Math.Abs(bmpData.Stride) * height;
                var rgbValues = new byte[bytes];

                // Copy the RGB values into the array.
                Runtime.InteropServices.Marshal.Copy(ptr, rgbValues, 0, bytes);

                var result = new (double r, double g, double b)[width, height];

                Parallel.ForEach(Enumerable.Range(0, height), y =>
                {
                    var index = bmpData.Stride * y;

                    for (var x = 0; x < width; x++)
                    {
                        result[x, y].r = MathUtils.SRgbToLinear(rgbValues[index + 2]);
                        result[x, y].g = MathUtils.SRgbToLinear(rgbValues[index + 1]);
                        result[x, y].b = MathUtils.SRgbToLinear(rgbValues[index]);
                        index += 3;
                    }
                });

                temporaryBitmap.UnlockBits(bmpData);

                return result;
            }
        }
    }
}
