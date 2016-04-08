//
//  GridView.swift
//  CustomControl
//
//  Created by David on 3/28/16.
//  Copyright © 2016 mtelbertdcf. All rights reserved.
//

import UIKit
import MtTools

class GridView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.createChildren()
    }

    private var _originalGrid: Grid! = nil
    var originalGrid: Grid {
        get {
            return self._originalGrid
        }
        set {
            self._originalGrid = newValue
            self._currentGrid = Grid(grid: self.originalGrid)
            self._solvedGrid = nil
            self.solutionSearched = false
            NSThread.detachNewThreadSelector(#selector(GridView.solverThreadEntry(_:)), toTarget: self, withObject: newValue)
            displayGrid()
        }
    }

    var _solvedGrid: Grid! = nil
    var solvedGrid: Grid! {
        get {
            getSolution()
            return self._solvedGrid
        }
    }

    var _currentGrid: Grid! = nil
    var currentGrid: Grid! {
        get {
            return self._currentGrid
        }
        set {
            self._currentGrid = newValue
            self.displayGrid()
        }
    }

    static let doCellClicked =
#selector(GridView.cellTapped(_:))
    static let doCellDoubleTapped =
#selector(GridView.cellDoubleTapped(_:))
    static let doCellHeld =
#selector(GridView.cellHeld(_:))

    func check() -> Bool {
        cells.forEach({
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.blackColor().CGColor
        })

        getSolution()
        let badCells = self.currentGrid.getClosedPositions()
            .filter({ return self.currentGrid[$0] != self.solvedGrid[$0] })
            .map({ return self.cellAt(self.currentGrid, position: $0) })

        for cell in badCells {
            cell.layer.borderColor = UIColor.redColor().CGColor
            cell.layer.borderWidth = 3.0
        }

        return badCells.count > 0
    }

    func createChildren() -> Void {
        let childWidth = self.bounds.width / 9
        let childHeight = self.bounds.height / 9
        let childSize = CGSize(width: childWidth, height: childHeight)

        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                let childLocation = CGPoint(x: CGFloat(c) * childWidth, y: CGFloat(r) * childHeight)
                let childFrame = CGRect(origin: childLocation, size: childSize)
                let child = GridCell(frame: childFrame, identifier: Position(r, c))

                // "event" handler setup. iOS has at least 13 ways to do events, so let's try a few here
                //child.addTarget(self, action: GridView.doCellClicked, forControlEvents: .TouchUpInside)
                let doubleTap = UITapGestureRecognizer(target: self, action: GridView.doCellDoubleTapped)
                doubleTap.numberOfTapsRequired = 2
                child.addGestureRecognizer(doubleTap)
                let singleTap = UITapGestureRecognizer(target: self, action: GridView.doCellClicked)
                singleTap.numberOfTapsRequired = 1
                singleTap.requireGestureRecognizerToFail(doubleTap)
                child.addGestureRecognizer(singleTap)
                let held = UILongPressGestureRecognizer(target: self, action: GridView.doCellHeld)
                held.minimumPressDuration = 1.0
                child.addGestureRecognizer(held)

                self.addSubview(child)
            }
        }

        // add my grid overlay view
        let gridOverlay = Panel(frame: self.bounds, drawing: self.drawGrid)
        self.addSubview(gridOverlay)
    }

    func cellTapped(sender: UITapGestureRecognizer) {
        guard let gridCell = sender.view as? GridCell else {
            //where sender.state == .Began else {
            return
        }

        // clear everyone out
        cells.forEach {
            $0.backgroundColor = UIColor.clearColor()
        }

        // "draw" row and column of cell
        for i in 0 ..< 9 {
            // a decent dark yellow color
            cells[gridCell.identifier.row * 9 + i].backgroundColor = UIColor(colorLiteralRed: 160.0 / 255.0, green: 120.0 / 255.0, blue: 0.0, alpha: 0.5)
            cells[i * 9 + gridCell.identifier.col].backgroundColor = UIColor(colorLiteralRed: 160.0 / 255.0, green: 120.0 / 255.0, blue: 0.0, alpha: 0.5)
            // UIColor.yellowColor()
        }

        // "draw" cell
        gridCell.backgroundColor = UIColor.grayColor()
    }

    var cells: [GridCell]
    {
        return self.subviews.filter({ $0 is GridCell }) as! [GridCell]
    }

    func cellDoubleTapped(sender: UITapGestureRecognizer) {
        guard let gridCell = sender.view as? GridCell else {
            return
        }

        let possibilities = self.currentGrid.getPossiblePlacements(gridCell.identifier)
        if (possibilities.count > 0) {
            let alert = UIAlertController(title: "Select Piece", message: "Possible Values", preferredStyle: .ActionSheet)
            for i in 0 ..< possibilities.count {
                alert.addAction(UIAlertAction(title: String(possibilities[i]), style: .Default, handler: {
                    let value = Int($0.title!)!
                    if (self.currentGrid.tryPlace(value, position: gridCell.identifier)) {
                        gridCell.displayedValue = value
                    }
                }))
            }

            alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: {
                _ in
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))

            self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
        } else {
            self.currentGrid.remove(gridCell.identifier)
            gridCell.displayedValue = 0
        }
    }

    func cellHeld(sender: UILongPressGestureRecognizer) {
        guard let gridCell = sender.view as? GridCell where sender.state == .Began else {
            return
        }

        getSolution()
        currentGrid.remove(gridCell.identifier)
        currentGrid.tryPlace(solvedGrid[gridCell.identifier], position: gridCell.identifier)
        gridCell.displayedValue = currentGrid[gridCell.identifier]
    }

    func displayGrid() {
        // now populate all cells from current data
        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                let position = Position(r, c)
                let cell = self.subviews[9 * r + c] as! GridCell
                cell.displayedValue = self.currentGrid[position]
            }
        }
        self.setNeedsDisplay()
    }

    private static let _sectionDividorWidth = CGFloat(4.0)

    private var solving: NSCondition = NSCondition()
    private var solutionSearched = false

    func getSolution() {
        self.solving.lock()

        defer {
            self.solving.unlock()
        }

        while (!self.solutionSearched) {
            self.solving.wait()
        }
    }

    @objc func solverThreadEntry(grid: Grid) {
        self.solving.lock()

        defer {
            self.solving.unlock()
        }

        self._solvedGrid = Grid.solve(grid)
        self.solutionSearched = true
        self.solving.signal()
    }

    private func cellAt(grid: Grid, position: Position) -> GridCell {
        return subviews[position.row * 9 + position.col] as! GridCell
    }



    // to draw my subview grid
    func drawGrid(rect: CGRect) {
        let gc = GraphicsContext()

        gc.lineColor = UIColor.blackColor()
        gc.width = GridView._sectionDividorWidth

        let thirdWidth = rect.width / 3
        let thirdHeight = rect.height / 3

        gc.moveTo(thirdWidth, 0)
        .lineTo(thirdWidth, rect.height)
        .moveTo(thirdWidth * 2, 0)
        .lineTo(thirdWidth * 2, rect.height)
        .moveTo(0, thirdHeight)
        .lineTo(rect.width, thirdHeight)
        .moveTo(0, thirdHeight * 2)
        .lineTo(rect.width, thirdHeight * 2)
        .stroke()
    }

}

