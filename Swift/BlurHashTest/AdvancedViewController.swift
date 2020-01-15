import UIKit
import BlurHashKit

class AdvancedViewController: UIViewController {
    @IBOutlet weak var originalImageView: UIImageView?
    @IBOutlet weak var uncompressedBlurImageView: UIImageView?
    @IBOutlet weak var hashLabel: UILabel?
    @IBOutlet weak var compressedBlurImageView: UIImageView?

    @IBOutlet weak var darknessBlurImageView: UIImageView?
    @IBOutlet weak var topLeftCornerLabel: UILabel?
    @IBOutlet weak var topEdgeLabel: UILabel?
    @IBOutlet weak var topRightCornerLabel: UILabel?
    @IBOutlet weak var leftEdgeLabel: UILabel?
    @IBOutlet weak var centreLabel: UILabel?
    @IBOutlet weak var rightEdgeLabel: UILabel?
    @IBOutlet weak var bottomLeftCornerLabel: UILabel?
    @IBOutlet weak var bottomEdgeLabel: UILabel?
    @IBOutlet weak var bottomRightCornerLabel: UILabel?

    @IBOutlet weak var xComponentsLabel: UILabel?
    @IBOutlet weak var yComponentsLabel: UILabel?

    let images: [UIImage] = [
        UIImage(named: "pic2.png")!,
        UIImage(named: "pic1.png")!,
        UIImage(named: "pic3.png")!,
        UIImage(named: "pic6.png")!,
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
        if xComponents < 9 {
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
        if yComponents < 9 {
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
		uncompressedBlurImageView?.image = blurHash.image(numberOfPixels: 1024, originalSize: image.size)

        hashLabel?.text = blurHash.string
        let decodedBlurHash = BlurHash(string: blurHash.string)!

        compressedBlurImageView?.image = decodedBlurHash.image(numberOfPixels: 1024, originalSize: image.size)
        darknessBlurImageView?.image = decodedBlurHash.image(numberOfPixels: 1024, originalSize: image.size)

        setDarkness(label: topLeftCornerLabel, isDark: decodedBlurHash.isTopLeftCornerDark, light: "Ⓛ", dark: "Ⓓ")
        setDarkness(label: topEdgeLabel, isDark: decodedBlurHash.isTopEdgeDark, light: "------Light------", dark: "------Dark------")
        setDarkness(label: topRightCornerLabel, isDark: decodedBlurHash.isTopRightCornerDark, light: "Ⓛ", dark: "Ⓓ")
        setDarkness(label: leftEdgeLabel, isDark: decodedBlurHash.isLeftEdgeDark, light: "|\n|\nLight\n|\n|", dark: "|\n|\nDark\n|\n|")
        setDarkness(label: centreLabel, isDark: decodedBlurHash.isDark(), light: "Light", dark: "Dark")
        setDarkness(label: rightEdgeLabel, isDark: decodedBlurHash.isRightEdgeDark, light: "|\n|\nLight\n|\n|", dark: "|\n|\nDark\n|\n|")
        setDarkness(label: bottomLeftCornerLabel, isDark: decodedBlurHash.isBottomLeftCornerDark, light: "Ⓛ", dark: "Ⓓ")
        setDarkness(label: bottomEdgeLabel, isDark: decodedBlurHash.isBottomEdgeDark, light: "------Light------", dark: "------Dark------")
        setDarkness(label: bottomRightCornerLabel, isDark: decodedBlurHash.isBottomRightCornerDark, light: "Ⓛ", dark: "Ⓓ")

        xComponentsLabel?.text = String(xComponents)
        yComponentsLabel?.text = String(yComponents)

    }

    func setDarkness(label: UILabel?, isDark: Bool, light: String, dark: String) {
        if isDark {
            label?.textColor = .white
            label?.text = dark
        } else {
            label?.textColor = .black
            label?.text = light
        }
    }

}

