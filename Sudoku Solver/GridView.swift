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
        self.grid = Grid()
        super.init(coder: coder)
        self.createChildren()
    }

    func setData(grid: Grid) -> Void {
        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                let position = Position(r, c)
                let cell = self.subviews[9 * r + c] as! GridCell
                cell.displayedValue = grid[position]
            }
        }
        self.grid = grid
    }

    static let doCellClicked =
#selector(GridView.cellClicked(_:))
    static let doCellHeld =
#selector(GridView.cellHeld(_:))

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
                child.addTarget(self, action: GridView.doCellClicked, forControlEvents: .TouchUpInside)
                child.addGestureRecognizer({
                    let gr = UILongPressGestureRecognizer(target: self, action: GridView.doCellHeld)
                    gr.minimumPressDuration = 2.0
                    return gr
                }())

                self.addSubview(child)
            }
        }

        // add my grid overlay view
        let gridOverlay = Panel(frame: self.bounds, drawing: self.drawGrid)
        self.addSubview(gridOverlay)
    }

    func cellClicked(sender: GridCell) {
        // clear everyone out
        subviews.forEach {
            $0.backgroundColor = UIColor.clearColor()
        }

        // "draw" row and column of cell
        for i in 0 ..< 9 {
            subviews[sender.identifier.row * 9 + i].backgroundColor = UIColor.yellowColor()
            subviews[i * 9 + sender.identifier.col].backgroundColor = UIColor.yellowColor()
        }

        // "draw" cell
        sender.backgroundColor = UIColor.whiteColor()
    }

    func cellHeld(sender: UILongPressGestureRecognizer) {
        // find the button clicked on using tag assigned in createCells
        guard let gridCell = sender.view as? GridCell else {
            return
        }

        // todo: do some popup shit here

        let alert = UIAlertController(title: "foo", message: "bar", preferredStyle: .ActionSheet)

        let possibilities = self.grid.getPossiblePlacements(gridCell.identifier)
        for i in 0 ..< possibilities.count {
            alert.addAction(UIAlertAction(title: String(possibilities[i]), style: .Default, handler: nil))
        }

        self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }

    private static let _sectionDividorWidth = CGFloat(4.0)
    private var grid: Grid

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

