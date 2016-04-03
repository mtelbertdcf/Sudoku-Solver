//
//  ViewController.swift
//  Sudoku Solver
//
//  Created by David on 2/23/16.
//  Copyright © 2016 Mountainous Code LLC. All rights reserved.
//

import UIKit
import MtTools
import CoreGraphics

class ViewController: UIViewController {
    @IBOutlet weak var textInput: UITextField!
    @IBOutlet weak var buttonSolve: UIButton!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonRandom: UIButton!
    @IBOutlet weak var gridView: GridView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // initialize looks

        buttonSolve.layer.borderWidth = 1.0
        buttonSolve.layer.borderColor = UIColor.blueColor().CGColor
        buttonSolve.layer.cornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonClicked(sender: AnyObject) -> Void {
        let representation = self.textInput.text!

        switch (sender.tag) {
        case 0:
            if (representation.characters.count > 0) {
                let newGrid = Grid(representation: representation)
                self.gridView.setData(newGrid)
//
//                if let solution = Grid.solve(Grid(representation: representation)) {
//                    self.gridView.setData(solution)
//                } else {
//                    // todo: alert
//                    self.gridView.setData(Grid())
//                }
            } else {
                self.gridView.setData(Grid())
            }
            break;

        case 1:
            self.gridView.setData(Grid())
            break;

        case 2:
            self.gridView.setData(Grid.random())
            break;

        default:
            break;
        }
    }

}