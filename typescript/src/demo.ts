import decode from './decode';

function render() {
    const blurhash = (document.getElementById('blurhash') as HTMLInputElement).value;
    const pixels = decode(blurhash, 32, 32);
    if(pixels) {
        const canvas = document.getElementById("canvas") as HTMLCanvasElement;
        const ctx = canvas.getContext('2d');
        
        const imageData = new ImageData(pixels, 32, 32);
        ctx.putImageData(imageData, 0, 0);
    }
}

document.getElementById('blurhash').addEventListener('keyup', render);
render();