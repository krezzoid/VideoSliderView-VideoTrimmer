//
//  VideoTrimmer.swift
//  VideoSlider
//
//  Created by Ilya Seliverstov on 27.04.16.
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
import AVFoundation

class VideoTrimmer {

    class func trimFile(filePath: String, outputFilePath: String,
                        startTime: CMTime, durationTime: CMTime,
                        completion: (success: Bool) -> Void) {
    
        let urlAsset = AVURLAsset(URL: NSURL(fileURLWithPath: filePath), options: nil)
        guard let _ = AVAssetExportSession(asset: urlAsset,
                                           presetName: AVAssetExportPresetHighestQuality) else {
                                            completion(success: false)
                                            return
        }
        

        guard let exportSession = AVAssetExportSession(asset: urlAsset,
                                                       presetName: AVAssetExportPresetPassthrough) else {
                                                        completion(success: false)
                                                        return
        }
        
        exportSession.outputURL = NSURL(fileURLWithPath: outputFilePath)
        exportSession.outputFileType = AVFileTypeQuickTimeMovie
        exportSession.timeRange = CMTimeRangeMake(startTime, durationTime)
        
        exportSession.exportAsynchronouslyWithCompletionHandler({
            switch exportSession.status {
                case AVAssetExportSessionStatus.Failed,
                    AVAssetExportSessionStatus.Cancelled:
                    completion(success: false)
                
                default:
                    completion(success: true)
            }
        })
    }
    
    class func trimAsset(asset: AVAsset, outputFilePath: String,
                        startTime: CMTime, durationTime: CMTime,
                        completion: (success: Bool) -> Void) {
        guard let exportSession = AVAssetExportSession(asset: asset,
                                                       presetName: AVAssetExportPresetPassthrough) else {
                                                        completion(success: false)
                                                        return
        }
        
        exportSession.outputURL = NSURL(fileURLWithPath: outputFilePath)
        exportSession.outputFileType = AVFileTypeQuickTimeMovie
        exportSession.timeRange = CMTimeRangeMake(startTime, durationTime)
        
        exportSession.exportAsynchronouslyWithCompletionHandler({
            switch exportSession.status {
            case AVAssetExportSessionStatus.Failed,
            AVAssetExportSessionStatus.Cancelled:
                completion(success: false)
                
            default:
                completion(success: true)
            }
        })
    }

}
