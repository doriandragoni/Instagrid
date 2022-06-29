//
//  ViewController.swift
//  Instagrid
//
//  Created by Dorian Dragoni on 06/05/2022.
//

import UIKit
import PhotosUI

class ViewController: UIViewController, DidTapOnPictureViewDelegate {
    @IBOutlet weak var swipeTextLabel: UILabel!
    @IBOutlet weak var layoutOneButton: UIButton!
    @IBOutlet weak var layoutTwoButton: UIButton!
    @IBOutlet weak var layoutThreeButton: UIButton!
    @IBOutlet weak var pictureViewOne: PictureView!
    @IBOutlet weak var pictureViewTwo: PictureView!
    @IBOutlet weak var pictureViewThree: PictureView!
    @IBOutlet weak var pictureViewFour: PictureView!

    lazy var imageViews: [UIImageView] = [
        pictureViewOne.imageView,
        pictureViewTwo.imageView,
        pictureViewThree.imageView,
        pictureViewFour.imageView
    ]

    private var gridLayout: GridLayout = .two
    private var imageManager: ImageManager = .init()
    private var tappedPictureView: PictureView?
    private var picker: PHPickerViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        initGrid()
        initPicker()
        // Use SizeClass to know if the device is in landscape mode or not at launch
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

    func didTapOnPictureView(pictureView: PictureView) {
        tappedPictureView = pictureView
        showPicker()
    }

    private func initPicker() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .automatic
        picker = PHPickerViewController(configuration: configuration)
        if let picker = picker {
            picker.delegate = self
        }
    }

    private func showPicker() {
        if let picker = picker {
            present(picker, animated: true)
        }
    }

    private func initGrid() {
        setGrid(layout: .two)
    }

    private func setGrid(layout: GridLayout) {
        gridLayout = layout
        switch layout {
        case .one:
            pictureViewTwo.isHidden = true
            pictureViewFour.isHidden = false
            layoutOneButton.setImage(UIImage(named: "Selected"), for: .normal)
            layoutTwoButton.setImage(nil, for: .normal)
            layoutThreeButton.setImage(nil, for: .normal)
            moveImages()
        case .two:
            pictureViewTwo.isHidden = false
            pictureViewFour.isHidden = true
            layoutOneButton.setImage(nil, for: .normal)
            layoutTwoButton.setImage(UIImage(named: "Selected"), for: .normal)
            layoutThreeButton.setImage(nil, for: .normal)
            moveImages()
        case .three:
            pictureViewTwo.isHidden = false
            pictureViewFour.isHidden = false
            layoutOneButton.setImage(nil, for: .normal)
            layoutTwoButton.setImage(nil, for: .normal)
            layoutThreeButton.setImage(UIImage(named: "Selected"), for: .normal)
            moveImages()
        }
    }

    private func moveImages() {
        imageManager.moveImages(gridLayout: gridLayout, imageViews: imageViews)
    }

    @IBAction func onLayoutOneTapped() {
        if gridLayout != .one {
            setGrid(layout: .one)
        }
    }

    @IBAction func onLayoutTwoTapped() {
        if gridLayout != .two {
            setGrid(layout: .two)
        }
    }

    @IBAction func onLayoutThreeTapped() {
        if gridLayout != .three {
            setGrid(layout: .three)
        }
    }
}

extension ViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        let itemProviders = results.map(\.itemProvider)
        for item in itemProviders {
            if item.canLoadObject(ofClass: UIImage.self) {
                item.loadObject(ofClass: UIImage.self) { (picture, _) in
                    DispatchQueue.main.async {
                        if let picture = picture as? UIImage,
                           let tappedPictureView = self.tappedPictureView {
                            tappedPictureView.setPicture(picture: picture)
                            if let index = self.gridLayout.getImageIndex(byPictureViewTag: tappedPictureView.tag) {
                                self.imageManager.add(image: picture, for: index)
                            }
                        }
                    }
                }
            }
        }
    }
}
