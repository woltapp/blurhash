# Usage

## Using a supported image manipulation library

1) Install the NuGet-Package for your image manipulation library
   - Install `Blurhash-System.Drawing` if you're using the `System.Drawing.dll` that ships with the .NET-Framework
   - Install `Blurhash-System.Drawing.Common` if you're using the `System.Drawing.Common`-NuGet package.
     This package offers the same interface as `System.Drawing.dll` but for DotNetStandard 2.0 and cross-platform usage.

1) Instantiate an `Encoder` or `Decoder` \
   The `Encoder`-class will generate a Blurhash-string out of your image while the `Decoder`-class will decode the Blurhash-string to a blurred preview-image.

1) Optionally set a progress-callback. \
   If you're handling large files (which is not recommended) and want to provide user-feedback (that is, you're not on a server), you can set the `ProgressCallback`-Property.
   Your callback will be called with a value in the interval `[0.0, 1.0]` depending on encoding or decoding process.

1) Start the operation
   - Call `Encode` and pass the image as well as the number of components for each axis to start encoding.
   - Call `Decode` and pass the Blurhash-string as well as the desired output size to start decoding.

## Using an unsupported image manipulation library
Install the NuGet-Package `Blurhash.Core`

### Encoding an image to a Blurhash string

1) Convert all pixels of your image into a 2-dimensional array of `Pixel`-entries (those represent each pixel by three `double`s for each color channel) \
   Note that the first dimension is the X-Coordinate while the second dimension is the Y-Coordinate. \
   In order to convert an integer value in the interval `[0..255]` to its double representation you can use `MathUtils.SRgbToLinear`.
1) Instantiate a `CoreEncoder`
1) Optionally set a progress-callback
1) Start the operation by calling `CoreEncode` with the array and the number of components for each axis

### Decoding a Blurhash string into an image

1) Instantiate a `CoreDecoder`
1) Optionally set a progress-callback
1) Start the operation by calling `CoreDecode` with the desired output size.
1) You receive a 2-dimensional array of `Pixel`-entries which you need to decode into your image representation. \
   Note that the first dimension is the X-Coordinate while the second dimension is the Y-Coordinate. \
   In order to convert a double to an integer value in the interval `[0..255]` you can use `MathUtils.LinearToSRgb`.

### Sharing your library specific implementation

Think about sharing your implementation, so others can use it too. \
Calling it `Blurhash.<Name of your image manipulation library>` would help others to quickly find it on NuGet.org.

# Projects in this solution
This list does not contain the projects with names ending in `.Test` as they are the test projects for the ones listed here.

- Blurhash.Core
  The core algorithm of blurhash. For maximum compatibility this is a .NET-Standard project.
- Blurhash-System.Drawing.Blurhash
  Bridge-Library to use Blurhash with the `System.Drawing.dll` namespace of the .NET-Framework.
  This is only available in Windows projects as it uses GDI+
- Blurhash-System.Drawing.Common
  Bridge-Library to use Blurhash with the System.Drawing.Common NuGet-Library in DotNetStandard
