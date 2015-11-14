//
//  HairViewController.swift
//  Trump
//
//  Created by Cole on 11/14/15.
//  Copyright © 2015 colehudson. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class HairViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Configure the view.
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        skView.ignoresSiblingOrder = true
        
        // Create and configure the scene.
        let scene = GameScene(size: skView.frame.size)
        skView.presentScene(scene)
        
        // Pause the view (and thus the game) when the app is interrupted or backgrounded
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleApplicationWillResignActive:", name: UIApplicationWillResignActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleApplicationDidBecomeActive:", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    override func didReceiveMemoryWarning()
    {
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
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        return UIInterfaceOrientationMask.Portrait
    }
    
    
    func handleApplicationWillResignActive (note: NSNotification) {
        
        let skView = self.view as! SKView
        skView.paused = true
    }
    
    func handleApplicationDidBecomeActive (note: NSNotification) {
        
        let skView = self.view as! SKView
        skView.paused = false
    }

}
