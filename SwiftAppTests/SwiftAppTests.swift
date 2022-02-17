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

    func testModel() throws {
        let c0 = Cell.stack([.text("Title0")])
        let c1 = Cell.stack([.text("Title1")])
        assert("\(c0)" == String(describing: c0))
        XCTAssertEqual(c0, c0)
        XCTAssertNotEqual(c0, c1)
        
        let img0 = UIImage(systemName: "plus.circle") ?? UIImage()
        let img1 = UIImage(systemName: "minus.circle") ?? UIImage()
        assert(img0 != img1)
        
        guard let cg0 = img0.cgImage else { return }
        let cgImage0 = UIImage(cgImage: cg0)
        let cgImage1 = UIImage(cgImage: cg0)
        print("\(cgImage0.hashValue)")
        print("\(cgImage1)")
        assert(cgImage0 == cgImage1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
