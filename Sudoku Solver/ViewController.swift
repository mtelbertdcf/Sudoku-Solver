//
//  ViewController.swift
//  Sudoku Solver
//
//  Created by David on 2/23/16.
//  Copyright © 2016 Mountainous Code LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var textFeildGrid: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func buttonSolveClicked(sender: AnyObject) -> Void {
        let alert = UIAlertController(title: "Solve", message: "You want to solve the puzzle!", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)

        var grid = Grid(representation: self.textFeildGrid.text, autoFill: false)
        grid = Grid.solve(grid)!
        self.textFeildGrid.text = grid.toString()
    }
}