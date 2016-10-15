//
//  r3piShoppingTests.swift
//  r3piShoppingTests
//
//  Created by Sean Denton on 7/30/16.
//  Copyright © 2016 Sean Denton. All rights reserved.
//

import XCTest
@testable import r3piShopping

class r3piShoppingTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCurrencyConversion() {
        CurencyConversion.sharedInstance.getConversionRate("USD")
        XCTAssertEqual(Cart.sharedInstance.cartConversion, 1, "US currency conversion should be 1")
    }
    func testCurrencyUnitChange() {
        CurencyConversion.sharedInstance.getConversionRate("MXN")
        XCTAssertEqual(Cart.sharedInstance.currency, "MXN", "Should change unit to MXN")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            CurencyConversion.sharedInstance.getConversionRate("USD")
        }
    }
    
}
