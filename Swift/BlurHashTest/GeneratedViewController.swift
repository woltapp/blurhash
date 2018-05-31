import UIKit
import BlurHashKit

class GeneratedViewController: UIViewController {
    @IBOutlet weak var horizontalUncompressedImageView: UIImageView?
    @IBOutlet weak var horizontalCompressedImageView: UIImageView?
    @IBOutlet weak var horizontalLeftView: UIView?
    @IBOutlet weak var horizontalRightView: UIView?
    @IBOutlet weak var horizontalHashLabel: UILabel?

    @IBOutlet weak var verticalUncompressedImageView: UIImageView?
    @IBOutlet weak var verticalCompressedImageView: UIImageView?
    @IBOutlet weak var verticalTopView: UIView?
    @IBOutlet weak var verticalBottomView: UIView?
    @IBOutlet weak var verticalHashLabel: UILabel?

    @IBOutlet weak var cornerUncompressedImageView: UIImageView?
    @IBOutlet weak var cornerCompressedImageView: UIImageView?
    @IBOutlet weak var cornerTopLeftView: UIView?
    @IBOutlet weak var cornerTopRightView: UIView?
    @IBOutlet weak var cornerBottomLeftView: UIView?
    @IBOutlet weak var cornerBottomRightView: UIView?
    @IBOutlet weak var cornerHashLabel: UILabel?

/*	private var horizontalLeftColour = UIColor.red
	private var horizontalRightColour = UIColor.green
	private var verticalTopColour = UIColor.white
	private var verticalBottomColour = UIColor.black
	private var cornerTopLeftColour = UIColor.white
	private var cornerTopRightColour = UIColor.red
	private var cornerBottomLeftColour = UIColor.green
	private var cornerBottomRightColour = UIColor.black
*/
	private var horizontalLeftColour = UIColor.white
	private var horizontalRightColour = UIColor.black
	private var verticalTopColour = UIColor.white
	private var verticalBottomColour = UIColor.black
	private var cornerTopLeftColour = UIColor.white
	private var cornerTopRightColour = UIColor.black
	private var cornerBottomLeftColour = UIColor.black
	private var cornerBottomRightColour = UIColor.white

    override func viewDidLoad() {
        super.viewDidLoad()

		horizontalLeftView?.layer.borderWidth = 1
		horizontalLeftView?.layer.borderColor = UIColor.black.cgColor
		horizontalRightView?.layer.borderWidth = 1
		horizontalRightView?.layer.borderColor = UIColor.black.cgColor

		verticalTopView?.layer.borderWidth = 1
		verticalTopView?.layer.borderColor = UIColor.black.cgColor
		verticalBottomView?.layer.borderWidth = 1
		verticalBottomView?.layer.borderColor = UIColor.black.cgColor

		cornerTopLeftView?.layer.borderWidth = 1
		cornerTopLeftView?.layer.borderColor = UIColor.black.cgColor
		cornerTopRightView?.layer.borderWidth = 1
		cornerTopRightView?.layer.borderColor = UIColor.black.cgColor
		cornerBottomLeftView?.layer.borderWidth = 1
		cornerBottomLeftView?.layer.borderColor = UIColor.black.cgColor
		cornerBottomRightView?.layer.borderWidth = 1
		cornerBottomRightView?.layer.borderColor = UIColor.black.cgColor

        update()
    }

    @IBAction func randomiseTapped() {
		horizontalLeftColour = .random()
		horizontalRightColour = .random()
		verticalTopColour = .random()
		verticalBottomColour = .random()
		cornerTopLeftColour = .random()
		cornerTopRightColour = .random()
		cornerBottomLeftColour = .random()
		cornerBottomRightColour = .random()

        update()
    }


    func update() {
		horizontalLeftView?.backgroundColor = horizontalLeftColour
		horizontalRightView?.backgroundColor = horizontalRightColour

		verticalTopView?.backgroundColor = verticalTopColour
		verticalBottomView?.backgroundColor = verticalBottomColour

		cornerTopLeftView?.backgroundColor = cornerTopLeftColour
		cornerTopRightView?.backgroundColor = cornerTopRightColour
		cornerBottomLeftView?.backgroundColor = cornerBottomLeftColour
		cornerBottomRightView?.backgroundColor = cornerBottomRightColour

		let horizontalBlurHash = BlurHash(horizontalGradientFrom: horizontalLeftColour, to: horizontalRightColour)
		horizontalUncompressedImageView?.image = horizontalBlurHash.image(size: CGSize(width: 32, height: 32))
		horizontalCompressedImageView?.image = BlurHash(string: horizontalBlurHash.string)?.image(size: CGSize(width: 32, height: 32))
		horizontalHashLabel?.text = horizontalBlurHash.string

		let verticalBlurHash = BlurHash(verticalGradientFrom: verticalTopColour, to: verticalBottomColour)
		verticalUncompressedImageView?.image = verticalBlurHash.image(size: CGSize(width: 32, height: 32))
		verticalCompressedImageView?.image = BlurHash(string: verticalBlurHash.string)?.image(size: CGSize(width: 32, height: 32))
		verticalHashLabel?.text = verticalBlurHash.string

		let cornerBlurHash = BlurHash(blendingTopLeft: cornerTopLeftColour, topRight: cornerTopRightColour, bottomLeft: cornerBottomLeftColour, bottomRight: cornerBottomRightColour)
		cornerUncompressedImageView?.image = cornerBlurHash.image(size: CGSize(width: 32, height: 32))
		cornerCompressedImageView?.image = BlurHash(string: cornerBlurHash.string)?.image(size: CGSize(width: 32, height: 32))
		cornerHashLabel?.text = cornerBlurHash.string
	}
}

extension UIColor {
	static func random() -> UIColor {
		let hue = CGFloat(arc4random()) / CGFloat(UInt32.max)
		let brightness = CGFloat(arc4random()) / CGFloat(UInt32.max)
		if brightness < 0.5 {
			return UIColor(hue: hue, saturation: 1, brightness: brightness * 2, alpha: 1)
		} else {
			return UIColor(hue: hue, saturation: 2 - brightness * 2, brightness: 1, alpha: 1)
		}
	}
}

