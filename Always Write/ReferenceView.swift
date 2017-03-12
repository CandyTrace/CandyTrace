//
//  ReferenceView.swift
//  Always Write
//
//  Created by Sam Raudabaugh on 3/11/17.
//  Copyright © 2017 Cornell Tech. All rights reserved.
//

import UIKit

class ReferenceView: UIView {
    var shape = "E" {
        didSet {
            setNeedsDisplay()
        }
    }
    var shapeLayer: CAShapeLayer?
    var bezierPath: UIBezierPath?

    override func draw(_ rect: CGRect) {
        
        let font = UIFont(name: "Futura", size: 479)!
        
        var unichars = [UniChar](shape.utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        if gotGlyphs {
            let cgpath = CTFontCreatePathForGlyph(font, glyphs[0], nil)!
            
            bezierPath = UIBezierPath(cgPath: cgpath)
            bezierPath?.apply(CGAffineTransform(scaleX: -1, y: 1))
            bezierPath?.apply(CGAffineTransform(translationX: bounds.width, y: 0).rotated(by: CGFloat(M_PI)))
            bezierPath?.apply(CGAffineTransform(translationX: -bounds.width+bezierPath!.bounds.width, y: (bounds.height+bezierPath!.bounds.height)/2))
            UIColor.lightGray.setFill()
            bezierPath?.fill()
        }
        
        print(expectedFill())
    }
    
    func traceInBounds(_ point: CGPoint) -> Bool {
        return bezierPath?.contains(point) == true
    }

    func expectedFill() -> Int {
        UIGraphicsBeginImageContext(frame.size)

        bezierPath?.fill()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        let count = image?.fillCount(bitmapInfo: Constants.traceFillBitmapInfo)
        
        UIGraphicsEndImageContext()
        
        return count ?? 0
    }
}
