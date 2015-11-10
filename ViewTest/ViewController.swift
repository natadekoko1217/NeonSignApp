//
//  ViewController.swift
//  ViewTest
//
//  Created by 中山雄晟 on 2015/10/31.
//  Copyright © 2015年 中山雄晟. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import CoreMotion
import AudioToolbox
import Socket_IO_Client_Swift

class ViewController: UIViewController, AVAudioPlayerDelegate {

    var socket: SocketIOClient!
    
    
    @IBOutlet weak var mainButton: UIButton!
    let motionManager = CMMotionManager()
    var audioPlayer = AVAudioPlayer()
    @IBOutlet weak var animationButton: SpringButton!
    @IBOutlet weak var powerButton: UIButton!
    
    var x = 0
    var y = 0
    var z = 0
    var countJudge:Int = 0
    var countKanban:Int = 0
    var judge:Bool = true
    var time:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //socket通信
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = appDelegate.socket
        
        socket.on("from_server") { (data, emitter) in
            if let message = data as? [String] {
            }
        }

        //background
        let background = UIImage(named: "background1.png")
        self.view.backgroundColor = UIColor(patternImage: background!)
        
        //mainボタンの処理
        let image : UIImage = UIImage(named:"button2.png")!
        mainButton.setBackgroundImage(image, forState: .Highlighted)
        mainButton.addTarget(self, action: "onClick:", forControlEvents: UIControlEvents.TouchUpInside)
        let myLongPressGesture = UILongPressGestureRecognizer(target: self, action: "pushStartBtn:")
        myLongPressGesture.minimumPressDuration = 0.8
        mainButton.addGestureRecognizer(myLongPressGesture)
        
        
        let mySwipe = UISwipeGestureRecognizer(target: self, action: "swipeGesture:")
        mySwipe.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(mySwipe)
        
        //animationButtonの処理
        let board : UIImage = UIImage(named:"board.png")!
        animationButton.setBackgroundImage(board, forState: .Highlighted)
        
        //powerButtonの処理
        
        
        //Motion
        self.motionManager.accelerometerUpdateInterval = 0.05
        self.motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue()) {
            (data, error) in
            dispatch_async(dispatch_get_main_queue()) {
                self.updateAccelerationData(data!.acceleration)
            }
        }
        //Judge whether shaked or not
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "onJudge:", userInfo: nil, repeats: true)
    }
    
    func swipeGesture(sender: UISwipeGestureRecognizer){
        soundPlay("nazo1", type: "mp3")
        let ViewController: UIViewController! = self.storyboard!.instantiateViewControllerWithIdentifier( "HideView" )
        ViewController.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        self.presentViewController( ViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func onPower(){
        animationButton.animation = "slideDown"
        animationButton.rotate = 0
        animationButton.x = 0
        animationButton.duration = 0.5
        animationButton.delay = 0.3
        animationButton.animate()
        let power2 : UIImage = UIImage(named:"power2.png")!
        powerButton.setBackgroundImage(power2, forState: .Normal)
        print("power on!!")
        soundPlay("power", type: "mp3")
        socket.emit("on_power", "powerButton1 pushed!!")
    }
    
    @IBAction func shakeKanban(){
        if countKanban < 5{
        countKanban += 1
        soundPlay("panch1", type: "mp3")
        animationButton.animation = "swing"
        animationButton.curve = "easeOutQuint"
        animationButton.animate()
        let power1 : UIImage = UIImage(named:"power1.png")!
        powerButton.setBackgroundImage(power1, forState: .Normal)
        }else{
        animationButton.animation = "zoomOut"
        animationButton.duration = 4
        animationButton.rotate = 0.8
        animationButton.x += 100
        animationButton.delay = 0.2
        animationButton.animate()
        countKanban = 0
        soundPlay("nazo1", type: "mp3")
        }
    }
    
    
    func soundPlay(title : String,type : String){
        let path = NSBundle.mainBundle().pathForResource(title, ofType:type)!
        let url = NSURL(fileURLWithPath: path)
        
        do {
            let sound = try AVAudioPlayer(contentsOfURL: url)
            audioPlayer = sound
            sound.play()
        } catch {
            // couldn't load file :(
        }
    }
    
    func onJudge(timer : NSTimer){
         if (countJudge >= 12){
            print("trueShaken----------")
            soundPlay("nazo1", type: "mp3")
            countJudge = 0
            socket.emit("on_judge", "device shaked!!")
        }else{
            countJudge = 0
        }
    }
    
    @IBAction func pushStartBtn(sender: UILongPressGestureRecognizer) {
        if(sender.state == .Began){
            print("Push Began")
            soundPlay("nazo1", type: "mp3")
            socket.emit("long_push", "Long pushed!!")
        }else if(sender.state == .Ended){
            print("Push Ended")
        }
    }
    
    func updateAccelerationData(data: CMAcceleration) {
        
        let isShaken = self.x != Int(data.x) || self.y != Int(data.y) || self.z != Int(data.z)
        
        if isShaken {
            countJudge += 1
        }
        
        self.x = Int(data.x)
        self.y = Int(data.y)
        self.z = Int(data.z)
        print("x: \(self.x)",terminator: "")
        print("y: \(self.y)",terminator: "")
        print("z: \(self.z)")

    }
    
    func onClick(sender: UIButton) {
        print("Button Pushed!!")
        soundPlay("switch1",type: "mp3")
        socket.emit("main_button", "Main pushed!!")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

