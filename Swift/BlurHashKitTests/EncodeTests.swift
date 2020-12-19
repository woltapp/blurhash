//
//  EncodeTests.swift
//  BlurHashKitTests
//
//  Created by Daisuke TONOSAKI on 2020/02/23.
//  Copyright © 2020 Dag Ågren. All rights reserved.
//

import XCTest
@testable import BlurHashKit

class EncodeTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEncode() {
        do {
            let hash = BlurHash(image: UIImage(named: "pic1.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (4, 3))
            let string = hash!.string
            XCTAssertEqual(string, "LbJal#Vu8{~pkXsmR,a~xZoLWCRj")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (4, 3))
            let string = hash!.string
            XCTAssertEqual(string, "LlM~Oi00%#MwS|WDWEIoR*X8R*bH")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic3.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (4, 3))
            let string = hash!.string
            XCTAssertEqual(string, "LA9?qERP14Ezr=xYI?I[9~WW-6xF")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic4.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (4, 3))
            let string = hash!.string
            XCTAssertEqual(string, "L08ia?o|fQo|tkfQfQfQfQfQfQfQ")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic5.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (4, 3))
            let string = hash!.string
            XCTAssertEqual(string, "L%HV9wj[fQj[~qfQfQfQ%MfQfQfQ")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic6.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (4, 3))
            let string = hash!.string
            XCTAssertEqual(string, "L#N^0dxa?wNa-;WBf,WBs;baR*af")
        }
    }
    
}
