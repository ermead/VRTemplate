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

func generateRandomNodesOnMap(arrayOfNodes: [SCNNode]?, mapNode: SCNNode, widthOfMap: Int, lengthOfMap: Int, count: Int, yValue: Float, isDestroyable: Bool) {
    
    var randomNodeCollection: [SCNNode]? = arrayOfNodes
    if randomNodeCollection == nil {
        
        randomNodeCollection = []
        
        let defaultGeometries = geometries
        
        let randomDefault = GKRandomDistribution(forDieWithSideCount: geometries.count)
        
        for i in 0 ..< count {
            let randomIndex = randomDefault.nextInt() - 1
            let node = SCNNode()
            node.geometry = defaultGeometries[randomIndex]
            let color = UIColor(hue: ((CGFloat(i) * (359/CGFloat(count)))) / 359.0, saturation: 0.8, brightness: 0.7, alpha: 1.0)
            node.geometry?.firstMaterial?.diffuse.contents = color
            randomNodeCollection?.append(node)
            
        }
        
    }
    
    guard randomNodeCollection != nil else {return}
    
    for i in 1 ..< count {
        
        var index = i - 1
        
        func adjustIndexForCount(){
            if index >= randomNodeCollection!.count {
                index = index - randomNodeCollection!.count
                adjustIndexForCount()
            } else {
                return
            }
        }
        
        adjustIndexForCount()
        
        guard index < randomNodeCollection!.count else {return}
        
        let nodeA = randomNodeCollection![index]
        var materialA = SCNMaterial()
        if let material = (nodeA.geometry?.firstMaterial) {
            materialA = material
        }
        let node = duplicateNode(nodeA, material: materialA)
        
        if isDestroyable == true {
            node.physicsBody = SCNPhysicsBody.kinematicBody()
            node.physicsBody!.categoryBitMask = CC.destroyable.rawValue
            node.physicsBody!.contactTestBitMask = CC.bullet.rawValue
            node.physicsBody!.collisionBitMask = CC.bullet.rawValue | CC.floor.rawValue
        }
        
        node.name = "\(i)_\(node.name)"
        
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
        
        var thisXPos = randomX.nextInt() * randomSignX
        var thisZPos = randomZ.nextInt() * randomSignX
        
        func checkXZ() {
            if thisXPos == abs(thisXPos) && thisZPos == abs(thisZPos) {
              
                //then in this quadrant
                //get new varible, because ocean is in that corner
                thisXPos = randomX.nextInt() * randomSignX
                thisZPos = randomZ.nextInt() * randomSignX
                checkXZ()
            } else {
                // do nothing, it's okay
            }
        }
        checkXZ()
        
        node.position = SCNVector3Make(Float(thisXPos), yValue, Float(thisZPos))
        
        
        mapNode.addChildNode(node)
        print("\(i). added node at \(node.position)")
    }
}