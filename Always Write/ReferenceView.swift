//
//  ReferenceView.swift
//  Always Write
//
//  Created by Sam Raudabaugh on 3/11/17.
//  Copyright © 2017 Cornell Tech. All rights reserved.
//

import UIKit

class ReferenceView: UIView {
    var bezierPath: UIBezierPath?

    override func draw(_ rect: CGRect) {
        
        let font = UIFont(name: "Futura", size: 1000)!
        
        var unichars = [UniChar]("E".utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        let gotGlyphs = CTFontGetGlyphsForCharacters(font, &unichars, &glyphs, unichars.count)
        if gotGlyphs {
            let cgpath = CTFontCreatePathForGlyph(font, glyphs[0], nil)!
            
            bezierPath = UIBezierPath(cgPath: cgpath)
            
            let layer = CAShapeLayer()
            self.layer.addSublayer(layer)
            layer.fillColor = UIColor.lightGray.cgColor
            layer.position = CGPoint(x: self.layer.bounds.minX, y: (self.layer.bounds.height-bezierPath!.bounds.height)/2)
            
            layer.path = cgpath
        }
        
    }
    
    func traceInBounds(_ point: CGPoint) -> Bool {
        let offset = (self.layer.bounds.height-bezierPath!.bounds.height)/2
        let adjustedPoint = CGPoint(x: point.x, y: point.y-offset)
        return bezierPath?.contains(adjustedPoint) == true
    }

}
