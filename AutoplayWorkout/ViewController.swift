//
//  ViewController.swift
//  AutoplayWorkout
//
//  Created by Boris Etingof on 25/11/2014.
//  Copyright (c) 2014 Red Ant. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var video_items                 = createVideoItems([
                                                                "Big_Buck_Bunny_Trailer",
                                                                "Big_Buck_Bunny_Trailer"
            
                                                            ]),
            player:AVQueuePlayer        = createVideoPlayer(video_items),
            avPlayerLayer:AVPlayerLayer = AVPlayerLayer(player: player)
        
        avPlayerLayer.frame = createVideoFrame()
        avPlayerLayer.videoGravity = AVLayerVideoGravityResize
        
        self.view.layer.addSublayer(avPlayerLayer)
        player.play()
        
        var timerView = TimerView(frame: CGRectMake(0, 0, 100.0, 100.0))
        timerView.backgroundColor = UIColor.clearColor()
        self.view.addSubview(timerView)
        
        player.addPeriodicTimeObserverForInterval(CMTimeMakeWithSeconds(1, 1), queue: dispatch_get_main_queue()) { (CMTime) -> Void in
            
            var current_item = player.currentItem,
                progress: Double = CMTimeGetSeconds(current_item.currentTime())/CMTimeGetSeconds(current_item.duration) * 100.0
            
            timerView.updateTimer(progress)
            timerView.setNeedsDisplay()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createVideoItems(urls:[String]!) -> [AVPlayerItem]{
        var item: AVPlayerItem!,
            nsurl: NSURL!,
            asset: AVAsset!,
            items: [AVPlayerItem] = [AVPlayerItem]()
        
        for i in 0..<urls.count {
            //nsurl = NSURL(string: urls[i])
            
            //NSURL *MyURL = [[NSBundle mainBundle]
            //    URLForResource: @"Data" withExtension:@"txt"];
            
            //NSURL *urlString = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"introvideo" ofType:@"mp4"]];
            //MPMoviePlayerController *player  = [[MPMoviePlayerController alloc] initWithContentURL:urlString];
            //[player play];
            
            nsurl = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(urls[i], ofType: "m4v")!)
            asset = AVAsset.assetWithURL(nsurl) as AVAsset
            item = AVPlayerItem(asset: asset)
            items.append(item)
        }
        
        return items
    }
    

    
    func createVideoPlayer(items:[AnyObject]!) -> AVQueuePlayer{
        var player: AVQueuePlayer!
        player = AVQueuePlayer(items: items)

        return player
    }
    
    func createVideoFrame() -> CGRect{
        var aspect_raitio   = CGFloat(16.0/9.0),
            video_height    = self.view.frame.size.width,
            video_width     = video_height * aspect_raitio,
            left_offset     = -(video_width - video_height)/2.0,
            top_offset      = (self.view.frame.size.height - video_height) / 2.0
        
        return CGRectMake(left_offset, top_offset, video_width, video_height)

    }

}

