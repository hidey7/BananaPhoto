//
//  AddFruits.swift
//  BananaPhoto
//
//  Created by 始関秀弥 on 2022/06/28.
//

import Foundation
import UIKit

class AddFruits {
    
    static let shared = AddFruits()
    private init() {
        
    }
    
    public func addFruits(imgView: UIImageView, fruitName: String) {
        
        let width = imgView.frame.width
        let height = imgView.frame.height
        let imgHeight = height / 5
        var imgWidth = CGFloat() //(width / height) * 5
        
        if width == height {
            imgWidth = imgHeight
        } else {
            imgWidth = width / 5
        }
        
        
        for i in 0..<5 {
            for j in 0..<5 {
                
                if (i % 2 == 0 && j % 2 == 0) || (i % 2 == 1 && j % 2 == 1) {
                    let fruit = UIImageView(image: UIImage(named: fruitName))
                    fruit.contentMode = .scaleAspectFit
                    imgView.addSubview(fruit)
                    
                    
                    fruit.frame = CGRect(x: CGFloat(i) * imgWidth, y: CGFloat(j) * imgHeight, width: imgWidth, height: imgHeight)
                    fruit.transform = CGAffineTransform(rotationAngle: Double.pi / 180 * Double.random(in: 0...360))
                }
                
            }
            
        }
    }
    
}
