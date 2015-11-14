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

class GameScene: SKScene, SKPhysicsContactDelegate
{
    // Private GameScene Properties
    let lengthOfStrand = 2
    let occurrence = UInt32(200)
    let numberOfHairs = 30
    
    
    var contentCreated = false
    var motionManager: CMMotionManager!
    
    var myView: SKView?
    
    // Object Lifecycle Management
    
    // Scene Setup and Content Creation
    override func didMoveToView(view: SKView)
    {
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
            var image = (trump.texture?.CGImage)!
            var bitmapData = CGDataProviderCopyData(CGImageGetDataProvider(image))
            var data = CFDataGetBytePtr(bitmapData);
            let bytesPerRow = CGImageGetBytesPerRow(image)
            let width = CGImageGetWidth(image)
            let height = CGImageGetHeight(image)
            
            var rawData = CGDataProviderCopyData(CGImageGetDataProvider(image))
            var bufptr = CFDataGetBytePtr(rawData)
            
            //coordinate point scaling
            var xScaling = (myView?.bounds.size.width)! / (trump.texture?.size().width)!
            var yScaling = (myView?.bounds.size.height)! / (trump.texture?.size().height)!
            
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
            
            let touch = touch as! UITouch
            let startPoint = touch.locationInNode(self)
            let endPoint = touch.previousLocationInNode(self)
            
            var node = self.nodeAtPoint(startPoint)
            
            var dx = startPoint.x - endPoint.x
            var dy = startPoint.y - endPoint.y
            
            node.physicsBody?.applyImpulse(CGVectorMake(dx, dy))
            
            // check if rope cut
            scene?.physicsWorld.enumerateBodiesAlongRayStart(startPoint, end: endPoint, usingBlock: { (body, point, normal, stop) -> Void in
            })
        }
    }

}
