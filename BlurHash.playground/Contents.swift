//: Playground - noun: a place where people can play

import UIKit
import BlurHash

var image = UIImage(named: "pic2.png")!

var hash = image.blurHash(components: (3, 3))!

var blurImage1 = UIImage(blurHash: hash, size: image.size, punch: 1)
var blurImage2 = UIImage(blurHash: hash, size: image.size, punch: 2)
var blurImage3 = UIImage(blurHash: hash, size: image.size, punch: 3)

