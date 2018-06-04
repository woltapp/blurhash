import decode from "./decode";
import encode from "./encode";

const blurhashElement = document.getElementById("blurhash") as HTMLInputElement;
const canvas = document.getElementById("canvas") as HTMLCanvasElement;
const originalCanvas = document.getElementById("original") as HTMLCanvasElement;
const fileInput = document.getElementById("fileinput") as HTMLInputElement;
const componentXElement = document.getElementById("x") as HTMLInputElement;
const componentYElement = document.getElementById("y") as HTMLInputElement;

function render() {
  const blurhash = blurhashElement.value;
  if (blurhash) {
    const pixels = decode(blurhash, 32, 32);
    if (pixels) {
      const ctx = canvas.getContext("2d");

      const imageData = new ImageData(pixels, 32, 32);
      ctx.putImageData(imageData, 0, 0);
    }
  }
}

function clamp(n: number) {
  return Math.min(9, Math.max(1, n));
}

function doEncode() {
  const file = fileInput.files[0];
  const componentX = clamp(+componentXElement.value);
  const componentY = clamp(+componentYElement.value);
  if (file) {
    const ctx = originalCanvas.getContext("2d");
    var img = new Image();
    img.onload = function() {
      ctx.drawImage(img, 0, 0, originalCanvas.width, originalCanvas.height);
      URL.revokeObjectURL(img.src);

      setTimeout(() => {
        const imageData = ctx.getImageData(
          0,
          0,
          originalCanvas.width,
          originalCanvas.height
        );
        const blurhash = encode(
          imageData.data,
          imageData.width,
          imageData.height,
          componentX,
          componentY
        );
        blurhashElement.value = blurhash;
        render();
      }, 0);
    };
    img.src = URL.createObjectURL(fileInput.files[0]);
  }
}

blurhashElement.addEventListener("keyup", render);
fileInput.addEventListener("change", doEncode);
componentXElement.addEventListener("change", doEncode);
componentYElement.addEventListener("change", doEncode);

render();
