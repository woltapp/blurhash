import UIKit
import BlurHash

var image = UIImage(named: "pic2.png")!

var hash = image.blurHash(components: (4, 3))!

var blurImage1 = UIImage(blurHash: hash, size: image.size, punch: 0.5)
var blurImage2 = UIImage(blurHash: hash, size: image.size, punch: 1)
var blurImage3 = UIImage(blurHash: hash, size: image.size, punch: 1.25)
var blurImage4 = UIImage(blurHash: hash, size: image.size, punch: 1.5)

