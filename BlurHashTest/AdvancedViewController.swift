import UIKit
import BlurHashKit

class AdvancedViewController: UIViewController {
    @IBOutlet weak var originalImageView: UIImageView?
    @IBOutlet weak var uncompressedBlurImageView: UIImageView?
    @IBOutlet weak var hashLabel: UILabel?
    @IBOutlet weak var compressedBlurImageView: UIImageView?
    @IBOutlet weak var xComponentsLabel: UILabel?
    @IBOutlet weak var yComponentsLabel: UILabel?

    let images: [UIImage] = [
        UIImage(named: "pic2.png")!,
        UIImage(named: "pic1.png")!,
        UIImage(named: "pic3.png")!,
        UIImage(named: "pic4.png")!,
        UIImage(named: "pic5.png")!,
    ]

    var imageIndex: Int = 0
    var xComponents: Int = 4
    var yComponents: Int = 3

    override func viewDidLoad() {
        super.viewDidLoad()

        update()
    }

    @IBAction func imageTapped() {
        imageIndex = (imageIndex + 1) % images.count
        update()
    }

    @IBAction func xPlusTapped() {
        if xComponents < 8 {
            xComponents += 1
            update()
        }
    }

    @IBAction func xMinusTapped() {
        if xComponents > 1 {
            xComponents -= 1
            update()
        }
    }

    @IBAction func yPlusTapped() {
        if yComponents < 8 {
            yComponents += 1
            update()
        }
    }

    @IBAction func yMinusTapped() {
        if yComponents > 1 {
            yComponents -= 1
            update()
        }
     }


    func update() {
    	let image = images[imageIndex]

        originalImageView?.image = image

        let blurHash = BlurHash(image: images[imageIndex], numberOfComponents: (xComponents, yComponents))!
		uncompressedBlurImageView?.image = blurHash.punch(2).image(numberOfPixels: 1024, originalSize: image.size)

        hashLabel?.text = blurHash.string
        let decodedBlurHash = BlurHash(string: blurHash.string)!

        compressedBlurImageView?.image = decodedBlurHash.image(numberOfPixels: 1024, originalSize: image.size)

        xComponentsLabel?.text = String(xComponents)
        yComponentsLabel?.text = String(yComponents)

    }

}

