//
// Created by David on 4/1/16.
// Copyright (c) 2016 Mountainous Code LLC. All rights reserved.
//

import Foundation
import UIKit
import MtTools

class GridCell: UIButton {
    required init?(coder: NSCoder) {
        self._identifier = Position(0, 0)
        super.init(coder: coder)
    }

    init(frame: CGRect, identifier: Position) {
        self._identifier = identifier
        super.init(frame: frame)

        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.blackColor().CGColor
        self.layer.cornerRadius = 4.0

        if let label = self.titleLabel {
            label.textColor = UIColor.blackColor()
            label.textColor = UIColor.blackColor()
            label.font = UIFont(name: "American Typewriter", size: self.bounds.height * 0.75)
            label.hidden = false
        }
    }

    var identifier: Position {
        get {
            return _identifier
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
        }
    }

    private var _identifier: Position
}
