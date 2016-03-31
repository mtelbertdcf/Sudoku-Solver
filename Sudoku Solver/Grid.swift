//
// Created by David on 3/20/16.
// Copyright (c) 2016 Mountainous Code LLC. All rights reserved.
//

import Foundation
import GameplayKit
import MtTools


//typealias Position = (row:Int, col:Int)

struct Position: Equatable, Hashable {
    init() {

    }

    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }

    var hashValue: Int {
        return self.row.hashValue * 13 + self.col.hashValue
    }

    var row = 0
    var col = 0
}

func ==(rhs: Position, lhs: Position) -> Bool {
    return rhs.row == lhs.row && rhs.col == lhs.col
}


class Grid: CustomStringConvertible {

    required init(grid: Grid) {
        self.grid = Array(grid.grid)
    }

    required init(size: Int) {
        self.grid = Array(count: size ** 2, repeatedValue: Array(count: size ** 2, repeatedValue: 0))
    }

    convenience init() {
        self.init(size: 3)
    }

    convenience init(representation: String) {
        let trimmed = Grid.trimString(representation)
        let size = trimmed.characters.count ** 0.25   // 4th root to get Z x Z where Z = size
        self.init(size: size)
        self.fromString(representation)
    }

    // properties

    var size: Int {
        get {
            return self.grid.count;
        }
    }

    var isSolved: Bool {
        return (self.getOpenPositions().count == 0)
    }

    var isUnsolvable: Bool {
        let openPositions = self.getOpenPositions()
        for p in openPositions {
            if (self.getPossiblePlacements(p).count == 0) {
                return true
            }
        }
        return false
    }

    var description: String {
        let ret: NSMutableString = ""

        let segmentSize = self.size ** 0.5

        for i in 0 ..< self.size {
            for j in 0 ..< self.size {
                ret.appendString(String(grid[i][j]))
                if ((j + 1) % segmentSize == 0) {
                    ret.appendString("|")
                }
            }
            if ((i + 1) % segmentSize == 0) {
                ret.appendString("\n")
                for _ in 0 ..< self.size + segmentSize {
                    ret.appendString("-")
                }
            }
            ret.appendString("\n")
        }

        return String(ret)
    }

    // class methods

    static func solve(grid: Grid, callback: ((Grid) -> Void)? = nil) -> Grid? {
        grid.makeSinglePlacements()

        if (grid.isSolved) {
            return grid
        }

        if (grid.isUnsolvable) {
            return nil
        }

        // try just the first position, and recurse down for next (their first) position
        let openPosition = grid.getOpenPositions().first!
        let possibilities = grid.getPossiblePlacements(openPosition)
        for possibility in possibilities {
            let clone = Grid(grid: grid)    // copy so we dont fuck up original during recursion (swift arrays are fun!)
            try! clone.place(possibility, position: openPosition)
            callback?(clone)
            if let solution = Grid.solve(clone, callback: callback) {
                return solution
            }
        }
        return nil
    }

    static func random() -> Grid {
        // helper
        func pick(upperBound: Int) -> Int {
            return GKRandomSource.sharedRandom().nextIntWithUpperBound(upperBound)
        }

        let grid = Grid()

        var openPositions = grid.getOpenPositions()
        while (openPositions.count > 0) {
            let openPosition = openPositions.first!
            let possibilities = grid.getPossiblePlacements(openPosition)
            grid.tryPlace(possibilities[possibilities.startIndex.advancedBy(pick(possibilities.count))], position: openPosition)
            grid.makeSinglePlacements()
            if (grid.isUnsolvable) {
                // oops. start over (not very performant, but who cares, it's instant)
                grid.removeAll()
            }
            openPositions = grid.getOpenPositions()
        }
        return grid
    }

    // methods

    func clone() -> Grid {
        return self.dynamicType.init(grid: self)
    }

    func valueAt(position: Position) -> Int {
        return self.grid[position.row][position.col]
    }

    subscript(position: Position) -> Int {
        return self.valueAt(position)
    }

    func place(value: Int, position: Position) throws {
        if (!self.canPlace(value, position: position)) {
            throw MCError.InvalidArgument
        }

        self.grid[position.row][position.col] = value
    }

    func canPlace(value: Int, position: Position) -> Bool {
        // not currently occupied
        if (self.grid[position.row][position.col] != 0) {
            return false
        }

        // none in same row
        if (self.grid[position.row].contains(value)) {
            return false
        }

        // none in same column
        for r1 in 0 ..< self.size {
            if (grid[r1][position.col] == value) {
                return false
            }
        }

        // none in same grouping
        let rowRange = (position.row / 3) * 3 ..< (position.row / 3 + 1) * 3
        let colRange = (position.col / 3) * 3 ..< (position.col / 3 + 1) * 3

        for r2 in rowRange {
            for c in colRange {
                if (self.grid[r2][c] == value) {
                    return false
                }
            }
        }

        return true
    }

    func tryPlace(value: Int, position: Position) -> Bool {
        if (self.canPlace(value, position: position)) {
            try! self.place(value, position: position)
            return true
        }
        return false
    }

    func remove(position: Position) {
        self.grid[position.row][position.col] = 0
    }

    func removeAll() {
        // note: is there a fast way to set all array values?
        self.grid = Array(count: self.size, repeatedValue: Array(count: self.size, repeatedValue: 0))
    }

    func getPossiblePlacements(position: Position) -> Set<Int> {
        var ret = Set<Int>()

        for i in 1 ... self.size {
            if (self.canPlace(i, position: position)) {
                ret.insert(i)
            }
        }

        return ret
    }

    func getOpenPositions() -> [Position] {
        var positions: [Position] = []

        for r in 0 ..< self.size {
            for c in 0 ..< self.size {
                if (self.grid[r][c] == 0) {
                    positions.append(Position(r, c))
                }
            }
        }

        return positions;
    }

    func fromString(representation: String) -> Void {
        let trimmed = Grid.trimString(representation)
        var row: Int = 0, col: Int = 0
        for i in trimmed.startIndex ..< trimmed.endIndex {
            let v = Int(String(trimmed[i]))!

            if (v == 0) {
                self.remove(Position(row, col))
            } else {
                try! self.place(v, position: Position(row, col))
            }

            // populate each row of my 2D array
            col += 1
            if (col >= self.size) {
                row += 1
                col = 0
            }
        }
    }

    // privates

    private static func trimString(representation: String) -> String {
        // convert "spacers" to 0
        let trimmed = representation.stringByReplacingOccurrencesOfString("[ -_]", withString: "0", options: NSStringCompareOptions.RegularExpressionSearch)
        // remove all non-digits from input
        return trimmed.stringByReplacingOccurrencesOfString("\\D", withString: "", options: NSStringCompareOptions.RegularExpressionSearch)
    }

    private func makeSinglePlacements() -> Void {
        var openCount = self.size * self.size
        var openPositions = self.getOpenPositions()
        while (!self.isUnsolvable && openPositions.count > 0 && openPositions.count < openCount) {
            openCount = openPositions.count

            // solve where only one possibility exists at a position
            for i in 0 ..< openCount {
                let possibilities = self.getPossiblePlacements(openPositions[i])
                // only one possible value? Then solve for it
                if (possibilities.count == 1) {
                    try! self.place(possibilities.first!, position: openPositions[i])
                }
            }

            openPositions = self.getOpenPositions()
        }
    }

    private var grid: [[Int]];
}
