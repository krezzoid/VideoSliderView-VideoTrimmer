//
//  VideoSliderView.swift
//  VideoSlider
//
//  Created by Ilya Seliverstov on 25.04.16.
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

import UIKit
import AVFoundation

class VideoSliderView: UIView {
    internal let framesExtractor: FramesExtractorProtocol
    
    internal let leftSlider: SliderView
    internal let rightSlider: SliderView
    private let centerSlider = UIView(frame: CGRect.zero)
    
    internal var leftPos: CGFloat = 0.0
    internal var rightPos: CGFloat = 0.0

    internal var maxDur: CGFloat = 0.0

    private let frameThumb = FrameThumbView(frame: CGRect.zero)
    private let thumbsView = UIView(frame: CGRect.zero)
    private let topBorder = UIView(frame: CGRect.zero)
    private let bottomBorder = UIView(frame: CGRect.zero)

    init(frame: CGRect, videoPath: String) {
        framesExtractor = FramesExtractor(videoPath: videoPath)

        let slider_width = frame.size.width * 0.05
        leftSlider = SliderView(frame: CGRect(x: 0.0, y: 0.0,
                                                width: slider_width, height: frame.height),
                                leftCorners: true)
        rightSlider = SliderView(frame: CGRect(x: frame.size.width - slider_width, y: 0.0,
                                                width: slider_width, height: frame.height),
                                 leftCorners: false)
        rightPos = frame.width

        super.init(frame: frame)
        
        common_init()
    }
    
    init(frame: CGRect, videoAsset: AVAsset) {
        framesExtractor = FramesExtractor(videoAsset: videoAsset)
        
        let slider_width = frame.size.width * 0.05
        leftSlider = SliderView(frame: CGRect(x: 0.0, y: 0.0,
                                                width: slider_width, height: frame.height),
                                                                    leftCorners: true)
        rightSlider = SliderView(frame: CGRect(x: frame.size.width - slider_width, y: 0.0,
                                                width: slider_width, height: frame.height),
                                                                     leftCorners: false)
        rightPos = frame.width
        
        super.init(frame: frame)
        
        common_init()
    }
    
