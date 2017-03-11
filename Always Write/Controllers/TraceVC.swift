//
//  TraceVC.swift
//  Always Write
//
//  Created by Sam Raudabaugh on 3/10/17.
//  Copyright © 2017 Cornell Tech. All rights reserved.
//

import UIKit
import CoreText

class TraceVC: UIViewController {
    var rawPoints = [Int]()
    @IBOutlet var drawingView: DrawingView!
    @IBOutlet weak var referenceView: ReferenceView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rawPoints = []
        let touch = touches.first
        let location = touch!.location(in: view)
        rawPoints.append(Int(location.x))
        rawPoints.append(Int(location.y))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch!.location(in: view)
        if rawPoints[rawPoints.count-2] != Int(location.x) || rawPoints[rawPoints.count-1] != Int(location.y) {
            rawPoints.append(Int(location.x))
            rawPoints.append(Int(location.y))
        }
        drawingView.pointsBuffer.append(rawPoints)
        draw()
        
        if referenceView.traceInBounds(location) {
            print("IN")
        } else {
            print("OUT")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    func draw() {
        UIGraphicsBeginImageContext(drawingView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setLineWidth(10.0)
        
        guard let pointsToDraw = drawingView.pointsBuffer.last else { return }
        drawingView.image?.draw(in: CGRect(x: 0, y: 0, width: drawingView.frame.size.width, height: drawingView.frame.size.height))
        
        
        if pointsToDraw.count >= 4 {
            
            context?.move(to: CGPoint(x: CGFloat(pointsToDraw[0]), y: CGFloat(pointsToDraw[1])))
            
            for i in 2..<pointsToDraw.count {
                if i % 2 == 0 {
                    context?.addLine(to: CGPoint(x: CGFloat(pointsToDraw[i]), y: CGFloat(pointsToDraw[i + 1])))
                }
            }
        }
        
        context!.strokePath()
        drawingView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
