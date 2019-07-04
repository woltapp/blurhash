using System.Drawing.Imaging;
using System.Linq;
using System.Threading.Tasks;
using Blurhash.Core;

namespace System.Drawing.Blurhash
{
    /// <summary>
    /// The Blurhash encoder for use with the <code>System.Drawing.Common</code> package
    /// </summary>
    public class Encoder : CoreEncoder 
    {
        /// <summary>
        /// Encodes a picture into a Blurhash string
        /// </summary>
        /// <param name="image">The picture to encode</param>
        /// <param name="componentsX">The number of components used on the X-Axis for the DCT</param>
        /// <param name="componentsY">The number of components used on the Y-Axis for the DCT</param>
        /// <returns>The resulting Blurhash string</returns>
        public string Encode(Image image, int componentsX, int componentsY)
        {
            return CoreEncode(ConvertBitmap(image as Bitmap ?? new Bitmap(image)), componentsX, componentsY);
        }

        /// <summary>
        /// Converts the given bitmap to the library-independent representation used within the Blurhash-core
        /// </summary>
        /// <param name="sourceBitmap">The bitmap to encode</param>
        public static Pixel[,] ConvertBitmap(Bitmap sourceBitmap)
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

                var result = new Pixel[width, height];

                Parallel.ForEach(Enumerable.Range(0, height), y =>
                {
                    var index = bmpData.Stride * y;

                    for (var x = 0; x < width; x++)
                    {
                        result[x, y].Red = MathUtils.SRgbToLinear(rgbValues[index + 2]);
                        result[x, y].Green = MathUtils.SRgbToLinear(rgbValues[index + 1]);
                        result[x, y].Blue = MathUtils.SRgbToLinear(rgbValues[index]);
                        index += 3;
                    }
                });

                temporaryBitmap.UnlockBits(bmpData);

                return result;
            }
        }
    }
}
