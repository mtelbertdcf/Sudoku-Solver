//
// Created by David on 4/1/16.
// Copyright (c) 2016 Mountainous Code LLC. All rights reserved.
//

import Foundation
import UIKit
import MtTools

// TODO: Why are all my text labels white? I've tried several ways to set it to no avail

class GridCell: UIButton {
    required init?(coder: NSCoder) {
        self._identifier = Position(0, 0)
        super.init(coder: coder)
    }

    /**
        Initializes a new GridViwe at the given position and with the given identifier

        - Parameters:
            - frame: the location of this view
            - identifier: the identifier (as a position) for this view

    */
    init(frame: CGRect, identifier: Position) {
        self._identifier = identifier
        super.init(frame: frame)

        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius = 4.0

        if let label = self.titleLabel {
            label.textColor = UIColor.blackColor()
            print(label.textColor.debugDescription)
            label.font = UIFont(name: "American Typewriter", size: self.bounds.height * 0.75)
            label.hidden = false
        }
    }


    var identifier: Position {
        get {
            return self._identifier
        }
    }

    var displayedValue: Int {
        get {
            if let labelText = self.titleLabel?.text {
                return Int(labelText) ?? 0
            } else {
                return 0
            }
        }
        set {
            self.setTitle(String(newValue), forState: .Normal)
//            self.titleLabel?.textColor = UIColor.blackColor()
//            self.setNeedsDisplay()
        }
    }

    private var _identifier: Position
}
