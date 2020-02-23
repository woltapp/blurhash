//
//  EncodeComponentsTests.swift
//  BlurHashKitTests
//
//  Created by Daisuke TONOSAKI on 2020/02/23.
//  Copyright © 2020 Dag Ågren. All rights reserved.
//

import XCTest
@testable import BlurHashKit

class EncodeComponentsTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEncodeComponents1() {
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (1, 1))
            let string = hash!.string
            XCTAssertEqual(string, "00M~Oi")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (1, 2))
            let string = hash!.string
            XCTAssertEqual(string, "95M~Oi43")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (1, 3))
            let string = hash!.string
            XCTAssertEqual(string, "I5M~Oi435Q")
        }
        
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (1, 4))
            let string = hash!.string
            XCTAssertEqual(string, "R6M~Oi8D9t8^")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (1, 5))
            let string = hash!.string
            XCTAssertEqual(string, "a6M~Oi8D9t8^^i")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (1, 6))
            let string = hash!.string
            XCTAssertEqual(string, "j6M~Oi8D9t8^^i^k")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (1, 7))
            let string = hash!.string
            XCTAssertEqual(string, "s6M~Oi8D9t8^^i^kJ7")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (1, 8))
            let string = hash!.string
            XCTAssertEqual(string, "$6M~Oi8D9t8^^i^kJ7-T")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (1, 9))
            let string = hash!.string
            XCTAssertEqual(string, "=6M~Oi8D9t8^^i^kJ7-TIV")
        }
    }
    
    func testEncodeComponents2() {
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (2, 1))
            let string = hash!.string
            XCTAssertEqual(string, "1lM~Oi00")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (2, 2))
            let string = hash!.string
            XCTAssertEqual(string, "AlM~Oi00S|WD")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (2, 3))
            let string = hash!.string
            XCTAssertEqual(string, "JlM~Oi00S|WDR*X8")
        }
        
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (2, 4))
            let string = hash!.string
            XCTAssertEqual(string, "SlM~Oi00S|WDR*X8Rjof")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (2, 5))
            let string = hash!.string
            XCTAssertEqual(string, "blM~Oi00S|WDR*X8Rjofs:of")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (2, 6))
            let string = hash!.string
            XCTAssertEqual(string, "klM~Oi00S|WDR*X8Rjofs:ofs:js")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (2, 7))
            let string = hash!.string
            XCTAssertEqual(string, "tlM~Oi00S|WDR*X8Rjofs:ofs:jsWVjb")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (2, 8))
            let string = hash!.string
            XCTAssertEqual(string, "%lM~Oi00S|WDR*X8Rjofs:ofs:jsWVjboLfk")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (2, 9))
            let string = hash!.string
            XCTAssertEqual(string, "?lM~Oi00S|WDR*X8Rjofs:ofs:jsWVjboLfkWBay")
        }
    }
    
    func testEncodeComponents3() {
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (3, 1))
            let string = hash!.string
            XCTAssertEqual(string, "2lM~Oi00%#")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (3, 2))
            let string = hash!.string
            XCTAssertEqual(string, "BlM~Oi00%#S|WDWE")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (3, 3))
            let string = hash!.string
            XCTAssertEqual(string, "KlM~Oi00%#S|WDWER*X8R*")
        }
        
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (3, 4))
            let string = hash!.string
            XCTAssertEqual(string, "TlM~Oi00%#S|WDWER*X8R*Rjofs.")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (3, 5))
            let string = hash!.string
            XCTAssertEqual(string, "clM~Oi00%#S|WDWER*X8R*Rjofs.s:ofjs")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (3, 6))
            let string = hash!.string
            XCTAssertEqual(string, "llM~Oi00%#S|WDWER*X8R*Rjofs.s:ofjss:jsWC")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (3, 7))
            let string = hash!.string
            XCTAssertEqual(string, "ulM~Oi00%#S|WDWER*X8R*Rjofs.s:ofjss:jsWCWVjbjt")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (3, 8))
            let string = hash!.string
            XCTAssertEqual(string, "*lM~Oi00%#S|WDWER*X8R*Rjofs.s:ofjss:jsWCWVjbjtoLfka|")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (3, 9))
            let string = hash!.string
            XCTAssertEqual(string, "@lM~Oi00%#S|WDWER*X8R*Rjofs.s:ofjss:jsWCWVjbjtoLfka|WBayj[")
        }
    }
    
    func testEncodeComponents4() {
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (4, 1))
            let string = hash!.string
            XCTAssertEqual(string, "3lM~Oi00%#Mw")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (4, 2))
            let string = hash!.string
            XCTAssertEqual(string, "ClM~Oi00%#MwS|WDWEIo")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (4, 3))
            let string = hash!.string
            XCTAssertEqual(string, "LlM~Oi00%#MwS|WDWEIoR*X8R*bH")
        }
        
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (4, 4))
            let string = hash!.string
            XCTAssertEqual(string, "UlM~Oi00%#MwS|WDWEIoR*X8R*bHRjofs.R*")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (4, 5))
            let string = hash!.string
            XCTAssertEqual(string, "dlM~Oi00%#MwS|WDWEIoR*X8R*bHRjofs.R*s:ofjsof")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (4, 6))
            let string = hash!.string
            XCTAssertEqual(string, "mlM~Oi00%#MwS|WDWEIoR*X8R*bHRjofs.R*s:ofjsofs:jsWCfQ")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (4, 7))
            let string = hash!.string
            XCTAssertEqual(string, "vlM~Oi00%#MwS|WDWEIoR*X8R*bHRjofs.R*s:ofjsofs:jsWCfQWVjbjtjs")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (4, 8))
            let string = hash!.string
            XCTAssertEqual(string, "+lM~Oi00%#MwS|WDWEIoR*X8R*bHRjofs.R*s:ofjsofs:jsWCfQWVjbjtjsoLfka|j?")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (4, 9))
            let string = hash!.string
            XCTAssertEqual(string, "[lM~Oi00%#MwS|WDWEIoR*X8R*bHRjofs.R*s:ofjsofs:jsWCfQWVjbjtjsoLfka|j?WBayj[jt")
        }
    }
    
    func testEncodeComponents5() {
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (5, 1))
            let string = hash!.string
            XCTAssertEqual(string, "4lM~Oi00%#Mwo}")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (5, 2))
            let string = hash!.string
            XCTAssertEqual(string, "DlM~Oi00%#Mwo}S|WDWEIoa$")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (5, 3))
            let string = hash!.string
            XCTAssertEqual(string, "MlM~Oi00%#Mwo}S|WDWEIoa$R*X8R*bHbI")
        }
        
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (5, 4))
            let string = hash!.string
            XCTAssertEqual(string, "VlM~Oi00%#Mwo}S|WDWEIoa$R*X8R*bHbIRjofs.R*R+")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (5, 5))
            let string = hash!.string
            XCTAssertEqual(string, "elM~Oi00%#Mwo}S|WDWEIoa$R*X8R*bHbIRjofs.R*R+s:ofjsofbF")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (5, 6))
            let string = hash!.string
            XCTAssertEqual(string, "nlM~Oi00%#Mwo}S|WDWEIoa$R*X8R*bHbIRjofs.R*R+s:ofjsofbFs:jsWCfQjZ")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (5, 7))
            let string = hash!.string
            XCTAssertEqual(string, "wlM~Oi00%#Mwo}S|WDWEIoa$R*X8R*bHbIRjofs.R*R+s:ofjsofbFs:jsWCfQjZWVjbjtjsjs")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (5, 8))
            let string = hash!.string
            XCTAssertEqual(string, ",lM~Oi00%#Mwo}S|WDWEIoa$R*X8R*bHbIRjofs.R*R+s:ofjsofbFs:jsWCfQjZWVjbjtjsjsoLfka|j?j[")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (5, 9))
            let string = hash!.string
            XCTAssertEqual(string, "]lM~Oi00%#Mwo}S|WDWEIoa$R*X8R*bHbIRjofs.R*R+s:ofjsofbFs:jsWCfQjZWVjbjtjsjsoLfka|j?j[WBayj[jtf6")
        }
    }
    
    func testEncodeComponents6() {
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (6, 1))
            let string = hash!.string
            XCTAssertEqual(string, "5lM~Oi00%#Mwo}wb")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (6, 2))
            let string = hash!.string
            XCTAssertEqual(string, "ElM~Oi00%#Mwo}wbS|WDWEIoa$s.")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (6, 3))
            let string = hash!.string
            XCTAssertEqual(string, "NlM~Oi00%#Mwo}wbS|WDWEIoa$s.R*X8R*bHbIaw")
        }
        
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (6, 4))
            let string = hash!.string
            XCTAssertEqual(string, "WlM~Oi00%#Mwo}wbS|WDWEIoa$s.R*X8R*bHbIawRjofs.R*R+ax")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (6, 5))
            let string = hash!.string
            XCTAssertEqual(string, "flM~Oi00%#Mwo}wbS|WDWEIoa$s.R*X8R*bHbIawRjofs.R*R+axs:ofjsofbFWB")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (6, 6))
            let string = hash!.string
            XCTAssertEqual(string, "olM~Oi00%#Mwo}wbS|WDWEIoa$s.R*X8R*bHbIawRjofs.R*R+axs:ofjsofbFWBs:jsWCfQjZWC")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (6, 7))
            let string = hash!.string
            XCTAssertEqual(string, "xlM~Oi00%#Mwo}wbS|WDWEIoa$s.R*X8R*bHbIawRjofs.R*R+axs:ofjsofbFWBs:jsWCfQjZWCWVjbjtjsjsa|")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (6, 8))
            let string = hash!.string
            XCTAssertEqual(string, "-lM~Oi00%#Mwo}wbS|WDWEIoa$s.R*X8R*bHbIawRjofs.R*R+axs:ofjsofbFWBs:jsWCfQjZWCWVjbjtjsjsa|oLfka|j?j[jZ")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (6, 9))
            let string = hash!.string
            XCTAssertEqual(string, "^lM~Oi00%#Mwo}wbS|WDWEIoa$s.R*X8R*bHbIawRjofs.R*R+axs:ofjsofbFWBs:jsWCfQjZWCWVjbjtjsjsa|oLfka|j?j[jZWBayj[jtf6az")
        }
    }
    
    func testEncodeComponents7() {
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (7, 1))
            let string = hash!.string
            XCTAssertEqual(string, "6lM~Oi00%#Mwo}wbtR")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (7, 2))
            let string = hash!.string
            XCTAssertEqual(string, "FlM~Oi00%#Mwo}wbtRS|WDWEIoa$s.WB")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (7, 3))
            let string = hash!.string
            XCTAssertEqual(string, "OlM~Oi00%#Mwo}wbtRS|WDWEIoa$s.WBR*X8R*bHbIawt7")
        }
        
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (7, 4))
            let string = hash!.string
            XCTAssertEqual(string, "XlM~Oi00%#Mwo}wbtRS|WDWEIoa$s.WBR*X8R*bHbIawt7Rjofs.R*R+axR+")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (7, 5))
            let string = hash!.string
            XCTAssertEqual(string, "glM~Oi00%#Mwo}wbtRS|WDWEIoa$s.WBR*X8R*bHbIawt7Rjofs.R*R+axR+s:ofjsofbFWBfl")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (7, 6))
            let string = hash!.string
            XCTAssertEqual(string, "plM~Oi00%#Mwo}wbtRS|WDWEIoa$s.WBR*X8R*bHbIawt7Rjofs.R*R+axR+s:ofjsofbFWBfls:jsWCfQjZWCbH")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (7, 7))
            let string = hash!.string
            XCTAssertEqual(string, "ylM~Oi00%#Mwo}wbtRS|WDWEIoa$s.WBR*X8R*bHbIawt7Rjofs.R*R+axR+s:ofjsofbFWBfls:jsWCfQjZWCbHWVjbjtjsjsa|ay")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (7, 8))
            let string = hash!.string
            XCTAssertEqual(string, ".lM~Oi00%#Mwo}wbtRS|WDWEIoa$s.WBR*X8R*bHbIawt7Rjofs.R*R+axR+s:ofjsofbFWBfls:jsWCfQjZWCbHWVjbjtjsjsa|ayoLfka|j?j[jZoL")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (7, 9))
            let string = hash!.string
            XCTAssertEqual(string, "_lM~Oi00%#Mwo}wbtRS|WDWEIoa$s.WBR*X8R*bHbIawt7Rjofs.R*R+axR+s:ofjsofbFWBfls:jsWCfQjZWCbHWVjbjtjsjsa|ayoLfka|j?j[jZoLWBayj[jtf6azWC")
        }
    }
    
    func testEncodeComponents8() {
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (8, 1))
            let string = hash!.string
            XCTAssertEqual(string, "7lM~Oi00%#Mwo}wbtRjF")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (8, 2))
            let string = hash!.string
            XCTAssertEqual(string, "GlM~Oi00%#Mwo}wbtRjFS|WDWEIoa$s.WBa#")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (8, 3))
            let string = hash!.string
            XCTAssertEqual(string, "PlM~Oi00%#Mwo}wbtRjFS|WDWEIoa$s.WBa#R*X8R*bHbIawt7ae")
        }
        
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (8, 4))
            let string = hash!.string
            XCTAssertEqual(string, "YlM~Oi00%#Mwo}wbtRjFS|WDWEIoa$s.WBa#R*X8R*bHbIawt7aeRjofs.R*R+axR+WB")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (8, 5))
            let string = hash!.string
            XCTAssertEqual(string, "hlM~Oi00%#Mwo}wbtRjFS|WDWEIoa$s.WBa#R*X8R*bHbIawt7aeRjofs.R*R+axR+WBs:ofjsofbFWBflfj")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (8, 6))
            let string = hash!.string
            XCTAssertEqual(string, "qlM~Oi00%#Mwo}wbtRjFS|WDWEIoa$s.WBa#R*X8R*bHbIawt7aeRjofs.R*R+axR+WBs:ofjsofbFWBflfjs:jsWCfQjZWCbHkC")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (8, 7))
            let string = hash!.string
            XCTAssertEqual(string, "zlM~Oi00%#Mwo}wbtRjFS|WDWEIoa$s.WBa#R*X8R*bHbIawt7aeRjofs.R*R+axR+WBs:ofjsofbFWBflfjs:jsWCfQjZWCbHkCWVjbjtjsjsa|ayj@")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (8, 8))
            let string = hash!.string
            XCTAssertEqual(string, ":lM~Oi00%#Mwo}wbtRjFS|WDWEIoa$s.WBa#R*X8R*bHbIawt7aeRjofs.R*R+axR+WBs:ofjsofbFWBflfjs:jsWCfQjZWCbHkCWVjbjtjsjsa|ayj@oLfka|j?j[jZoLay")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (8, 9))
            let string = hash!.string
            XCTAssertEqual(string, "{lM~Oi00%#Mwo}wbtRjFS|WDWEIoa$s.WBa#R*X8R*bHbIawt7aeRjofs.R*R+axR+WBs:ofjsofbFWBflfjs:jsWCfQjZWCbHkCWVjbjtjsjsa|ayj@oLfka|j?j[jZoLayWBayj[jtf6azWCaf")
        }
    }
    
    func testEncodeComponents9() {
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (9, 1))
            let string = hash!.string
            XCTAssertEqual(string, "8lM~Oi00%#Mwo}wbtRjFoe")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (9, 2))
            let string = hash!.string
            XCTAssertEqual(string, "HlM~Oi00%#Mwo}wbtRjFoeS|WDWEIoa$s.WBa#ni")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (9, 3))
            let string = hash!.string
            XCTAssertEqual(string, "QlM~Oi00%#Mwo}wbtRjFoeS|WDWEIoa$s.WBa#niR*X8R*bHbIawt7aeWV")
        }
        
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (9, 4))
            let string = hash!.string
            XCTAssertEqual(string, "ZlM~Oi00%#Mwo}wbtRjFoeS|WDWEIoa$s.WBa#niR*X8R*bHbIawt7aeWVRjofs.R*R+axR+WBof")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (9, 5))
            let string = hash!.string
            XCTAssertEqual(string, "ilM~Oi00%#Mwo}wbtRjFoeS|WDWEIoa$s.WBa#niR*X8R*bHbIawt7aeWVRjofs.R*R+axR+WBofs:ofjsofbFWBflfjog")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (9, 6))
            let string = hash!.string
            XCTAssertEqual(string, "rlM~Oi00%#Mwo}wbtRjFoeS|WDWEIoa$s.WBa#niR*X8R*bHbIawt7aeWVRjofs.R*R+axR+WBofs:ofjsofbFWBflfjogs:jsWCfQjZWCbHkCWV")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (9, 7))
            let string = hash!.string
            XCTAssertEqual(string, "#lM~Oi00%#Mwo}wbtRjFoeS|WDWEIoa$s.WBa#niR*X8R*bHbIawt7aeWVRjofs.R*R+axR+WBofs:ofjsofbFWBflfjogs:jsWCfQjZWCbHkCWVWVjbjtjsjsa|ayj@j[")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (9, 8))
            let string = hash!.string
            XCTAssertEqual(string, ";lM~Oi00%#Mwo}wbtRjFoeS|WDWEIoa$s.WBa#niR*X8R*bHbIawt7aeWVRjofs.R*R+axR+WBofs:ofjsofbFWBflfjogs:jsWCfQjZWCbHkCWVWVjbjtjsjsa|ayj@j[oLfka|j?j[jZoLayWV")
        }
        
        do {
            let hash = BlurHash(image: UIImage(named: "pic2.png", in: Bundle(for: type(of: self)),
                                               compatibleWith: nil)!, numberOfComponents: (9, 9))
            let string = hash!.string
            XCTAssertEqual(string, "|lM~Oi00%#Mwo}wbtRjFoeS|WDWEIoa$s.WBa#niR*X8R*bHbIawt7aeWVRjofs.R*R+axR+WBofs:ofjsofbFWBflfjogs:jsWCfQjZWCbHkCWVWVjbjtjsjsa|ayj@j[oLfka|j?j[jZoLayWVWBayj[jtf6azWCafoL")
        }
    }
    
}
