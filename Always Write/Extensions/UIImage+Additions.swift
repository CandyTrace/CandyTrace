//
//  UIImage+Additions.swift
//  Always Write
//
//  Created by Sam Raudabaugh on 3/11/17.
//  Copyright © 2017 Cornell Tech. All rights reserved.
//

import UIKit

extension UIImage {
    /**
     Resizes the image to a `newSize`.
     - Parameter newSize: The size to resize the image to.
     - Returns: A new `UIImage` that has been resized.
     */
    public func resize(_ newSize: CGSize) -> UIImage {
        // start a context
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        
        // draw the image in the context
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        
        // get the image from the context
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        // end the context
        UIGraphicsEndImageContext()
        
        // return the new UIImage
        return result!
    }
    
    func fillCount(bitmapInfo: UInt32) -> Int {
        let colors = self.getColors(bitmapInfo: bitmapInfo)
        return colors.filter({ ($0 as! UIColor).cgColor.components! != [0.0, 0.0, 0.0, 1.0] })
            .map{ colors.count(for: $0) }
            .reduce(0, +)
    }
    
    private func getColors(bitmapInfo: UInt32) -> NSCountedSet {
        print("\(self.size.width), \(self.size.height)")
        // get the ratio of width to height
        let ratio = self.size.width/self.size.height
        
        // calculate new r_width and r_height
        let r_width: CGFloat = 100
        let r_height: CGFloat = r_width/ratio
        
        // resize the image to the new r_width and r_height
        let cgImage = self.resize(CGSize(width: r_width, height: r_height)).cgImage
        
        // get the width and height of the new image
        let width = cgImage?.width
        let height = cgImage?.height
        
        // get the colors from the image
        let bytesPerPixel: Int = 4
        let bytesPerRow: Int = width! * bytesPerPixel
        let bitsPerComponent: Int = 8
        
        // color detection
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let raw = malloc(width! * height! * bytesPerPixel)
        let ctx = CGContext(data: raw, width: width!, height: height!, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo)
        let rect = CGRect(x: 0, y: 0, width: CGFloat(width!), height: CGFloat(height!))
        ctx?.clear(rect)
        ctx?.draw(cgImage!, in: rect)
        
        let data =  ctx?.data
        let imageColors = NSCountedSet(capacity: width! * height!)
        
        // color detection
        for x in 0..<width! {
            for y in 0..<height! {
                let pixel = ((width! * y) + x) * bytesPerPixel
                
                let color = UIColor(
                    red: round(CGFloat(data!.load(fromByteOffset: pixel + 1, as: UInt8.self)) / 255 * 120) / 120,
                    green: round(CGFloat(data!.load(fromByteOffset: pixel + 2, as: UInt8.self)) / 255 * 120) / 120,
                    blue: round(CGFloat(data!.load(fromByteOffset: pixel + 3, as: UInt8.self)) / 255 * 120) / 120,
                    alpha: 1
                )
                
                
                imageColors.add(color)
            }
        }
        free(raw)
        
        return imageColors
    }
}

extension UIView {
    func imageByRenderingView() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
