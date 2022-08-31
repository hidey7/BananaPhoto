//
//  UIImage-Extension.swift
//  BananaPhoto
//
//  Created by 始関秀弥 on 2022/08/31.
//

import Foundation
import UIKit

extension UIImage {
    
    func composite(image: UIImage) -> UIImage? {
        
        let cellWidth = self.size.width / 5
        let cellHeight = self.size.height / 5
        var fruitWidth = CGFloat()
        var fruitHeight = CGFloat()
        var rotatedImage = [[UIImage]]()
        
        rotatedImage = setImage(image)
        
        if cellWidth < cellHeight {
            fruitWidth = cellWidth
            fruitHeight = fruitWidth
        } else if cellWidth > cellHeight {
            fruitHeight = cellHeight
            fruitWidth = fruitHeight
        } else if cellWidth == cellHeight {
            fruitWidth = cellWidth
            fruitHeight = fruitWidth
        }
        
        var rect = CGRect()
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        
        for i in 0..<5 {
            for j in 0..<5 {
                if (i % 2 == 0 && j % 2 == 0) || (i % 2 == 1 && j % 2 == 1) {
                    if self.size.width < self.size.height {
                        rect = CGRect(x: CGFloat(i * Int(cellWidth)),
                                      y: CGFloat(j * Int(cellHeight)) + CGFloat((cellHeight - cellWidth) / 2),
                                      width: fruitWidth,
                                      height: fruitHeight)
                    } else if self.size.width > self.size.height {
                        rect = CGRect(x: CGFloat(i *  Int(cellWidth)) + CGFloat((cellWidth - cellHeight) / 2),
                                      y: CGFloat(j * Int(cellHeight)),
                                      width: fruitWidth,
                                      height: fruitHeight)
                        
                    } else if self.size.width == self.size.height {
                        rect = CGRect(x: CGFloat(i) * cellWidth,
                                      y: CGFloat(j) * cellHeight,
                                      width: fruitWidth,
                                      height: fruitHeight)
                    }
                    rotatedImage[i][j].draw(in: rect)
                }
            }
        }
        
        
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    fileprivate func setImage(_ image: UIImage) -> [[UIImage]] {
        var imageArray : [[UIImage]] = [[UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),],
                                        [UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),],
                                        [UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),],
                                        [UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),],
                                        [UIImage(),UIImage(),UIImage(),UIImage(),UIImage(),]]
        
        for i in 0..<5 {
            for j in 0..<5 {
                if (i % 2 == 0 && j % 2 == 0) || (i % 2 == 1 && j % 2 == 1) {
                    imageArray[i][j] = rotateImage(image)
                }
            }
        }
        
        return imageArray
    }
    
    fileprivate func rotateImage(_ image: UIImage) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(image.size, false, 1.0)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: image.size.width / 2, y: image.size.height / 2)
        context?.rotate(by: CGFloat(Float.pi / 180 * Float.random(in: 0...360)))
        context?.draw(image.cgImage!, in: CGRect(x: -(image.size.width / 2), y: -(image.size.height / 2), width: image.size.width * 0.9, height: image.size.height * 0.9))
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rotatedImage!
    }
}
