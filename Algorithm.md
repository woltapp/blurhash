# BlurHash Algorithm

## Summary

BlurHash applies a simple [DCT transform](https://en.wikipedia.org/wiki/Discrete_cosine_transform) to the image data,
keeping only the first few components, and then encodes these components using a base 83 encoding, with a JSON,
HTML and shell-safe character set. The DC component, which represents the average colour of the image, is stored exactly
as an sRGB value, for easy use without impleneting the full algorithm. The AC components are encoded lossily.

## Reference implementation

[Simplified Swift decoder implementation.](Swift/BlurHashDecode.swift)

[Simplified Swift encoder implementation.](Swift/BlurHashEncode.swift)

## Structure

Here follows an example of a BlurHash string, with the different parts labelled:

    Example: LlMF%n00%#MwS|WCWEM{R*bbWBbH
    Legend:  12333344....................

1. **Number of components, 1 digit.**
   
   For a BlurHash with `nx` components along the X axis and `ny` components along the Y axis, this is equal to `(nx - 1) + (ny - 1) * 9`.

2. **Maximum AC component value, 1 digit.**
   
   All AC components are scaled by this value. It represents a floating-point value of `(max + 1) / 166`.

3. **Average colour. 4 digits.**
   
   The average colour of the image in sRGB space, encoded as a 24-bit RGB value, with R in the most signficant position. This value can
   be used directly if you only want the average colour rather than the full DCT-encoded image.

4. **AC components, 2 digits each, `nx * ny - 1` components in total.**
   
   The AC components of the DCT transform, ordred by increasing X first, then Y. They  are encoded as three values for `R`, `G` and `B`,
   each between 0 and 18. They are combined together as `R * 19^2 + G * 19 + B`, for a total range of 0 to 6859.
   
   Each value represents a floating-point value between -1 and 1. 0-8 represent negative values, 9 represents zero, and 10-18
   represent positive values. Positive values are encoded as `((X - 9) / 9) ^ 2`, while negative
   values are encoded as `-((9 - X) / 9 ) ^ 2`. `^` represents exponentiation. This value is then multiplied by the maximum AC
   component value, field 2 above.

## Base 83

A custom base 83 encoding is used. Values are encoded individually, using 1 to 4 digits, and concatenated together. Multiple-digit
values are encoded in big-endian order, with the most signficant digit first.

The character used set is `0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~`.

## Discrete Cosine Transform

To decode a single pixel of output, you loop over the DCT components and calculate a weighted sum of cosine functions. In
pseudocode, for a normalised pixel position `x`, `y`, with each coordinate ranging from 0 to 1, and components `Cij` ,
you calculate the following for each of R, G and B:

    foreach j in 0 ... ny - 1
        foreach i in 0 ... nx - 1
            value = value + Cij * cos(x * i * pi) * cos(y * j * pi)

The `C00` component is the DC component, while the others are the AC components. The DC component must first be converted
from sRGB to linear RGB space. AC components are already linear.

Once the R, G and B values have been calculated, the must be converted from linear to your output colourspace, usually sRGB.
