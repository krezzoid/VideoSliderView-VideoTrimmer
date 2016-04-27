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

extension VideoSliderView: VideoSliderProtocol {
    
    var leftPosition: CMTime {
        get {
            return timeForPos(Double(leftPos))
        }
    }
    var rightPosition: CMTime {
        get {
            return timeForPos(Double(rightPos))
        }
    }

    func showInView(view: UIView) {
        self.frame = view.bounds
        
        // show video thumbs
        showVideoThumbs()

        view.addSubview(self)
        view.bringSubviewToFront(self)
    }
    
    //MARK: Private
    private func showVideoThumbs() {
        let images = self.framesExtractor.extractFrames(CGSize(width: self.bounds.height, height: self.bounds.height),
                                                        framesCount: Int(self.frame.width / self.frame.height))
        var pos = Int(0)
        for image in images {
            let rect = CGRect(x: CGFloat(pos) * self.frame.width / CGFloat(images.count), y: 0.0,
                              width: self.bounds.height, height: self.bounds.height) // scale image to fill height
            addImage(image, frame: rect)
            
            pos += 1
        }
    }
}
