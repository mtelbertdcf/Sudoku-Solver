//
// Created by David on 3/20/16.
// Copyright (c) 2016 Mountainous Code LLC. All rights reserved.
//

import Foundation

class Grid {
    convenience init() {
        self.init(3)
    }

    init(_ size: Int) {
        self.grid = Array(count: size, repeatedValue: Array(count: size, repeatedValue: 0))
    }

    var size: Int {
        get {
            return grid.count
        }
    }

    func valueAt(row: Int, col: Int) -> Int {
        return self.grid[row][col]
    }

    func place(piece: Piece, row: Int, col: Int) {

    }

    func remove(row: Int, col: Int) {

    }

    func removeAll() {

    }

    private var grid: [[Int]];
}
