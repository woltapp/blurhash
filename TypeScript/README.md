# blurhash

[![NPM Version](https://img.shields.io/npm/v/blurhash.svg?style=flat)](https://npmjs.org/package/blurhash)
[![NPM Downloads](https://img.shields.io/npm/dm/blurhash.svg?style=flat)](https://npmjs.org/package/blurhash)

> JavaScript encoder and decoder for the [Wolt BlurHash](https://github.com/woltapp/blurhash) algorithm

## Install

```sh
npm install --save blurhash
```

See [react-blurhash](https://github.com/woltapp/react-blurhash) to use blurhash with React.

## API

### `decode(blurhash: string, width: number, height: number, punch?: number) => Uint8ClampedArray`

> Decodes a blurhash string to pixels

#### Example

```js
import { decode } from "blurhash";

const pixels = decode("LEHV6nWB2yk8pyo0adR*.7kCMdnj", 32, 32);

const canvas = document.createElement("canvas");
const ctx = canvas.getContext("2d");
const imageData = ctx.createImageData(width, height);
imageData.data.set(pixels);
ctx.putImageData(imageData, 0, 0);
document.body.append(canvas);
```

### `encode(pixels: Uint8ClampedArray, width: number, height: number, componentX: number, componentY: number) => string`

> Encodes pixels to a blurhash string

```js
import { encode } from "blurhash";

const loadImage = async src =>
  new Promise((resolve, reject) => {
    const img = new Image();
    img.onload = () => resolve(img);
    img.onerror = (...args) => reject(args);
    img.src = src;
  });

const getImageData = image => {
  const canvas = document.createElement("canvas");
  canvas.width = image.width;
  canvas.height = image.height;
  const context = canvas.getContext("2d");
  context.drawImage(image, 0, 0);
  return context.getImageData(0, 0, image.width, image.height);
};

const encodeImageToBlurhash = async imageUrl => {
  const image = await loadImage(imageUrl);
  const imageData = getImageData(image);
  return encode(imageData.data, imageData.width, imageData.height, 4, 4);
};
```

### `isBlurhashValid(blurhash: string) => { result: boolean; errorReason?: string }`

```js
import { isBlurhashValid } from "blurhash";

const validRes = isBlurhashValid("LEHV6nWB2yk8pyo0adR*.7kCMdnj");
// { result: true }

const invalidRes = isBlurhashValid("???");
// { result: false, errorReason: "The blurhash string must be at least 6 characters" }
```
