using System.Drawing.Imaging;
using FluentAssertions;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace System.Drawing.Blurhash.DotNetFramework.Test
{
    [TestClass]
    public class ImageConversionTest
    {
        [TestMethod]
        public void TestConversion24BppRgb()
        {
            var rnd = new Random();

            var sourceImage = new Bitmap(20, 20, PixelFormat.Format24bppRgb);

            for (var x = 0; x < 20; x++)
                for (var y = 0; y < 20; y++)
                {
                    sourceImage.SetPixel(x, y, Color.FromArgb(rnd.Next(0, 1) * 255, rnd.Next(0, 1) * 255, rnd.Next(0, 1) * 255));
                }

            var sourceData = Encoder.ConvertBitmap(sourceImage);

            for (var x = 0; x < 20; x++)
            for (var y = 0; y < 20; y++)
            {
                var pixel = sourceImage.GetPixel(x, y);

                sourceData[x, y].Red.Should().BeApproximately(pixel.R == 0 ? 0.0 : 1.0, double.Epsilon);
                sourceData[x, y].Green.Should().BeApproximately(pixel.G == 0 ? 0.0 : 1.0, double.Epsilon);
                sourceData[x, y].Blue.Should().BeApproximately(pixel.B == 0 ? 0.0 : 1.0, double.Epsilon);
            }

            var targetImage = Decoder.ConvertToBitmap(sourceData);

            for (var x = 0; x < 20; x++)
            for (var y = 0; y < 20; y++)
            {
                targetImage.GetPixel(x, y).Should().Be(sourceImage.GetPixel(x, y));
            }
        }

        [TestMethod]
        public void TestConversion32BppRgb()
        {
            var rnd = new Random();

            var sourceImage = new Bitmap(20, 20, PixelFormat.Format32bppRgb);

            for (var x = 0; x < 20; x++)
            for (var y = 0; y < 20; y++)
            {
                sourceImage.SetPixel(x, y, Color.FromArgb(rnd.Next(0, 1) * 255, rnd.Next(0, 1) * 255, rnd.Next(0, 1) * 255));
            }

            var sourceData = Encoder.ConvertBitmap(sourceImage);

            for (var x = 0; x < 20; x++)
            for (var y = 0; y < 20; y++)
            {
                var pixel = sourceImage.GetPixel(x, y);

                sourceData[x, y].Red.Should().BeApproximately(pixel.R == 0 ? 0.0 : 1.0, double.Epsilon);
                sourceData[x, y].Green.Should().BeApproximately(pixel.G == 0 ? 0.0 : 1.0, double.Epsilon);
                sourceData[x, y].Blue.Should().BeApproximately(pixel.B == 0 ? 0.0 : 1.0, double.Epsilon);
            }

            var targetImage = Decoder.ConvertToBitmap(sourceData);

            for (var x = 0; x < 20; x++)
            for (var y = 0; y < 20; y++)
            {
                targetImage.GetPixel(x, y).Should().Be(sourceImage.GetPixel(x, y));
            }
        }

    }
}
