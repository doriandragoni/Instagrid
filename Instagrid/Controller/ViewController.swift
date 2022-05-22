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
    @IBOutlet weak var layoutOneButton: UIButton!
    @IBOutlet weak var layoutTwoButton: UIButton!
    @IBOutlet weak var layoutThreeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGrid()
    }
    
    private func initGrid() {
        secondViewWidthConstraint.priority = .defaultLow
        fourthViewWidthConstraint.priority = .required
        layoutOneButton.setImage(nil, for: .normal)
        layoutTwoButton.setImage(UIImage(named: "Selected"), for: .normal)
        layoutThreeButton.setImage(nil, for: .normal)
    }
    
    private func setGrid(index: Int) {
        switch index {
        case 1:
            secondViewWidthConstraint.priority = .required
            fourthViewWidthConstraint.priority = .defaultLow
            layoutOneButton.setImage(UIImage(named: "Selected"), for: .normal)
            layoutTwoButton.setImage(nil, for: .normal)
            layoutThreeButton.setImage(nil, for: .normal)
            break
        case 2:
            initGrid()
            break
        case 3:
            secondViewWidthConstraint.priority = .defaultLow
            fourthViewWidthConstraint.priority = .defaultLow
            layoutOneButton.setImage(nil, for: .normal)
            layoutTwoButton.setImage(nil, for: .normal)
            layoutThreeButton.setImage(UIImage(named: "Selected"), for: .normal)
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

