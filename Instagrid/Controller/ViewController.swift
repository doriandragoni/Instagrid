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
    @IBOutlet weak var gridView: UIView!

    private lazy var imageViews: [UIImageView] = [
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

        // Use SizeClass to know if the device is in landscape mode at launch
        setSwipeTextLabel(verticalSizeClass: traitCollection.verticalSizeClass)

        let panGestureRecongnizer = UIPanGestureRecognizer(target: self, action: #selector(swipeGridView))
        gridView.addGestureRecognizer(panGestureRecongnizer)
    }

    override func willTransition(to newCollection: UITraitCollection,
                                 with coordinator: UIViewControllerTransitionCoordinator) {
        setSwipeTextLabel(verticalSizeClass: newCollection.verticalSizeClass)
    }

    private func setSwipeTextLabel(verticalSizeClass: UIUserInterfaceSizeClass) {
        switch verticalSizeClass {
        case .compact:
            swipeTextLabel.text = "Swipe left to share"
        case .regular, .unspecified:
            swipeTextLabel.text = "Swipe up to share"
        @unknown default:
            break
        }
    }

    @objc private func swipeGridView(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began, .changed:
            swipeGridViewWith(gesture: sender)
        case .cancelled, .ended:
            endSwipeGridViewWith(gesture: sender)
        default:
            break
        }
    }

    private func swipeGridViewWith(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gridView)
        if traitCollection.verticalSizeClass == .compact {
            // Check if the user swipes left only
            if translation.x < 0 {
                gridView.transform = CGAffineTransform(translationX: translation.x, y: 0)
            }
        } else {
            // Check if the user swipes up only
            if translation.y < 0 {
                gridView.transform = CGAffineTransform(translationX: 0, y: translation.y)
            }
        }
    }

    private func endSwipeGridViewWith(gesture: UIPanGestureRecognizer) {
        if traitCollection.verticalSizeClass == .compact {
            endSwipeLeftGridViewWith(gesture: gesture)
        } else {
            endSwipeUpGridViewWith(gesture: gesture)
        }
    }

    private func endSwipeLeftGridViewWith(gesture: UIPanGestureRecognizer) {
        // Check if the user swipes left only
        if gesture.translation(in: gridView).x < 0 {
            let screenWidth = UIScreen.main.bounds.width
            let targetPoint = (-screenWidth / 2) - (gridView.bounds.width / 2)
            // targetPoint is use to know when the gridView has completely disappeared
            let transform = CGAffineTransform(translationX: targetPoint, y: 0)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5,
                           options: [], animations: {
                self.gridView.transform = transform
            }, completion: { success in
                // Only when the gridView has completely disappeared, we can open the share menu
                if success {
                    self.openShareMenu(gesture: gesture)
                }
            })
        }
    }

    private func endSwipeUpGridViewWith(gesture: UIPanGestureRecognizer) {
        // Check if the user swipes up only
        if gesture.translation(in: gridView).y < 0 {
            let screenHeight = UIScreen.main.bounds.height
            let targetPoint = (-screenHeight / 2) - (gridView.bounds.height / 2)
            // targetPoint is use to know when the gridView has completely disappeared
            let transform = CGAffineTransform(translationX: 0, y: targetPoint)

            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5,
                           options: [], animations: {
                self.gridView.transform = transform
            }, completion: { success in
                // Only when the gridView has completely disappeared, we can open the share menu
                if success {
                    self.openShareMenu(gesture: gesture)
                }
            })
        }
    }

    private func openShareMenu(gesture: UIPanGestureRecognizer) {
        // Convert the gridView to an UIImage
        let renderer = UIGraphicsImageRenderer(size: gridView.bounds.size)
        let gridViewScreenshot = renderer.image { _ in
            gridView.drawHierarchy(in: gridView.bounds, afterScreenUpdates: true)
        }
        let avc = UIActivityViewController(activityItems: [gridViewScreenshot], applicationActivities: nil)
        present(avc, animated: true)
        avc.completionWithItemsHandler = { (_, _, _, _) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5,
                           animations: {
                // When the sharing is done or cancelled, and when the share menu has disappeared
                // execute the reverse animation to put back the gridView to its original location
                self.gridView.transform = .identity
            })
        }
    }

    // Protocol implementation
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
        case .two:
            pictureViewTwo.isHidden = false
            pictureViewFour.isHidden = true
            layoutOneButton.setImage(nil, for: .normal)
            layoutTwoButton.setImage(UIImage(named: "Selected"), for: .normal)
            layoutThreeButton.setImage(nil, for: .normal)
        case .three:
            pictureViewTwo.isHidden = false
            pictureViewFour.isHidden = false
            layoutOneButton.setImage(nil, for: .normal)
            layoutTwoButton.setImage(nil, for: .normal)
            layoutThreeButton.setImage(UIImage(named: "Selected"), for: .normal)
        }
        // Move the images at the right place
        moveImages()
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
        for item in itemProviders where item.canLoadObject(ofClass: UIImage.self) {
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
