//
//  ViewController.swift
//  Instagrid
//
//  Created by Dorian Dragoni on 06/05/2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var layoutOneButton: UIButton!
    @IBOutlet weak var layoutTwoButton: UIButton!
    @IBOutlet weak var layoutThreeButton: UIButton!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewFour: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGrid()
    }
    
    private func initGrid() {
        setGrid(index: 2)
    }
    
    private func setGrid(index: Int) {
        switch index {
        case 1:
            viewTwo.isHidden = true
            viewFour.isHidden = false
            layoutOneButton.setImage(UIImage(named: "Selected"), for: .normal)
            layoutTwoButton.setImage(nil, for: .normal)
            layoutThreeButton.setImage(nil, for: .normal)
            break
        case 2:
            viewTwo.isHidden = false
            viewFour.isHidden = true
            layoutOneButton.setImage(nil, for: .normal)
            layoutTwoButton.setImage(UIImage(named: "Selected"), for: .normal)
            layoutThreeButton.setImage(nil, for: .normal)
            break
        case 3:
            viewTwo.isHidden = false
            viewFour.isHidden = false
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

