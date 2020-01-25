//
//  elmenusTaskTests.swift
//  elmenusTaskTests
//
//  Created by D-TAG on 1/24/20.
//  Copyright © 2020 elmenus. All rights reserved.
//

import XCTest
import RxSwift
@testable import elmenusTask

class elmenusTaskTests: XCTestCase {
    
    var homeViewModel = HomeViewModel()
    var disposeBag = DisposeBag()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testTags() {
        let expectations = self.expectation(description: "Getting Tags Parse Expectations")
        homeViewModel.getTags(PageNumber: 0).subscribe(onNext: { (tags) in
            XCTAssertNotNil(tags)
            expectations.fulfill()
        }, onError: { (error) in
            XCTFail()
        }).disposed(by: disposeBag)
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }
    func testItems() {
        let expectations = self.expectation(description: "Getting Items Parse Expectations")
        homeViewModel.getItems(tagName: "Sea Food").subscribe(onNext: { (items) in
            XCTAssertNotNil(items)
            expectations.fulfill()
        }, onError: { (error) in
            XCTFail()
        }).disposed(by: disposeBag)
        
        self.waitForExpectations(timeout: 5, handler: nil)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            testTags()
            testItems()
        }
    }

}
