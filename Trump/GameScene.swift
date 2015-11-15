//
//  GameScene.swift
//  Trump
//
//  Created by Cole on 11/14/15.
//  Copyright © 2015 colehudson. All rights reserved.
//

import UIKit
import SpriteKit
import CoreMotion
import AVFoundation

class GameScene: SKScene, SKPhysicsContactDelegate
{
    // Private GameScene Properties
    let lengthOfStrand = 2
    let occurrence = UInt32(200)
    let numberOfHairs = 30
    
    
    var contentCreated = false
    var motionManager: CMMotionManager!
    
    var myView: SKView?
    var audioPlayer: AVAudioPlayer?
    
    var myScore = 0
    var myScoreLabel: SKLabelNode = SKLabelNode()
    
    //awards
    var awardNumbers = [1000, 10000, 20000, 30000, 50000, 100000]
    var awardNames = ["Won GOP nomination", "Won Presidential election", "Deported ALL Illegal Immigrants", "Built the Great Wall of Trump", "Attended Hillary's Funeral", "Made America Great Again!!!"]
    var awardBools = [false, false, false, false, false, false]
    var currentGoal = 0
    
    //background colors
    var backgroundColors = [[215.0, 38.0, 61.0], [215.0, 205.0, 204.0], [246.0, 244.0, 243.0], [39.0, 111.0, 191.0], [24.0, 48.0, 89.0]]
    
    //songs
    var songs = ["partyintheusa", "wearethechampions"]
    
    // Object Lifecycle Management
    
    
    // Scene Setup and Content Creation
    override func didMoveToView(view: SKView)
    {
        //audio
        let soundtrack = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("partyintheusa", ofType: "mp3")!)
        var audioPlayer = AVAudioPlayer()
        do{
            audioPlayer = try AVAudioPlayer(contentsOfURL: soundtrack, fileTypeHint: "mp3")
            audioPlayer.numberOfLoops = -1
            //audioPlayer.prepareToPlay()
        }catch{
            print("Error playing audio")
        }
        
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        if (!self.contentCreated)
        {
            myView = view
            self.createContent()
            self.contentCreated = true
        }
        
        //self.scene?.backgroundColor = UIColor.blueColor()
        self.scene?.backgroundColor = UIColor(red: CGFloat(215.0/255.0), green: CGFloat(28.0/255.0), blue: CGFloat(61.0/255.0), alpha: 1.0)
        
