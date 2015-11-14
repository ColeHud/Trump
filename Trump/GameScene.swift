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
        
        // black space color
        self.backgroundColor = UIColor.init(colorLiteralRed: 24.0, green: 48.0, blue: 89.0, alpha: 1.0)
        
        setUpPhysics()
        setUpHair(trump)
    }
    
    // Scene Update
    
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.x * 20, dy: accelerometerData.acceleration.y * 10)
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
        let length = 14 * Int(UIScreen.mainScreen().scale)
        //let relAnchorPoint = CGPointMake(self.size.width/2, self.size.height/2)
        var relAnchorPoint = CGPointMake(trump.size.width/2, trump.size.height/2)
        
        //get all pixels above a certain line that isn't white
        if #available(iOS 9.0, *) {
            var image = (trump.texture?.CGImage)!
            var bitmapData = CGDataProviderCopyData(CGImageGetDataProvider(image))
            var data = CFDataGetBytePtr(bitmapData);
            let bytesPerRow = CGImageGetBytesPerRow(image)
            let width = CGImageGetWidth(image)
            let height = CGImageGetHeight(image);
            
            var rawData = CGDataProviderCopyData(CGImageGetDataProvider(image));
            var bufptr = CFDataGetBytePtr(rawData);
            
            var hairs = 0
            for (var y = 0; y < height; y++)
            {
                for (var x = 0; x < width; x++ )
                {
                    let alpha = bufptr[3]// components of each pixel
                
                    if(alpha == 255 && CGFloat(y) < UIImage(CGImage: image).size.height/5 && hairs < 15 && arc4random_uniform(10) == 1)
                    {
                        let floatx = CGFloat(x)
                        let floaty = CGFloat(y)
                        
                        relAnchorPoint = CGPointMake(floatx, floaty)
                        let strand = HairNode(length: length, anchorPoint: relAnchorPoint, name: "Hairstrand")
                        strand.addToScene(self)
                        hairs++
                    }
                
                    bufptr += 4;
                }
            }
            
        } else {
            // Fallback on earlier versions
        }
        
        let strand = HairNode(length: length, anchorPoint: relAnchorPoint, name: "Hairstrand")
        strand.addToScene(self)
    }

}
