//
//  ViewController.swift
//  Instagrid
//
//  Created by Dorian Dragoni on 06/05/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var secondViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var fourthViewWidthConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGrid()
    }
    
    private func initGrid() {
        secondViewWidthConstraint.priority = .defaultLow
        fourthViewWidthConstraint.priority = .required
    }
    
    private func setGrid(index: Int) {
        switch index {
        case 1:
            secondViewWidthConstraint.priority = .required
            fourthViewWidthConstraint.priority = .defaultLow
            break
        case 2:
            initGrid()
            break
        case 3:
            secondViewWidthConstraint.priority = .defaultLow
            fourthViewWidthConstraint.priority = .defaultLow
            break
        default:
            initGrid()
            break
        }
    }

    @IBAction func onLayoutOneTapped() {
        setGrid(index: 1)
    }
    
    @IBAction func onLayoutTwoTapped() {
        setGrid(index: 2)
    }
    
    @IBAction func onLayoutThreeTapped() {
        setGrid(index: 3)
    }
}

