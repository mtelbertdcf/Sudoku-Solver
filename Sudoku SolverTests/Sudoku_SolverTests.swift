//
//  Sudoku_SolverTests.swift
//  Sudoku SolverTests
//
//  Created by David on 2/23/16.
//  Copyright © 2016 Mountainous Code LLC. All rights reserved.
//

import XCTest
@testable import Sudoku_Solver

enum TestError: ErrorType {
    case DidNotThrow;
}

class Sudoku_SolverTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measureBlock {
//            // Put the code you want to measure the time of here.
//        }
//    }

    func testBasicGrid() {
        let grid = Grid();
        XCTAssertEqual(grid.size, 3)
        XCTAssertEqual(grid.valueAt(0, 0), 0)
        try! grid.place(1, 0, 0)
        XCTAssertEqual(grid.valueAt(0, 0), 1)
        do {
            try grid.place(1, 0, 0); XCTFail("Did not throw"); } catch {
        }

        grid.removeAll()
        XCTAssertEqual(grid.valueAt(0, 0), 0)

        grid.tryPlace(1, row: 0, col: 0)
        XCTAssertEqual(grid.valueAt(0, 0), 1)
        grid.tryPlace(2, row: 0, col: 0)
        XCTAssertEqual(grid.valueAt(0, 0), 1)
    }

    func testPlacements() {
        let grid = Grid()

        grid.tryPlace(1, row: 0, col: 0);
        XCTAssertFalse(grid.tryPlace(1, row: 0, col: 0));
    }
    
}
