# BlurHash Algorithm

## Summary

BlurHash applies a simple DCT transform to the image data, keeping only the first few components, and then encodes
these components using a base 83 encoding, with a JSON, HTML and shell-safe character set. The DC component,
which represents the average colour of the image, is stored exactly as an sRGB value, for easy use without impleneting
the full algorithm. The AC components are encoded lossily.

## Reference implementation

[Simplified Swift decoder implemenation.](../Swift/BlurHashDecode.swift)

[Simplified Swift encoder implemenation.](../Swift/BlurHashEncode.swift)

## Structure

Here follows an example of a BlurHash string, with the different parts labelled:

    Example: LNMF%n00%#MwS|WCWEM{R*bbWBbH
    Legend:  12333344....................

1. **Number of components, 1 digit.**
   
   For a BlurHash with `nx` components along the X axis and `ny` components along the Y axis, this is equal to `(nx - 1) + (ny - 1) * 9`.

2. **Maximum AC component value, 1 digit.**
   
   All AC components are scaled by this value. It represents a floating-point value of `(max + 1) / 83`.

3. **Average colour. 4 digits.**
   
   The average colour of the image in sRGB space, encoded as a 24-bit RGB value, with R in the most signficant position. This value can
   be used directly if you only want the average colour rather than the full DCT-encoded image.

4. **AC components, 2 digits each, `nx * ny - 1` components in total.**
   
   The AC components of the DCT transform, ordred by increasing X first, then Y. These values range from 0 to 6859. See below for a
   more detailed description.

## Base 83

A custom base 83 encoding is used. Values are encoded individually, using 1 to 4 digits, and concatenated together. Multiple-digit
values are encoded in big-endian order, with the most signficant digit first.

The character used set is `0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz#$%*+,-.:;=?@[]^_{|}~`.

## DCT

To be written.

AC components are encoded as values between 0 and 18, and then combined together as `R * 19^2 + G * 19 + B`.