        //reference and play
        self.audioPlayer = audioPlayer
        audioPlayer.play()
    }
    
    func createContent()
    {
        let trump = SKSpriteNode(imageNamed: "noHair.png")
        
        if let theViewWidth = myView?.bounds.size.width { //THIS IS GOOD CODE :)
            
            trump.size.height = trump.size.height * (theViewWidth / trump.size.width)
            
            trump.size.width = theViewWidth
            
        } else {
            //handle the calc if nil
        }
        
        trump.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        self.addChild(trump)
        
        
        setUpPhysics()
        
        //set up the hair in the background thread
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            // do some task
            self.setUpHair(trump)
        }
        
        //add the eagle
        let eagle = SKSpriteNode(imageNamed: "eagle")
        eagle.size.width = (myView?.bounds.size.width)!
        eagle.size.height = eagle.size.height/1.3
        eagle.position = CGPoint(x: self.size.width/2, y: CGFloat(eagle.size.height/2))
        eagle.zPosition = 2
        
        self.addChild(eagle)
        
        //current score
        myScoreLabel = SKLabelNode(text: "\(self.myScore)")
        myScoreLabel.name = "myScore"
        myScoreLabel.fontSize = 20
        myScoreLabel.fontName = "Montserrat-Regular"
        myScoreLabel.position = CGPoint(x: self.size.width - myScoreLabel.frame.size.width - 20, y: self.size.height - myScoreLabel.frame.size.width - 30)
        self.addChild(myScoreLabel)
        
    }
    
    // Scene Update
    
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 7, dy: accelerometerData.acceleration.y * 7)
        }
    }
    
    private func setUpPhysics()
    {
        /*
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0.0,-9.8)
        physicsWorld.speed = 1.0
        */
    }
    
    private func setUpHair(trump: SKSpriteNode)
    {
        //print out values
        /*
        print("Texture Width: \((trump.texture?.size().width)!)")
        print("Texture Height: \((trump.texture?.size().height)!)")
        
        print("Screen Width: \((myView?.bounds.size.width)!)")
        print("Screen Height: \((myView?.bounds.size.height)!)")
        */
        
        let length = lengthOfStrand * Int(UIScreen.mainScreen().scale)
        //let relAnchorPoint = CGPointMake(self.size.width/2, self.size.height/2)
        var relAnchorPoint = CGPointMake(trump.size.width/2, trump.size.height/2)
        
        //get all pixels above a certain line that isn't white
        if #available(iOS 9.0, *) {
            let image = (trump.texture?.CGImage)!
            let width = CGImageGetWidth(image)
            let height = CGImageGetHeight(image)
            
            let rawData = CGDataProviderCopyData(CGImageGetDataProvider(image))
            var bufptr = CFDataGetBytePtr(rawData)
            
            //coordinate point scaling
            let xScaling = (myView?.bounds.size.width)! / (trump.texture?.size().width)!
            let yScaling = (myView?.bounds.size.height)! / (trump.texture?.size().height)!
            
            //print("X Scaling: \(xScaling) Y Scaling: \(yScaling)")
            
            var hairs = 0
            for (var y = 0; y < height; y++)
            {
                for (var x = 0; x < width; x++ )
                {
                    let alpha = bufptr[3]// components of each pixel
                
                    if(alpha == 255 && CGFloat(y) < UIImage(CGImage: image).size.height/5 && hairs < numberOfHairs && arc4random_uniform(occurrence) == 1)
                    {
                        let floatx = CGFloat((CGFloat(x)) * xScaling)
                        let floaty = CGFloat((UIImage(CGImage: image).size.height - CGFloat(y)) * (1/yScaling)) - 15
                        
                        //print("x: \(floatx) y: \(floaty)")
                        
                        relAnchorPoint = CGPointMake(floatx, floaty)
                        let strand = HairNode(length: length, anchorPoint: relAnchorPoint, name: "Hairstrand")
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            // update some UI
                            strand.addToScene(self)
                        }
                        hairs++
                    }
                
                    bufptr += 4;
                }
            }
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            
            let touch = touch 
            let startPoint = touch.locationInNode(self)
            let endPoint = touch.previousLocationInNode(self)
            
            let node = self.nodeAtPoint(startPoint)
            
            let dx = (startPoint.x - endPoint.x)*1.3
            let dy = (startPoint.y - endPoint.y)*1.3
            
            node.physicsBody?.applyImpulse(CGVectorMake(dx, dy))
            
            // check for collissions
            scene?.physicsWorld.enumerateBodiesAlongRayStart(startPoint, end: endPoint, usingBlock: { (body, point, normal, stop) -> Void in
                self.myScore++
                
                //update the label
                self.myScoreLabel.text = "\(self.myScore)"
                //self.myScoreLabel.position = CGPoint(x: self.size.width - self.myScoreLabel.frame.size.width - 20, y: self.size.height - self.myScoreLabel.frame.size.width - 30)
                
                if(self.awardBools[self.currentGoal] == false && self.myScore >= self.awardNumbers[self.currentGoal])
                {
                    self.awardBools[self.currentGoal] = true
                    
                    var myAlert = UIAlertView(title: "Congratulations", message: self.awardNames[self.currentGoal], delegate: self, cancelButtonTitle: "Trump")
                    //var alert = UIAlertController(title: "Congratulations", message: self.awardNames[self.currentGoal], preferredStyle: UIAlertControllerStyle.Alert)
                    //alert.addAction(UIAlertAction(title: "Trump's da bomb", style: UIAlertActionStyle.Default, handler: nil))
                    //presentViewController(alert, animated: true, completion: nil)
                    myAlert.show()
                    
                    //change the bg to a random color of the color scheme
                    let rand = arc4random_uniform(UInt32(self.backgroundColors.count))
                    let red = self.backgroundColors[Int(rand)][0]
                    let green = self.backgroundColors[Int(rand)][1]
                    let blue = self.backgroundColors[Int(rand)][2]
                    
                    self.scene?.backgroundColor = UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255.0), blue: CGFloat(blue/255.0), alpha: 1.0)
                    
                    //start playing a new (random) song
                    let random = arc4random_uniform(UInt32(self.songs.count))
                    
                    let soundtrack = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource(self.songs[Int(random)], ofType: "mp3")!)
                    var audioPlayer = AVAudioPlayer()
                    do{
                        audioPlayer = try AVAudioPlayer(contentsOfURL: soundtrack, fileTypeHint: "mp3")
                        audioPlayer.numberOfLoops = -1
                        //audioPlayer.prepareToPlay()
                    }catch{
                        print("Error playing audio")
                    }
                    
                    //reference and play
                    self.audioPlayer = audioPlayer
                    audioPlayer.play()

                    
                    self.currentGoal++
                }
            })
        }
    }

}
