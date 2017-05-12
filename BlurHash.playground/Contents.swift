import UIKit
import BlurHash

var image = UIImage(named: "pic2.png")!

var hash = image.blurHash(components: (4, 3))!

var view = UIImageView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
var view2 = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
var layer = CALayer()
layer.frame = view2.layer.bounds
view2.layer.addSublayer(layer)
layer.contents = UIImage(blurHash: hash, size: CGSize(width: 16, height: 16), punch: 1)?.cgImage
layer.magnificationFilter = kCAFilterLinear
view2
view.image = UIImage(blurHash: hash, size: CGSize(width: 16, height: 16), punch: 1)
view.image = UIImage(blurHash: hash, size: image.size, punch: 1)
view.image = UIImage(blurHash: hash, size: image.size, punch: 0.5)
view.image = UIImage(blurHash: hash, size: image.size, punch: 1.5)
view.image = UIImage(blurHash: hash, size: image.size, punch: 2)

