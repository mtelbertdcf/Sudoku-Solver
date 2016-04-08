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
            case 0:
                if (representation.characters.count > 0) {
                    if let newGrid = Grid(representation: representation) {
                        self.gridView.grid = newGrid
                        self.solution = nil
                        self.solutionSearched = false
                        // todo: this next bit won't do, because the grid passed in to solve is "frozen" at this point
                        NSThread.detachNewThreadSelector(#selector(ViewController.solverThreadEntry(_:)), toTarget: self, withObject: newGrid)
                    }
                } else {
                    self.gridView.grid = Grid()
                }
                break

            case 1:
                self.gridView.grid = Grid()
                break

            case 2:
                self.gridView.grid = Grid.random()
                break

            case 3:
                getSolution()
                if (solution == nil) {
                    alert.message("Puzzle cannot be solved")
                } else {
                    self.gridView.grid = solution
                }

                break

            default:
                break
        }
    }

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

        self.solution = Grid.solve(grid)
        self.solutionSearched = true
        self.solving.signal()
    }

    private var alert: MCAlert!

    private var solving: NSCondition = NSCondition()
    private var solution: Grid!
    private var solutionSearched = false

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