//
//  ViewController.swift
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

class ViewController: UIViewController {
    
    @IBOutlet var sliderView: UIView!
    var videoSlider: VideoSliderProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let videoPath = NSBundle.mainBundle().pathForResource("videoFile", ofType: "mov") else { return }
        videoSlider = VideoSliderView(frame: sliderView.frame, videoPath: videoPath)
        
        
        videoSlider?.maxDuration = 30.0
        videoSlider?.showInView(sliderView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchTrim(button: UIButton) {
        guard let videoPath = NSBundle.mainBundle().pathForResource("videoFile", ofType: "mov") else { return }
        guard let slider = videoSlider else { return }
        
        button.enabled = false
        
        VideoTrimmer.trimFile(videoPath, outputFilePath: videoPath + "_out",
                              startTime: slider.leftPosition,
                              durationTime: CMTimeSubtract(slider.rightPosition, slider.leftPosition)) { (success) in
                                
                                button.enabled = true
                                
                                let allert = UIAlertController(title: nil, message: "Video trimmed - \(success)",
                                                               preferredStyle: UIAlertControllerStyle.Alert)
                                allert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                                
                                self.presentViewController(allert, animated: true, completion: nil)
        }
        
    }
}
