//
// Created by David on 3/20/16.
// Copyright (c) 2016 Mountainous Code LLC. All rights reserved.
//

import Foundation

enum MCError: ErrorType {
    case InvalidArgument
}

infix operator ** { associativity left precedence 160 }

func **(radix: Int, power: Double) -> Int {
    return Int(pow(Double(radix), power))
}

typealias Position = (row:Int, col:Int)

class Grid {
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
        let trimmed = representation.stringByReplacingOccurrencesOfString("\\s", withString: "", options: NSStringCompareOptions.RegularExpressionSearch)
        let size = trimmed.utf8.count ** 0.25   // 4th root to get Z x Z where Z = size
        self.init(size: size)
        self.fromString(representation)
    }

    // properties

    var size: Int {
        get {
            return self.grid.count;
        }
    }

    // methods

    func clone() -> Grid {
        return self.dynamicType.init(grid: self)
    }

    func valueAt(position: Position) -> Int {
        return self.grid[position.row][position.col]
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
                    positions.append((r, c))
                }
            }
        }

        return positions;
    }

    func toString() -> String {
        var ret = ""

        for i in 0 ..< self.size {
            for j in 0 ..< self.size {
                ret += String(grid[i][j])
            }
            ret += "\n"
        }

        return ret
    }

    func fromString(representation: String) -> Void {
        let trimmed = representation.stringByReplacingOccurrencesOfString("\\s", withString: "", options: NSStringCompareOptions.RegularExpressionSearch)

        var row: Int = 0, col: Int = 0
        for i in trimmed.startIndex ..< trimmed.endIndex {
            let v = Int(String(trimmed[i]))!

            if (v == 0) {
                self.remove((row, col))
            } else {
                try! self.place(v, position: (row, col))
            }

            // populate each row of my 2d array
            col += 1
            if (col >= self.size) {
                row += 1
                col = 0
            }
        }
    }

    func solve() -> Bool {
        var openCount = self.size * self.size
        var open = self.getOpenPositions()

        while (open.count > 0 && open.count < openCount) {
            openCount = open.count
            for i in 0 ..< openCount {
                let possibilities = self.getPossiblePlacements(open[i])
                // only one possible value? Then solve for it
                if (possibilities.count == 1) {
                    self.tryPlace(possibilities.first!, position: open[i])
                }
            }

            open = self.getOpenPositions()
        }

        return open.count == 0
    }

    // privates

    private var grid: [[Int]];
}
