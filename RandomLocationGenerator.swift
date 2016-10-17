//
//  RandomLocationGenerator.swift
//  VRTemplate
//
//  Created by Eric Mead on 10/16/16.
//  Copyright © 2016 Eric Mead. All rights reserved.
//

import Foundation
import GameplayKit

func duplicateNode(node: SCNNode, material:SCNMaterial) -> SCNNode
{
    let newNode: SCNNode = node.clone()
    newNode.geometry = node.geometry?.copy() as? SCNGeometry
    newNode.geometry?.firstMaterial = material
    
    return newNode
}

func generateRandomNodesOnMap(arrayOfNodes: [SCNNode]?, mapNode: SCNNode, widthOfMap: Int, lengthOfMap: Int, count: Int) {
    
    var randomNodeCollection: [SCNNode]? = arrayOfNodes
    if randomNodeCollection == nil {
        
        for i in 0 ..< count {
            
            let boxNode = SCNNode()
            //            let light = SCNLight()
            //            light.type = SCNLightTypeSpot
            //            let lightNode = SCNNode()
            //            lightNode.light = light
            //            lightNode.position = SCNVector3Make(0, 1, 0)
            //            boxNode.addChildNode(lightNode)
            boxNode.geometry = SCNBox(width: 5, height: 5, length: 5, chamferRadius: 1)
            boxNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blueColor()
            randomNodeCollection = []
            randomNodeCollection?.append(boxNode)
            
        }
        
    }
    
    guard randomNodeCollection != nil else {return}
    
    for i in 1 ..< count {
        
        let random = GKRandomDistribution(forDieWithSideCount: randomNodeCollection!.count)
        let index = random.nextInt() - 1
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blueColor()
        
        let node = duplicateNode(randomNodeCollection![index], material: material)
        node.physicsBody = SCNPhysicsBody.kinematicBody()
        node.physicsBody!.categoryBitMask = CC.destroyable.rawValue
        node.physicsBody!.contactTestBitMask = CC.bullet.rawValue
        node.physicsBody!.collisionBitMask = CC.bullet.rawValue | CC.floor.rawValue
        node.name = "\(i)"
        let randomX = GKRandomDistribution(forDieWithSideCount: widthOfMap/2)
        let randomZ = GKRandomDistribution(forDieWithSideCount: lengthOfMap/2)
        
        /**
         * Randomly returns either 1.0 or -1.0.
         */
        var randomSignX: Int {
            return Int((arc4random_uniform(2) == 0) ? 1.0 : -1.0)
        }
        
        var randomSignZ: Int {
            return Int((arc4random_uniform(2) == 0) ? 1.0 : -1.0)
        }
        
        node.position = SCNVector3Make(Float(randomX.nextInt() * randomSignX), 0, Float(randomZ.nextInt() * randomSignX))
        
        
        mapNode.addChildNode(node)
        print("\(i). added node at \(node.position)")
    }
}