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
        XCTAssertEqual(grid.size, 9)
        XCTAssertEqual(grid.valueAt(0, 0), 0)
        try! grid.place(1, 0, 0)
        XCTAssertEqual(grid.valueAt(0, 0), 1)
        do {
            try grid.place(1, 0, 0); XCTFail("Did not throw"); } catch {
        }

        grid.removeAll()
        XCTAssertEqual(grid.valueAt(0, 0), 0)

        grid.tryPlace(1, 0, 0)
        XCTAssertEqual(grid.valueAt(0, 0), 1)
        grid.tryPlace(2, 0, 0)
        XCTAssertEqual(grid.valueAt(0, 0), 1)
    }

    func testPlacements() {
        let grid = Grid()

        try! grid.place(1, 0, 0)
        XCTAssertFalse(grid.tryPlace(1, 0, 0))

        // test same row, same column, same grouping
        XCTAssertFalse(grid.canPlace(1, 1, 0))
        XCTAssertFalse(grid.canPlace(1, 0, 1))
        XCTAssertFalse(grid.canPlace(1, 1, 1))

        grid.remove(0, 0)
        XCTAssertEqual(grid.valueAt(0, 0), 0)
        XCTAssertTrue(grid.canPlace(1, 0, 0))
    }

    func testPossibilities() {
        let grid = Grid()

        // set a couple pieces and check for valid possibilities
        do {
            try grid.place(1, 0, 0)
            try grid.place(2, 1, 0)
            try grid.place(3, 0, 1)
        } catch {
        }

        var possibilities = grid.getPossiblePlacements(0, 0)
        XCTAssertTrue(possibilities.isEmpty)

        possibilities = grid.getPossiblePlacements(5, 5)
        XCTAssertFalse(possibilities.isEmpty)
        XCTAssertEqual(possibilities.count, 9)
    }
    
}
