import UIKit
import BlurHash

class ViewController: UIViewController {
    @IBOutlet weak var originalImageView: UIImageView?
    @IBOutlet weak var hashLabel: UILabel?
    @IBOutlet weak var blurImageView: UIImageView?
    @IBOutlet weak var xComponentsLabel: UILabel?
    @IBOutlet weak var yComponentsLabel: UILabel?

    let images: [UIImage] = [
        UIImage(named: "pic6.png")!,
        UIImage(named: "pic2.png")!,
        UIImage(named: "pic1.png")!,
        UIImage(named: "pic3.png")!,
    ]

    var imageIndex: Int = 0
    var xComponents: Int = 4
    var yComponents: Int = 3
    var blurHash: String = ""
    var punch: Float = 1

    override func viewDidLoad() {
        super.viewDidLoad()

        updateEncode()
        updateDecode()
    }

    @IBAction func imageTapped() {
        imageIndex = (imageIndex + 1) % images.count
        updateEncode()
        updateDecode()
    }

    @IBAction func xPlusTapped() {
        if xComponents < 10 {
            xComponents += 1
            updateEncode()
            updateDecode()
        }
    }

    @IBAction func xMinusTapped() {
        if xComponents > 1 {
            xComponents -= 1
            updateEncode()
            updateDecode()
        }
    }

    @IBAction func yPlusTapped() {
        if yComponents < 5 {
            yComponents += 1
            updateEncode()
            updateDecode()
        }
    }

    @IBAction func yMinusTapped() {
        if yComponents > 1 {
            yComponents -= 1
            updateEncode()
            updateDecode()
        }
     }


    @IBAction func sliderChanged(slider: UISlider) {
        punch = slider.value
        updateDecode()
    }

    func updateEncode() {
        originalImageView?.image = images[imageIndex]
        blurHash = images[imageIndex].blurHash(components: (xComponents, yComponents))!
        hashLabel?.text = blurHash
        xComponentsLabel?.text = String(xComponents)
        yComponentsLabel?.text = String(yComponents)
    }

    func updateDecode() {
        guard let image = originalImageView?.image else { return }
        let blurImage = UIImage(blurHash: blurHash, size: CGSize(
        width: Int(ceil(32 * sqrt(image.size.width / image.size.height))),
        height: Int(ceil(32 * sqrt(image.size.height / image.size.width)))),
        punch: punch)

        blurImageView?.image = blurImage
    }
}

