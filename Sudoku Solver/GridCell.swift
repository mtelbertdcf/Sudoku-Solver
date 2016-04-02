//
// Created by David on 4/1/16.
// Copyright (c) 2016 Mountainous Code LLC. All rights reserved.
//

import Foundation
import UIKit
import MtTools

class GridCell: UIButton {
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
//
////
////    init(type: UIButtonType) {
////        super.init(type: type)
////    }

    enum ShowState {
        case Initial, Current, Solved
    }

    var currentValue: Int {
        get {
            return self._currentValue
        }
        set {
            self._currentValue = newValue
            if (showState == .Current) {
                self.setText()
            }
        }
    }

    var solvedValue: Int {
        get {
            return self._solvedValue
        }
        set {
            self._solvedValue = newValue
            if (showState == .Solved) {
                self.setText()
            }
        }

    }

    var showState: GridCell.ShowState {
        get {
            return self._showState
        }
        set {
            self._showState = newValue
            self.setText()
        }
    }

    private func setText() {
        switch (self.showState) {
            case .Initial:
                break

            case .Current:
                break

            case .Solved:
                break

        }
    }

    private var _showState = GridCell.ShowState.Initial
    private var _initialValue: Int = 0
    private var _currentValue = 0
    private var _solvedValue: Int = 0
}
