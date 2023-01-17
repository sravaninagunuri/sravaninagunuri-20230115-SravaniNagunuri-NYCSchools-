//
//  UIView+Extension.swift
//  20230115-SravaniNagunuri-NYCSchools
//
//  Created by Sravani Nagunuri (contractor) on 1/15/23.
//

import UIKit

extension UIView {
    
    /// display card shape with corner radius and shadow
    /// - Parameter radius: CGFloat
    func cardView(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 3.0
    }
}
