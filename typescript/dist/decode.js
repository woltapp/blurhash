"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var base64_1 = require("./base64");
var utils_1 = require("./utils");
var decodeDC = function (value) {
    var intR = value >> 16;
    var intG = (value >> 8) & 255;
    var intB = value & 255;
    return [utils_1.sRGBToLinear(intR), utils_1.sRGBToLinear(intG), utils_1.sRGBToLinear(intB)];
};
var decodeAC = function (value, maximumValue) {
    var quantR = value >> 8;
    var quantG = (value >> 4) & 15;
    var quantB = value & 15;
    var rgb = [
        utils_1.signPow((quantR - 8) / 8, 3.0) * maximumValue * 2,
        utils_1.signPow((quantG - 8) / 8, 3.0) * maximumValue * 2,
        utils_1.signPow((quantB - 8) / 8, 3.0) * maximumValue * 2,
    ];
    return rgb;
};
var decode = function (blurhash, width, height, punch) {
    punch = punch | 1;
    if (blurhash.length < 6) {
        console.error('too short blurhash');
        return null;
    }
    var sizeFlag = base64_1.decode64(blurhash[0]);
    var numY = (sizeFlag >> 3) + 1;
    var numX = (sizeFlag & 7) + 1;
    var quantisedMaximumValue = base64_1.decode64(blurhash[1]);
    var maximumValue = (quantisedMaximumValue + 1) / 128;
    if (blurhash.length !== 4 + 2 * numX * numY) {
        console.error('blurhash length mismatch', blurhash.length, 4 + 2 * numX * numY);
        return null;
    }
    var colors = new Array(numX * numY);
    for (var i = 0; i < colors.length; i++) {
        if (i === 0) {
            var value = base64_1.decode64(blurhash.substring(2, 6));
            colors[i] = decodeDC(value);
        }
        else {
            var value = base64_1.decode64(blurhash.substring(4 + i * 2, 6 + i * 2));
            colors[i] = decodeAC(value, maximumValue * punch);
        }
    }
    var bytesPerRow = width * 4;
    var pixels = new Uint8ClampedArray(bytesPerRow * height);
    for (var y = 0; y < height; y++) {
        for (var x = 0; x < width; x++) {
            var r = 0;
            var g = 0;
            var b = 0;
            for (var j = 0; j < numY; j++) {
                for (var i = 0; i < numX; i++) {
                    var basis = Math.cos(Math.PI * x * i / width) * Math.cos(Math.PI * y * j / height);
                    var color = colors[i + j * numX];
                    r += color[0] * basis;
                    g += color[1] * basis;
                    b += color[2] * basis;
                }
            }
            var intR = utils_1.linearTosRGB(r);
            var intG = utils_1.linearTosRGB(g);
            var intB = utils_1.linearTosRGB(b);
            pixels[4 * x + 0 + y * bytesPerRow] = intR;
            pixels[4 * x + 1 + y * bytesPerRow] = intG;
            pixels[4 * x + 2 + y * bytesPerRow] = intB;
            pixels[4 * x + 3 + y * bytesPerRow] = 255; // alpha
        }
    }
    return pixels;
};
exports.default = decode;
//# sourceMappingURL=decode.js.map