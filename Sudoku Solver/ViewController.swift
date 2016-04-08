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
    @IBOutlet weak var buttonInput: UIButton!
    @IBOutlet weak var buttonClear: UIButton!
    @IBOutlet weak var buttonRandom: UIButton!
    @IBOutlet weak var gridView: GridView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.alert = MCAlert(self)

        // initialize looks

        buttonInput.layer.borderWidth = 1.0
        buttonInput.layer.borderColor = UIColor.blueColor().CGColor
        buttonInput.layer.cornerRadius = 5.0

        self.textInput.text = self.evilPuzzle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonClicked(sender: AnyObject) -> Void {
        let representation = self.textInput.text!

        switch (sender.tag) {
            case 0: // Input button
                if (representation.characters.count > 0) {
                    if let newGrid = Grid(representation: representation) {
                        self.gridView.originalGrid = newGrid
                    }
                } else {
                    self.gridView.originalGrid = Grid()
                }
                break

            case 1:     // Clear button
                self.gridView.originalGrid = Grid()
                break

            case 2:     // Random button
                self.gridView.originalGrid = Grid.random()
                break

            case 3:     // Solve button
                if (self.gridView.solvedGrid == nil) {
                    alert.message("Puzzle cannot be solved")
                } else {
                    gridView.currentGrid = self.gridView.solvedGrid!
                }
                break

            case 4:     // Check button
                self.gridView.check()
                break

            default:
                break
        }
    }

    private var alert: MCAlert!

    private let evilPuzzle =
    "000000000" +
            "590102370" +
            "000036010" +
            "305000460" +
            "000000000" +
            "064000203" +
            "030790000" +
            "072804039" +
            "000000000"

}