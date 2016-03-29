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

class ViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var textFieldGrid: UITextView!
    @IBOutlet weak var buttonSolve: UIButton!
    @IBOutlet weak var gridView: GridView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        self.textFieldGrid.delegate = self

        // initialize looks

        buttonSolve.layer.borderWidth = 1.0
        buttonSolve.layer.borderColor = UIColor.blueColor().CGColor
        buttonSolve.layer.cornerRadius = 5.0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonSolveClicked(sender: AnyObject) -> Void {

        self.gridView.setData(Grid.solve(Grid(representation: self.textFieldGrid.text))!)
    }

    // UITextViewDelegate

    func textViewDidBeginEditing(textView: UITextView) {
    }

}