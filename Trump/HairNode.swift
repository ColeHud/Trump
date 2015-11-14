//
//  HairNode.swift
//  Trump
//
//  Created by Cole on 11/14/15.
//  Copyright © 2015 colehudson. All rights reserved.
//

import UIKit
import SpriteKit

struct Layer {
    static let Background: CGFloat = 0
    static let Hair: CGFloat = 1
    static let Foreground: CGFloat = 3
}

struct Category {
    static let HairHolder: UInt32 = 2
    static let Hair: UInt32 = 4
    static let Prize: UInt32 = 8
}

class HairNode: SKNode
{
    private let length: Int
    private let anchorPoint: CGPoint
    private var hairSegments: [SKNode] = []
    
    init(length: Int, anchorPoint: CGPoint, name: String)
    {
        self.length = length
        self.anchorPoint = anchorPoint
        
        super.init()
        
        self.name = name
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        length = aDecoder.decodeIntegerForKey("length")
        anchorPoint = aDecoder.decodeCGPointForKey("anchorPoint")
        super.init(coder: aDecoder)
    }
    
    func addToScene(scene: SKScene)
    {
        // add rope to scene
        zPosition = Layer.Hair
        scene.addChild(self)
        
        // create rope holder
        let hairHolder = SKSpriteNode(imageNamed: "HairHolder2")
        hairHolder.position = anchorPoint
        hairHolder.zPosition = Layer.Hair
        
        hairSegments.append(hairHolder)
        addChild(hairHolder)
        
        hairHolder.physicsBody = SKPhysicsBody(circleOfRadius: hairHolder.size.width / 2)
        hairHolder.physicsBody?.dynamic = false
        hairHolder.physicsBody?.categoryBitMask = Category.HairHolder
        hairHolder.physicsBody?.collisionBitMask = 0
        hairHolder.physicsBody?.contactTestBitMask = Category.Prize
        
        // add each of the rope parts
        for i in 0..<length {
            
            let hairSegment = SKSpriteNode(imageNamed: "reallyTinyHair")
            hairSegment.size.height = hairSegment.size.height
            hairSegment.size.width = hairSegment.size.width
            let offset = hairSegment.size.height * CGFloat(i + 1)
            hairSegment.position = CGPointMake(anchorPoint.x, anchorPoint.y - offset)
            hairSegment.name = name
            
            hairSegments.append(hairSegment)
            addChild(hairSegment)
            
            hairSegment.physicsBody = SKPhysicsBody(rectangleOfSize: hairSegment.size)
            hairSegment.physicsBody?.categoryBitMask = Category.Hair
            hairSegment.physicsBody?.collisionBitMask = Category.HairHolder
            hairSegment.physicsBody?.contactTestBitMask = Category.Prize
        }
        
        // set up joints between rope parts
        for i in 1...length {
            
            let nodeA = hairSegments[i - 1]
            let nodeB = hairSegments[i]
            let joint = SKPhysicsJointPin.jointWithBodyA(nodeA.physicsBody!, bodyB: nodeB.physicsBody!,
                anchor: CGPointMake(CGRectGetMidX(nodeA.frame), CGRectGetMinY(nodeA.frame)))
            
            scene.physicsWorld.addJoint(joint)
        }
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeInteger(length, forKey: "length")
        aCoder.encodeCGPoint(anchorPoint, forKey: "anchorPoint")
        
        super.encodeWithCoder(aCoder)
    }
}
