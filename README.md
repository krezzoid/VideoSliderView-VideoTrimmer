# VideoSliderView and VideoTrimmer
[![codebeat badge](https://codebeat.co/badges/7426444a-24e8-440b-a5f3-e0961003c686)](https://codebeat.co/projects/github-com-krezzoid-videosliderview-videotrimmer)

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