    override init(frame: CGRect) {
        fatalError("init(frame:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let inset = leftSlider.frame.width / 2.0
        
        leftSlider.center = CGPoint(x: leftPos + inset, y: leftSlider.frame.height / 2.0)
        rightSlider.center = CGPoint(x: rightPos - inset, y: rightSlider.frame.height / 2.0)
        
        centerSlider.frame = CGRect(x: leftSlider.frame.maxX,
                                    y: 0.0,
                                    width: rightSlider.frame.minX - leftSlider.frame.maxX,
                                    height: frame.height)
    }
    
    //MARK: Private
    private func common_init() {
        maxDur = posforTime(CMTime(seconds: framesExtractor.duration, preferredTimescale: 600))
        
        self.addSubview(thumbsView)
        thumbsView.frame = self.bounds
        
        self.addSubview(leftSlider)
        self.addSubview(rightSlider)
        
        topBorder.frame = CGRect(x: 0.0, y: 0.0, width: frame.width, height: 5.0)
        topBorder.backgroundColor = UIColor(red: 0.996, green: 0.951, blue: 0.502, alpha: 1)
        bottomBorder.frame = CGRect(x: 0.0, y: frame.height - 5.0, width: frame.width, height: 5.0)
        bottomBorder.backgroundColor = UIColor(red: 0.992, green: 0.902, blue: 0.004, alpha: 1)
        self.addSubview(topBorder)
        self.addSubview(bottomBorder)
        
        leftSlider.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                        action: #selector(VideoSliderView.panLeftSlider(_:))))
        rightSlider.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                        action: #selector(VideoSliderView.panRightSlider(_:))))
        
        self.addSubview(frameThumb)
        frameThumb.frame = CGRect(x: 0.0, y: -80.0, width: 100.0, height: 100.0)
        
        centerSlider.frame = CGRect(x: leftSlider.frame.maxX, y: 0.0,
                                    width: rightSlider.frame.minX - leftSlider.frame.maxX, height: frame.height)
        centerSlider.backgroundColor = UIColor.clearColor()
        centerSlider.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                                action: #selector(VideoSliderView.panCenterSlider(_:))))

        self.addSubview(centerSlider)
    }
    
    //MARK: Internal
    internal func addImage(image: UIImage, frame: CGRect) {
        let imageView = UIImageView(image: image)
        imageView.frame = frame
        thumbsView.addSubview(imageView)
    }
    
    //MARK: Actions
    internal func panLeftSlider(gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Began || gesture.state == UIGestureRecognizerState.Changed {
            let translation = gesture.translationInView(self)
            
            leftPos += translation.x
            if leftPos < 0 {
                leftPos = 0
            }

            if rightPos - leftPos <= leftSlider.frame.size.width + rightSlider.frame.size.width
                || rightPos - leftPos > maxDur {
                leftPos -= translation.x
            }
            
            gesture.setTranslation(CGPoint.zero, inView: self)
            self.setNeedsLayout()
            
            updateVideoThumb(timeForPos(leftPos))
        }
        
        if gesture.state == UIGestureRecognizerState.Ended {
            hideVideoThumb()
        }
    }
    
    internal func panRightSlider(gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Began || gesture.state == UIGestureRecognizerState.Changed {
            let translation = gesture.translationInView(self)
            
            rightPos += translation.x
            
            if rightPos < 0 {
                rightPos = 0
            }
            
            if rightPos > self.frame.width {
                rightPos = self.frame.width
            }
            
            if rightPos - leftPos <= 0 {
               rightPos -= translation.x
            }
            
            if rightPos - leftPos <= leftSlider.frame.size.width + rightSlider.frame.size.width
                || rightPos - leftPos > maxDur {
                rightPos -= translation.x
            }
            
            gesture.setTranslation(CGPoint.zero, inView: self)
            self.setNeedsLayout()
            
            updateVideoThumb(timeForPos(rightPos))
        }
        
        if gesture.state == UIGestureRecognizerState.Ended {
            hideVideoThumb()
        }
    }
    
    internal func panCenterSlider(gesture: UIPanGestureRecognizer) {
        if gesture.state == UIGestureRecognizerState.Began || gesture.state == UIGestureRecognizerState.Changed {
            let translation = gesture.translationInView(self)

            leftPos += translation.x
            rightPos += translation.x

            if rightPos > self.frame.width || leftPos < 0 {
                leftPos -= translation.x
                rightPos -= translation.x
            }

            gesture.setTranslation(CGPoint.zero, inView: self)
            self.setNeedsLayout()
            
            updateVideoThumb(timeForPos(leftPos + (rightPos - leftPos) / 2.0))
        }
        
        if gesture.state == UIGestureRecognizerState.Ended {
            hideVideoThumb()
        }
    }
    
    private func updateVideoThumb(time: CMTime) {
        guard let image = framesExtractor.extractFrame(time) else { return }
        
        var x_pos = leftPos + (rightPos - leftPos) / 2.0 - frameThumb.frame.width / 2.0
        if x_pos + frameThumb.frame.width > self.frame.width {
           x_pos = self.frame.width - frameThumb.frame.width - 3.0
        }
        if x_pos < 3.0 {
            x_pos = 3.0
        }
        
        frameThumb.frame = CGRect(x: x_pos,
                                  y: frameThumb.frame.origin.y,
                                  width: frameThumb.frame.width,
                                  height: frameThumb.frame.height)
        frameThumb.showThumb(image)
    }

    private func hideVideoThumb() {
        frameThumb.hidden = true
    }
    
    internal func timeForPos(pos: CGFloat) -> CMTime {
        return CMTime(seconds: (framesExtractor.duration * Double(pos)) / Double(self.frame.width),
                      preferredTimescale: 600)
    }
    
    internal func posforTime(time: CMTime) -> CGFloat {
        return self.frame.width / CGFloat(framesExtractor.duration) * CGFloat(CMTimeGetSeconds(time))
    }

}
