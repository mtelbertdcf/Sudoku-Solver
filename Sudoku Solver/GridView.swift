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
        self.createCells()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createCells()
    }

    func setData(grid: Grid) -> Void {
        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                let text = String(grid[Position(r, c)])
                let control = self.subviews[r * 9 + c] as! UIButton
                control.setTitle(text, forState: .Normal)
            }
        }
    }

    static let doCellClicked =
#selector(GridView.cellClicked(_:))
    static let doCellHeld =
#selector(GridView.cellHeld(_:))

    func createCells() -> Void {
        let childWidth = self.bounds.width / 9
        let childHeight = self.bounds.height / 9
        let childSize = CGSize(width: childWidth, height: childHeight)

        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                let childLocation = CGPoint(x: CGFloat(c) * childWidth, y: CGFloat(r) * childHeight)
                let childFrame = CGRect(origin: childLocation, size: childSize)
                let child = GridCell(frame: childFrame, initialValue: 0)
                child.layer.borderWidth = 1.0
                child.layer.borderColor = UIColor.blackColor().CGColor
                child.layer.cornerRadius = 4.0
                child.tag = r * 9 + c
                child.addTarget(self, action: GridView.doCellClicked, forControlEvents: .TouchUpInside)
                child.addGestureRecognizer({
                    let gr = UILongPressGestureRecognizer(target: self, action: GridView.doCellHeld)
                    gr.minimumPressDuration = 2.5
                    return gr
                }())
                if let titleLabel = child.titleLabel {
                    titleLabel.textColor = UIColor.blackColor()
                    titleLabel.font = UIFont(name: "American Typewriter", size: childHeight * 0.75)
                    titleLabel.hidden = false
                }
                self.addSubview(child)
            }
        }

        // add my grid overlay view
        let gridOverlay = Panel(frame: self.bounds, drawing: self.drawGrid)
        self.addSubview(gridOverlay)
    }

    func cellHeld(sender: UILongPressGestureRecognizer) {
        // find the button clicked on using tag assigned in createCells
        let position = Position(sender.view!.tag / 9, sender.view!.tag % 9)

        // todo: do some popup shit here

        let alert = UIAlertController(title: "foo", message: "bar", preferredStyle: .ActionSheet)
        self.window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
    }

    func cellClicked(sender: UIButton) {
        // find the button clicked on using tag assigned in createCells
        let position = Position(sender.tag / 9, sender.tag % 9)

        // clear everyone out
        subviews.forEach {
            $0.backgroundColor = UIColor.clearColor()
        }

        // "draw" row and column of cell
        for i in 0 ..< 9 {
            subviews[position.row * 9 + i].backgroundColor = UIColor.yellowColor()
            subviews[i * 9 + position.col].backgroundColor = UIColor.yellowColor()
        }

        // "draw" cell
        sender.backgroundColor = UIColor.whiteColor()
    }

    private static let _sectionDividorWidth = CGFloat(4.0)

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

