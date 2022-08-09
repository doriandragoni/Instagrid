//
//  GridLayout.swift
//  Instagrid
//
//  Created by Dorian Dragoni on 17/06/2022.
//

import Foundation

enum GridLayout {
    case one, two, three

    func getImageIndex(byPictureViewTag tag: Int) -> Int? {
        switch tag {
        case 1:
            return 0
        case 2:
            return 1
        case 3:
            switch self {
            case .one:
                return 1
            default:
                return 2
            }
        case 4:
            switch self {
            case .one:
                return 2
            case .three:
                return 3
            default:
                return nil
            }
        default:
            return nil
        }
    }
}
