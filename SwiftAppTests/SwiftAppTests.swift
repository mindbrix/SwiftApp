//
//  SwiftAppTests.swift
//  SwiftAppTests
//
//  Created by Nigel Barber on 06/02/2022.
//

import XCTest
@testable import SwiftApp

class SwiftAppTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testImages() throws {
        guard let img0 = UIImage(systemName: "plus.circle"),
                let img1 = UIImage(systemName: "minus.circle"),
                let cg0 = img0.cgImage,
                let cg1 = img1.cgImage
        else {
            return
        }
        
        XCTAssertTrue(img0 != img1)
        XCTAssertTrue(img0.hashValue != img1.hashValue)
        XCTAssertTrue(cg0.hashValue != cg1.hashValue)
        XCTAssertTrue(String(img0.hashValue).count >= String(cg0.hashValue).count)
        
        let rawImg0 = UIImage(cgImage: cg0)
        let rawImg1 = UIImage(cgImage: cg0)
        XCTAssertTrue(rawImg0 == rawImg1)
    }

    func testModel() throws {
        let c0 = Cell([.text("Title0")])
        let c1 = Cell([.text("Title1")])
        XCTAssertTrue("\(c0)" == String(describing: c0))
        XCTAssertEqual(c0, c0)
        XCTAssertNotEqual(c0, c1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
