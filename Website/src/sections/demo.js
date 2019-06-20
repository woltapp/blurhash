import { encode, decode } from '../../../TypeScript/dist/';

const blurhashElement = document.getElementById('demo-blurhash');
const blurhashOutput = document.getElementById('demo-blurhash-output');
const canvas = document.getElementById('demo-canvas');
const originalCanvas = document.getElementById('original-canvas');
const fileInput = document.getElementById('file-upload');
const componentXElement = document.getElementById('component-x');
const componentYElement = document.getElementById('component-y');
const predefined = document.querySelector('.predefined');

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
  return isNaN(n) ? 1 : Math.min(9, Math.max(1, n));
}

function renderSelectedFile() {
  const file = fileInput.files[0];
  if (file) {
    var img = new Image();
    originalCanvas.classList.add('visible');
    img.onload = function() {
      renderImage(img);
    };
    img.src = URL.createObjectURL(fileInput.files[0]);
  }
}

function renderImage(img) {
  const ctx = originalCanvas.getContext('2d');

  ctx.drawImage(img, 0, 0, originalCanvas.width, originalCanvas.height);
  URL.revokeObjectURL(img.src);

  setTimeout(renderBlurhash, 0);
}

function renderBlurhash() {
  const ctx = originalCanvas.getContext('2d');
  const componentX = clamp(+componentXElement.value);
  const componentY = clamp(+componentYElement.value);

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
}

function renderSelectedImage() {
  console.log('renderSelectedImage');
  const firstPredefinedImage = document.querySelector('.predefined input:checked + img');
  originalCanvas.classList.remove('visible');
  fileInput.value = '';
  renderImage(firstPredefinedImage);
}

blurhashElement.addEventListener('change', render);
blurhashElement.addEventListener('keyup', render);
fileInput.addEventListener('change', renderSelectedFile);
componentXElement.addEventListener('keyup', renderBlurhash);
componentYElement.addEventListener('keyup', renderBlurhash);
predefined.addEventListener('change', renderSelectedImage);
originalCanvas.addEventListener('click', renderSelectedImage);

export default function() {
  renderSelectedImage();
}
