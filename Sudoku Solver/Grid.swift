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

class Grid {
    convenience init() {
        self.init(3)
    }

    init(_ grid: [[Int]]) {
        self.grid = grid
    }

    required init(_ grid: Grid) {
        self.grid = Array(grid.grid)
    }

    required init(_ size: Int) {
        self.grid = Array(count: size ** 2, repeatedValue: Array(count: size ** 2, repeatedValue: 0))
    }

    var size: Int {
        get {
            return self.grid.count;
        }
    }

    func clone() -> Grid {
        return self.dynamicType.init(self)
    }

    func valueAt(row: Int, _ col: Int) -> Int {
        return self.grid[row][col]
    }

    func place(value: Int, _ row: Int, _ col: Int) throws {
        if (!self.canPlace(value, row, col)) {
            throw MCError.InvalidArgument
        }

        self.grid[row][col] = value
    }

    func canPlace(value: Int, _ row: Int, _ col: Int) -> Bool {
        // not currently occupied
        if (self.grid[row][col] != 0) {
            return false
        }

        // none in same row
        if (self.grid[row].contains(value)) {
            return false
        }

        // none in same column
        for r1 in 0 ..< self.size {
            if (grid[r1][col] == value) {
                return false
            }
        }

        // none in same grouping
        let rowRange = (row / 3) * 3 ..< (row / 3 + 1) * 3
        let colRange = (col / 3) * 3 ..< (col / 3 + 1) * 3

        for r2 in rowRange {
            for c in colRange {
                if (self.grid[r2][c] == value) {
                    return false
                }
            }
        }

        return true
    }

    func tryPlace(value: Int, _ row: Int, _ col: Int) -> Bool {
        if (self.canPlace(value, row, col)) {
            try! self.place(value, row, col)
            return true
        }
        return false
    }

    func remove(row: Int, _ col: Int) {
        self.grid[row][col] = 0
    }

    func removeAll() {
        self.grid = Array(count: self.size, repeatedValue: Array(count: self.size, repeatedValue: 0))
    }

    func getPossiblePlacements(row: Int, _ col: Int) -> Set<Int> {
        var ret = Set<Int>()

        for i in 1 ... self.size {
            if (self.canPlace(i, row, col)) {
                ret.insert(i)
            }
        }

        return ret
    }

    private var grid: [[Int]];
}
