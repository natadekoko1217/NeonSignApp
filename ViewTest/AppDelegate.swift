//
//  AppDelegate.swift
//  ViewTest
//
//  Created by 中山雄晟 on 2015/10/31.
//  Copyright © 2015年 中山雄晟. All rights reserved.
//

import UIKit
import Socket_IO_Client_Swift  //追加

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var socket: SocketIOClient!
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // ここから
        //socket = SocketIOClient(socketURL: "http://10.211.0.59:8080/socket.io/")
        //socket = SocketIOClient(socketURL: "http://localhost:8080/socket.io/", opts: nil)
        //socket = SocketIOClient(socketURL: "http://10.211.0.223:8080/socket.io/")
        //socket = SocketIOClient(socketURL: "http://10.222.0.55:8080/socket.io/")
        //socket = SocketIOClient(socketURL: "http://127.0.1.1:8080/socket.io/")
        socket = SocketIOClient(socketURL: "http://10.211.1.161:8080/socket.io/")
        //socket = SocketIOClient(socketURL: "http://10.222.0.211:8080/socket.io/")
        //socket = SocketIOClient(socketURL: "http://10.222.0.46:8080/socket.io/")

        socket.on("connect") { data in
            print("socket connected!!")
        }
        socket.on("disconnect") { data in
            print("socket disconnected!!")
        }
        socket.connect()
        // ここまで
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}
