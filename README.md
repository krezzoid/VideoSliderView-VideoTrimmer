# VideoSliderView and VideoTrimmer

### Usage
```swift

// VideoSliderView
let videoSlider: VideoSliderProtocol = VideoSliderView(frame: view.frame, videoPath: "path_to_video_file")
videoSlider.showInView(view)

//
// some of your code here ...
//

// Video Trimming
VideoTrimmer.trimFile(videoPath, 
                        outputFilePath: videoOutputPath,
                        startTime: videoSlider.leftPosition,
                        durationTime: CMTimeSubtract(videoSlider.rightPosition, videoSlider.leftPosition)) { (success) in
                        }

```