import './index.scss';
import { imageHashes } from './constants';
import decode from '../../TypeScript/dist/decode';
import Velocity from 'velocity-animate';

// document.addEventListener('readystatechange', drawBlurHash);
const images = document.getElementsByClassName('image-bg');
const imageContainer = document.getElementsByClassName('imagesContainer');
const content = document.getElementsByClassName('content');

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
drawBlurHash();
function drawBlurHash() {
  if (!document.readyState === 'complete') {
    return;
  }
  init();
  const canvases = document.getElementsByClassName('image-canvas-bg');

  if (canvases && canvases.length) {
    for (let i = 0; i < canvases.length; i++) {
      render(canvases[i], imageHashes[i]);
    }
  }
  startAnimation();
}

function init() {
  Velocity({
    elements: imageContainer,
    properties: { translateY: '25%' },
    options: {
      duration: 0,
    },
  });
  Velocity({
    elements: content,
    properties: { opacity: 0 },
    options: {
      duration: 0,
    },
  });
}

function startAnimation() {
  for (let i = 0; i < images.length; i++) {
    images[i].classList.add('animateImages');
  }
  Velocity({
    elements: imageContainer,
    properties: { translateY: '0%' },
    options: {
      duration: 750,
      delay: 500,
      easing: 'easeInOutCubic',
    },
  });
  Velocity({
    elements: content,
    properties: { opacity: 1 },
    options: {
      duration: 250,
      delay: 1000,
    },
  });
}
