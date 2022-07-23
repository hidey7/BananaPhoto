//
//  UIView-Extension.swift
//  BananaPhoto
//
//  Created by 始関秀弥 on 2022/04/23.
//

import Foundation
import UIKit

extension UIViewController {
    
    func gradation(_ view: UIView, _ topColor: UIColor, _ bottomColor: UIColor) {
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.frame = view.bounds
        
        view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
}
