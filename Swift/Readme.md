# BlurHash for iOS, in Swift

## Standalone decoder and encoder

[BlurHashDecode.swift](BlurHashDecode.swift) and [BlurHashEncode.swift](BlurHashEncode.swift) contain a decoder
and encoder for BlurHash to and from `UIImage`. Both files are completeiy standalone, and can simply be copied into your
project directly.

### Decoding

[BlurHashDecode.swift](BlurHashDecode.swift) implements the following extension on `UIImage`:

	public convenience init?(blurHash: String, size: CGSize, punch: Float = 1)

This creates a UIImage containing the placeholder image decoded from the BlurHash string, or returns nil if decoding failed.
The parameters are:

* `blurHash` - A string containing the BlurHash.
* `size` - The requested output size. You should keep this small, and let UIKit scale it up for you. 32 pixels wide is plenty.
* `punch` - Adjusts the contrast of the output image. Tweak it if you want a different look for your placeholders.

### Encoding

 [BlurHashEncode.swift](BlurHashEncode.swift) implements the following extension on `UIImage`:

	public func blurHash(numberOfComponents components: (Int, Int)) -> String?

This returns a string containing the BlurHash for the image, or nil if the image was in a weird format that is not supported.
The parameters are:

* `numberOfComponents` - a Tuple of integers specifying the number of components in the X and Y directions. Both must be
between 1 and 9 inclusive, or the function will return nil.  3 to 5 is usually a good range.

## BlurHashKit

This is a more advanced library, currently in development. It will let you do more advanced operations using BlurHashes,
such testing whether various parts of an image are dark and light, or generating BlurHashes as gradients from corner colours.

It is currently not documented or finalised, but feel free to look into the different files and what they implement, or look at
how it is used by the test app.

## BlurHashTest.app

This is a simple test app that shows how to use the various pieces of BlurHash functionality, and lets you play with the
algorithm.
