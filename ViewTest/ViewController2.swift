//
//  ViewController2.swift
//  NeonSign
//
//  Created by 中山雄晟 on 2015/11/06.
//  Copyright © 2015年 中山雄晟. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMotion
import AudioToolbox
import Socket_IO_Client_Swift

class ViewController2: UIViewController {

    
    @IBOutlet weak var powerButton: UIButton!
    var audioPlayer = AVAudioPlayer()
    var socket: SocketIOClient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        socket = appDelegate.socket
        
        socket.on("from_server") { (data, emitter) in
            if let message = data as? [String] {
            }
        }

        let background = UIImage(named: "background1.png")
        self.view.backgroundColor = UIColor(patternImage: background!)
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onPower(sender: AnyObject) {
        let power2 : UIImage = UIImage(named:"power2.png")!
        powerButton.setBackgroundImage(power2, forState: .Normal)
        print("power on!!")
        soundPlay("power", type: "mp3")
        self.dismissViewControllerAnimated(true, completion: nil)
        socket.emit("hide_power", "hide pushed!!")
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

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
