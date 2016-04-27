//
//  FramesExtractor.swift
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

import Foundation
import UIKit
import AVFoundation

class FramesExtractor {
    
    private let videoPath: String
    
    private let imageGenerator: AVAssetImageGenerator
    private let videoDuration: Float64
    
    init (videoPath: String) {
        self.videoPath = videoPath
        
        let urlAsset = AVURLAsset(URL: NSURL(fileURLWithPath: videoPath), options: nil)
        imageGenerator = AVAssetImageGenerator(asset: urlAsset)
        
        videoDuration = CMTimeGetSeconds(urlAsset.duration)
    }
}

extension FramesExtractor: FramesExtractorProtocol {

    var duration: Float64 {
        get {
            return videoDuration
        }
    }
    
    func extractFrames(frameSize: CGSize, framesCount: Int) -> [UIImage] {
        var ret: [UIImage] = Array<UIImage>()
        
        imageGenerator.maximumSize = frameSize
        
        for i in (0...framesCount) {
            guard let frame = extractFrame(CMTime(seconds: videoDuration / Double(framesCount) * Double(i),
                                                    preferredTimescale: 600))
                else {
                    continue
            }

            ret.append(frame)
        }

        return ret
    }
    
    func extractFrame(frameTime: CMTime) -> UIImage? {
        do {
            var actualTime = CMTime()
            let cgImg = try imageGenerator.copyCGImageAtTime(frameTime, actualTime: &actualTime)
            
            return UIImage(CGImage: cgImg)
        } catch {
            debugPrint(error as NSError)
        }
        
        return nil
    }
}
