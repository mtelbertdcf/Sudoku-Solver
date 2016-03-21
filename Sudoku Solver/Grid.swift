//
// Created by David on 3/20/16.
// Copyright (c) 2016 Mountainous Code LLC. All rights reserved.
//

import Foundation

enum MyError: ErrorType {
    case MyFirstError
}

class Grid {
    convenience init() {
        self.init(3)
    }

    init(_ size: Int) {
        self.grid = Array(count: size, repeatedValue: Array(count: size, repeatedValue: 0))
    }

    var size: Int {
        get {
            return self.grid.count;
        }
    }

    func valueAt(row: Int, _ col: Int) -> Int {
        return self.grid[row][col]
    }

    func place(value: Int, _ row: Int, _ col: Int) throws {
        if (!self.canPlace(value, row, col)) {
            throw MyError.MyFirstError;
        }

        self.grid[row][col] = value
    }

    func canPlace(value: Int, _ row: Int, _ col: Int) -> Bool {
        return self.grid[row][col] == 0;
    }

    func tryPlace(value: Int, row: Int, col: Int) -> Bool {
        if (self.canPlace(value, row, col)) {
            try! self.place(value, row, col)
            return true;
        }
        return false;
    }

    func remove(row: Int, _ col: Int) {
        self.grid[row][col] = 0
    }

    func removeAll() {
        self.grid = Array(count: self.size, repeatedValue: Array(count: self.size, repeatedValue: 0))
    }

    private var grid: [[Int]];
}
