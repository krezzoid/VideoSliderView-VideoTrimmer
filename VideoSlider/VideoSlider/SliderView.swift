//
//  SliderView.swift
//  VideoSlider
//
//  Created by Ilya Seliverstov on 26.04.16.
//  Copyright 2016 Ilya Seliverstov. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//
// swiftlint:disable function_body_length
import Foundation
import UIKit

class SliderView: UIView {
    var leftCorners = Bool(true)
    
    init(frame: CGRect, leftCorners: Bool) {
        self.leftCorners = leftCorners
        
        super.init(frame: frame)
        
        self.contentMode = leftCorners ? UIViewContentMode.Left : UIViewContentMode.Right
        self.userInteractionEnabled = true
        self.clipsToBounds = true
        self.backgroundColor = UIColor.clearColor()
        self.layer.borderWidth = 0.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // codebeat:disable[LOC,ABC]
    override func drawRect(rect: CGRect) {
        
        //// General Declarations
        let context = UIGraphicsGetCurrentContext()
        
        //// Color Declarations
        let color5 = UIColor(red: 0.992, green: 0.902, blue: 0.004, alpha: 1)
        let gradientColor2 = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        let color6 = UIColor(red: 0.196, green: 0.161, blue: 0.047, alpha: 1)
        
        //// Gradient Declarations
        let gradient3Colors: [CGColor] = [gradientColor2.CGColor,
                                          UIColor(red: 0.996, green: 0.951, blue: 0.502, alpha: 1).CGColor,
                                          color5.CGColor]
        
        let gradient3Locations: [CGFloat] = [0.0, 0.0, 0.49]
        guard let gradient3: CGGradient = CGGradientCreateWithColors(CGColorSpaceCreateDeviceRGB(),
                                                                     gradient3Colors,
                                                                     gradient3Locations) else {
                                                                        return
        }
        
        let bubbleFrame = self.bounds
        
        //// Rounded Rectangle Drawing
        let roundedRectangleRect = CGRect(x: bubbleFrame.minX, y: bubbleFrame.minY,
                                          width: bubbleFrame.width, height: bubbleFrame.height)

        let roundedRectanglePath = UIBezierPath(roundedRect: roundedRectangleRect, byRoundingCorners: leftCorners ?
                                                                                [UIRectCorner.TopLeft, UIRectCorner.BottomLeft]:
                                                                                [UIRectCorner.TopRight, UIRectCorner.BottomRight],
                                                cornerRadii: CGSize(width: 5.0, height: 5.0))
        roundedRectanglePath.closePath()
    
        CGContextSaveGState(context)
        roundedRectanglePath.addClip()
        CGContextDrawLinearGradient(context, gradient3,
                                    CGPoint(x: roundedRectangleRect.midX, y: roundedRectangleRect.minY),
                                    CGPoint(x: roundedRectangleRect.midX, y: roundedRectangleRect.maxY),
                                    CGGradientDrawingOptions(rawValue: 0))
        
        CGContextRestoreGState(context)
        UIColor.clearColor().setStroke()
        roundedRectanglePath.lineWidth = 0.5
        roundedRectanglePath.stroke()

        
        //// Bezier 3 Drawing
        let bezier3Path = UIBezierPath()
        bezier3Path.moveToPoint(CGPoint(x: bubbleFrame.minX + 0.42806 * bubbleFrame.width,
                                        y: bubbleFrame.minY + 0.22486 * bubbleFrame.height))
        bezier3Path.addCurveToPoint(CGPoint(x: bubbleFrame.minX + 0.42806 * bubbleFrame.width,
                                            y: bubbleFrame.minY + 0.74629 * bubbleFrame.height),
                                    controlPoint1: CGPoint(x: bubbleFrame.minX + 0.42806 * bubbleFrame.width,
                                                            y: bubbleFrame.minY + 0.69415 * bubbleFrame.height),
                                    controlPoint2: CGPoint(x: bubbleFrame.minX + 0.42806 * bubbleFrame.width,
                                                            y: bubbleFrame.minY + 0.69415 * bubbleFrame.height))
        bezier3Path.addLineToPoint(CGPoint(x: bubbleFrame.minX + 0.35577 * bubbleFrame.width,
                                            y: bubbleFrame.minY + 0.74629 * bubbleFrame.height))
        bezier3Path.addCurveToPoint(CGPoint(x: bubbleFrame.minX + 0.35577 * bubbleFrame.width,
                                            y: bubbleFrame.minY + 0.22486 * bubbleFrame.height),
                                    controlPoint1: CGPoint(x: bubbleFrame.minX + 0.35577 * bubbleFrame.width,
                                                            y: bubbleFrame.minY + 0.69415 * bubbleFrame.height),
                                    controlPoint2: CGPoint(x: bubbleFrame.minX + 0.35577 * bubbleFrame.width,
                                                            y: bubbleFrame.minY + 0.69415 * bubbleFrame.height))
        bezier3Path.addLineToPoint(CGPoint(x: bubbleFrame.minX + 0.42806 * bubbleFrame.width,
                                            y: bubbleFrame.minY + 0.22486 * bubbleFrame.height))
        
        bezier3Path.closePath()
        bezier3Path.miterLimit = 19
        
        color6.setFill()
        bezier3Path.fill()
        
        //// Bezier Drawing
        let bezierPath = UIBezierPath()
        bezierPath.moveToPoint(CGPoint(x: bubbleFrame.minX + 0.66944 * bubbleFrame.width,
                                        y: bubbleFrame.minY + 0.22486 * bubbleFrame.height))
        bezierPath.addCurveToPoint(CGPoint(x: bubbleFrame.minX + 0.66944 * bubbleFrame.width,
                                            y: bubbleFrame.minY + 0.74629 * bubbleFrame.height),
                                   controlPoint1: CGPoint(x: bubbleFrame.minX + 0.66944 * bubbleFrame.width,
                                                            y: bubbleFrame.minY + 0.69415 * bubbleFrame.height),
                                   controlPoint2: CGPoint(x: bubbleFrame.minX + 0.66944 * bubbleFrame.width,
                                                            y: bubbleFrame.minY + 0.69415 * bubbleFrame.height))
        bezierPath.addLineToPoint(CGPoint(x: bubbleFrame.minX + 0.59715 * bubbleFrame.width,
                                            y: bubbleFrame.minY + 0.74629 * bubbleFrame.height))
        bezierPath.addCurveToPoint(CGPoint(x: bubbleFrame.minX + 0.59715 * bubbleFrame.width,
                                            y: bubbleFrame.minY + 0.22486 * bubbleFrame.height),
                                   controlPoint1: CGPoint(x: bubbleFrame.minX + 0.59715 * bubbleFrame.width,
                                                            y: bubbleFrame.minY + 0.69415 * bubbleFrame.height),
                                   controlPoint2: CGPoint(x: bubbleFrame.minX + 0.59715 * bubbleFrame.width,
                                                            y: bubbleFrame.minY + 0.69415 * bubbleFrame.height))
        bezierPath.addLineToPoint(CGPoint(x: bubbleFrame.minX + 0.66944 * bubbleFrame.width,
                                            y: bubbleFrame.minY + 0.22486 * bubbleFrame.height))
        
        bezierPath.closePath()
        bezierPath.miterLimit = 19
            
        color6.setFill()
        bezierPath.fill()
    }

}
