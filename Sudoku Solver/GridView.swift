//
//  GridView.swift
//  CustomControl
//
//  Created by David on 3/28/16.
//  Copyright © 2016 mtelbertdcf. All rights reserved.
//

import UIKit

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

    func createCells() -> Void {
        let childWidth = self.bounds.width / 9
        let childHeight = self.bounds.height / 9
        let childSize = CGSize(width: childWidth, height: childHeight)

        for r in 0 ..< 9 {
            for c in 0 ..< 9 {
                let childLocation = CGPoint(x: CGFloat(c) * childWidth, y: CGFloat(r) * childHeight)
                let child = UIButton(type: UIButtonType.RoundedRect)
                self.addSubview(child)
                child.frame = CGRect(origin: childLocation, size: childSize)
                child.layer.borderWidth = 1.0
                child.layer.borderColor = UIColor.blackColor().CGColor
                child.layer.cornerRadius = 4.0
                child.tag = r * 9 + c
                child.addTarget(self, action: #selector(GridView.cellClicked(_:)), forControlEvents: .TouchUpInside)
                if let titleLabel = child.titleLabel {
                    titleLabel.textColor = UIColor.blackColor()
                    titleLabel.font = titleLabel.font.fontWithSize(childHeight * 0.75)
                    titleLabel.hidden = false
                }

            }
        }

        self.setData(Grid())
    }

    func cellClicked(sender: UIButton) {
        let position = Position(sender.tag / 9, sender.tag % 9)

        subviews.forEach {
            $0.backgroundColor = UIColor.clearColor()
        }

        for i in 0 ..< 9 {
            subviews[position.row * 9 + i].backgroundColor = UIColor.yellowColor()
            subviews[i * 9 + position.col].backgroundColor = UIColor.yellowColor()
        }

        sender.backgroundColor = UIColor.whiteColor()
    }

    private static let _sectionDividorWidth = CGFloat(4.0)


    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
        let context = UIGraphicsGetCurrentContext()!
        CGContextSetStrokeColorWithColor(context, UIColor.blackColor().CGColor)
        CGContextSetLineWidth(context, GridView._sectionDividorWidth)

        let thirdWidth = self.bounds.width / 3
        let thirdHeight = self.bounds.height / 3

        CGContextMoveToPoint(context, thirdWidth, 0)
        CGContextAddLineToPoint(context, thirdWidth, self.bounds.height)

        CGContextMoveToPoint(context, thirdWidth * 2, 0)
        CGContextAddLineToPoint(context, thirdWidth * 2, self.bounds.height)

        CGContextMoveToPoint(context, 0, thirdHeight)
        CGContextAddLineToPoint(context, self.bounds.width, thirdHeight)

        CGContextMoveToPoint(context, 0, thirdHeight * 2)
        CGContextAddLineToPoint(context, self.bounds.width, thirdHeight * 2)


        CGContextStrokePath(context)
    }

}
