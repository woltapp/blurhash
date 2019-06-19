import { encode, decode } from '../../../TypeScript/dist/';

const blurhashElement = document.getElementById('demo-blurhash');
const blurhashOutput = document.getElementById('demo-blurhash-output');
const canvas = document.getElementById('demo-canvas');
const originalCanvas = document.getElementById('original-canvas');
const fileInput = document.getElementById('file-upload');
const componentXElement = document.getElementById('component-x');
const componentYElement = document.getElementById('component-y');

function render() {
  const blurhash = blurhashElement.value;
  blurhashOutput.textContent = blurhash;
  if (blurhash) {
    const pixels = decode(blurhash, 32, 32);
    if (pixels) {
      blurhashOutput.classList.remove('error');
      const ctx = canvas.getContext('2d');

      const imageData = new ImageData(pixels, 32, 32);
      ctx.putImageData(imageData, 0, 0);
    } else {
      blurhashOutput.classList.add('error');
    }
  }
}

function clamp(n) {
  return Math.min(9, Math.max(1, n));
}

function doEncode() {
  const file = fileInput.files[0];
  const componentX = clamp(+componentXElement.value);
  const componentY = clamp(+componentYElement.value);
  if (file) {
    const ctx = originalCanvas.getContext('2d');
    var img = new Image();
    img.onload = function() {
      ctx.drawImage(img, 0, 0, originalCanvas.width, originalCanvas.height);
      originalCanvas.style.opacity = 1;
      URL.revokeObjectURL(img.src);

      setTimeout(() => {
        const imageData = ctx.getImageData(0, 0, originalCanvas.width, originalCanvas.height);
        const blurhash = encode(
          imageData.data,
          imageData.width,
          imageData.height,
          componentX,
          componentY,
        );
        blurhashElement.value = blurhash;
        render();
      }, 0);
    };
    img.src = URL.createObjectURL(fileInput.files[0]);
  }
}

blurhashElement.addEventListener('change', render);
blurhashElement.addEventListener('keyup', render);
fileInput.addEventListener('change', doEncode);
componentXElement.addEventListener('keyup', doEncode);
componentYElement.addEventListener('keyup', doEncode);

export default function() {
  render();
}
