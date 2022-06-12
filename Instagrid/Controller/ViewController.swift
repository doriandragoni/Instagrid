//
//  ViewController.swift
//  Instagrid
//
//  Created by Dorian Dragoni on 06/05/2022.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, DidTapOnPictureDelegate {
    @IBOutlet weak var swipeTextLabel: UILabel!
    @IBOutlet weak var layoutOneButton: UIButton!
    @IBOutlet weak var layoutTwoButton: UIButton!
    @IBOutlet weak var layoutThreeButton: UIButton!
    @IBOutlet weak var pictureViewOne: PictureView!
    @IBOutlet weak var pictureViewTwo: PictureView!
    @IBOutlet weak var pictureViewThree: PictureView!
    @IBOutlet weak var pictureViewFour: PictureView!
    
    var selectedLayout = 2
    var tappedPictureView: PictureView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initGrid()
        // Use SizeClass to know if the device is in landscape mode or not
        if traitCollection.verticalSizeClass == .compact {
            changeSwipeTextLabel(deviceOrientation: .landscapeLeft)
        }
    }
    
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        changeSwipeTextLabel(deviceOrientation: toInterfaceOrientation)
    }
    
    private func changeSwipeTextLabel(deviceOrientation: UIInterfaceOrientation) {
        switch deviceOrientation {
        case .portrait:
            swipeTextLabel.text = "Swipe up to share"
        case .landscapeLeft, .landscapeRight:
            swipeTextLabel.text = "Swipe left to share"
        case .portraitUpsideDown, .unknown:
            break
        @unknown default:
            break
        }
    }
    
    func didTapOnPicture(picture: PictureView) {
        tappedPictureView = picture
        presentPicker()
    }
    
    private func initGrid() {
        setGrid(index: 2)
    }
    
    private func presentPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .automatic
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    private func setGrid(index: Int) {
        switch index {
        case 1:
            pictureViewTwo.isHidden = true
            pictureViewFour.isHidden = false
            layoutOneButton.setImage(UIImage(named: "Selected"), for: .normal)
            layoutTwoButton.setImage(nil, for: .normal)
            layoutThreeButton.setImage(nil, for: .normal)
            
            // Move pictures
            pictureViewFour.imageView.image = pictureViewThree.imageView.image
            pictureViewThree.imageView.image = pictureViewTwo.imageView.image
            pictureViewTwo.removePicture()
        case 2:
            pictureViewTwo.isHidden = false
            pictureViewFour.isHidden = true
            layoutOneButton.setImage(nil, for: .normal)
            layoutTwoButton.setImage(UIImage(named: "Selected"), for: .normal)
            layoutThreeButton.setImage(nil, for: .normal)
            
            // Move pictures
            if pictureViewTwo.imageView.image == nil {
                pictureViewTwo.imageView.image = pictureViewThree.imageView.image
                pictureViewThree.imageView.image = pictureViewFour.imageView.image
            }
            pictureViewFour.removePicture()
        case 3:
            pictureViewTwo.isHidden = false
            pictureViewFour.isHidden = false
            layoutOneButton.setImage(nil, for: .normal)
            layoutTwoButton.setImage(nil, for: .normal)
            layoutThreeButton.setImage(UIImage(named: "Selected"), for: .normal)
            
            // Move pictures
            if pictureViewTwo.imageView.image == nil {
                pictureViewTwo.imageView.image = pictureViewThree.imageView.image
                pictureViewThree.imageView.image = pictureViewFour.imageView.image
            }
            pictureViewFour.removePicture()
        default:
            initGrid()
        }
    }
    
    @IBAction func onLayoutOneTapped() {
        if selectedLayout != 1 {
            selectedLayout = 1
            setGrid(index: 1)
        }
    }
    
    @IBAction func onLayoutTwoTapped() {
        if selectedLayout != 2 {
            selectedLayout = 2
            setGrid(index: 2)
        }
    }
    
    @IBAction func onLayoutThreeTapped() {
        if selectedLayout != 3 {
            selectedLayout = 3
            setGrid(index: 3)
        }
    }
}

extension ViewController: PHPickerViewControllerDelegate  {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        let itemProviders = results.map(\.itemProvider)
        for item in itemProviders {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { (picture, error) in
                    DispatchQueue.main.async {
                        if let picture = picture as? UIImage {
                            self.tappedPictureView?.setPicture(picture: picture)
                        }
                    }
                }
            }
        }
    }
}
