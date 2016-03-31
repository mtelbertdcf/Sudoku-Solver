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
        XCTAssertEqual(grid.valueAt(Position(0, 0)), 0)
        try! grid.place(1, position: Position(0, 0))
        XCTAssertEqual(grid.valueAt(Position(0, 0)), 1)
        do {
            try grid.place(1, position: Position(0, 0)); XCTFail("Did not throw"); } catch {
        }

        grid.removeAll()
        XCTAssertEqual(grid.valueAt(Position(0, 0)), 0)

        grid.tryPlace(1, position: Position(0, 0))
        XCTAssertEqual(grid.valueAt(Position(0, 0)), 1)
        grid.tryPlace(2, position: Position(0, 0))
        XCTAssertEqual(grid.valueAt(Position(0, 0)), 1)
    }

    func testPlacements() {
        let grid = Grid()

        try! grid.place(1, position: Position(0, 0))
        XCTAssertFalse(grid.tryPlace(1, position: Position(0, 0)))

        // test same row, same column, same grouping
        XCTAssertFalse(grid.canPlace(1, position: Position(1, 0)))
        XCTAssertFalse(grid.canPlace(1, position: Position(0, 1)))
        XCTAssertFalse(grid.canPlace(1, position: Position(1, 1)))

        grid.remove(Position(0, 0))
        XCTAssertEqual(grid.valueAt(Position(0, 0)), 0)
        XCTAssertTrue(grid.canPlace(1, position: Position(0, 0)))
    }

    func testPossibilities() {
        let grid = Grid()

        // set a couple pieces and check for valid possibilities
        do {
            try grid.place(1, position: Position(0, 0))
            try grid.place(2, position: Position(1, 0))
            try grid.place(3, position: Position(0, 1))
        } catch {
        }

        var possibilities = grid.getPossiblePlacements(Position(0, 0))
        XCTAssertTrue(possibilities.isEmpty)

        possibilities = grid.getPossiblePlacements(Position(5, 5))
        XCTAssertFalse(possibilities.isEmpty)
        XCTAssertEqual(possibilities.count, 9)
    }

    func testGridEquality() {
        let grid1 = Grid()

        try! grid1.place(1, position: Position(0, 0))
        let grid2 = Grid(grid: grid1)

        XCTAssertEqual(grid1.valueAt(Position(0, 0)), grid2.valueAt(Position(0, 0)))
        grid2.removeAll();
        XCTAssertNotEqual(grid1.valueAt(Position(0, 0)), grid2.valueAt(Position(0, 0)))

        let s = grid1.description

        let grid3 = Grid(representation: s)
        XCTAssertNotNil(grid3)
        XCTAssertEqual(grid3.valueAt(Position(0, 0)), grid1.valueAt(Position(0, 0)))

        grid3.removeAll()
        XCTAssertEqual(grid3.getOpenPositions().count, 81)

        grid3.fromString(s)
        XCTAssertLessThan(grid3.getOpenPositions().count, 81)
    }


    func testAnalysis() {
        // auto-populate from my string and make sure its consistent
        self.measureBlock {
            self.checkPuzzle(self.easyPuzzle)
            self.checkPuzzle(self.hardPuzzle)
            self.checkPuzzle(self.evilPuzzle)
        }
    }

    private func checkPuzzle(s: String) {
        var g = Grid(representation: s)
        XCTAssertNotEqual(g.getOpenPositions().count, 81)
        var solution = Grid.solve(g)

        XCTAssertNotNil(solution)
        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                var position = Position(r, c)
                if (g[position] != 0) {
                    XCTAssertEqual(g[position], solution![position])
                } else {
                    XCTAssertNotEqual(solution![position], 0)
                }
            }
        }
    }


    private let hardPuzzle =
    "810620000" +
            "000800100" +
            "004001830" +
            "040307250" +
            "006000900" +
            "078405010" +
            "081700500" +
            "007009000" +
            "000086029"

    private let evilPuzzle =
            "000000000" +
                    "590102370" +
                    "000036010" +
                    "305000460" +
                    "000000000" +
                    "064000203" +
                    "030790000" +
                    "072804039" +
                    "000000000"

    private let easyPuzzle =
    "100304000" +
            "042960000" +
            "930501020" +
            "753000068" +
            "001000400" +
            "260000137" +
            "070608045" +
            "000079380" +
            "000203006"
}
