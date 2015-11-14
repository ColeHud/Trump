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
    
    // Object Lifecycle Management
    
    // Scene Setup and Content Creation
    override func didMoveToView(view: SKView)
    {
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        if (!self.contentCreated)
        {
            self.createContent()
            self.contentCreated = true
        }
    }
    
    func createContent()
    {
        let trump = SKSpriteNode(imageNamed: "noHair.png")
        
        trump.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        self.addChild(trump)
        
        // black space color
        self.backgroundColor = UIColor.init(colorLiteralRed: 24.0, green: 48.0, blue: 89.0, alpha: 1.0)
        
        setUpPhysics()
        setUpHair()
    }
    
    // Scene Update
    
    override func update(currentTime: CFTimeInterval)
    {
        /* Called before each frame is rendered */
        if let accelerometerData = motionManager.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
    }
    
    private func setUpPhysics()
    {
        physicsWorld.contactDelegate = self
        physicsWorld.gravity = CGVectorMake(0.0,-9.8)
        physicsWorld.speed = 1.0
    }
    
    private func setUpHair()
    {
        let length = 12 * Int(UIScreen.mainScreen().scale)
        let relAnchorPoint = CGPointMake(self.size.width/2, self.size.height/2)
        
        let strand = HairNode(length: length, anchorPoint: relAnchorPoint, name: "Hairstrand")
        strand.addToScene(self)
    }

}
