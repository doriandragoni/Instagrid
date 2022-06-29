//
//  MyImages.swift
//  Instagrid
//
//  Created by Dorian Dragoni on 15/06/2022.
//

import Foundation
import UIKit

class ImageManager {
    private var images = [Int: UIImage]()

    func add(image: UIImage, for key: Int) {
        images[key] = image
    }

    func get(_ key: Int) -> UIImage? {
        return images[key]
    }

    func moveImages(gridLayout: GridLayout, imageViews: [UIImageView]) {
        switch gridLayout {
        case .one:
            imageViews[0].image = get(0)
            imageViews[2].image = get(1)
            imageViews[3].image = get(2)
        case .two:
            imageViews[0].image = get(0)
            imageViews[1].image = get(1)
            imageViews[2].image = get(2)
        case .three:
            imageViews[0].image = get(0)
            imageViews[1].image = get(1)
            imageViews[2].image = get(2)
            imageViews[3].image = get(3)
        }
    }
}
