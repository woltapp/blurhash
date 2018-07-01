import './index.scss';
import { imageHashes } from './constants';
import decode from '../../TypeScript/dist/decode';

document.addEventListener('readystatechange', drawBlurHash);

function render(canvas, blurhash) {
  if (blurhash) {
    const pixels = decode(blurhash, 32, 32);
    if (pixels) {
      const ctx = canvas.getContext('2d');

      const imageData = new ImageData(pixels, 32, 32);
      ctx.putImageData(imageData, 0, 0);
    }
  }
}

function drawBlurHash() {
  if (!document.readyState === 'complete') {
    return;
  }

  const canvases = document.getElementsByClassName('image-canvas-bg');

  if (canvases && canvases.length) {
    for (let i = 0; i < canvases.length; i++) {
      render(canvases[i], imageHashes[i]);
    }
  }
}
