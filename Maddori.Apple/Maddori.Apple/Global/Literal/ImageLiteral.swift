//
//  ImageLiteral.swift
//  Maddori.Apple
//
//  Created by Mingwan Choi on 2022/10/14.
//

import UIKit

enum ImageLiterals {
    
    // MARK: - icon
    
    static var icClose: UIImage { .load(systemName: "xmark") }
    static var icBack: UIImage { .load(systemName: "chevron.left") }
    static var icWarning: UIImage { .load(systemName: "exclamationmark.circle.fill") }
}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        image.accessibilityIdentifier = name
        return image
    }
    
    static func load(systemName: String) -> UIImage {
        guard let image = UIImage(systemName: systemName) else {
            return UIImage()
        }
        image.accessibilityIdentifier = systemName
        return image
    }
}

