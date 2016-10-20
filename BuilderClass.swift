//
//  BuilderClass.swift
//  VRTemplate
//
//  Created by Eric Mead on 10/19/16.
//  Copyright © 2016 Eric Mead. All rights reserved.
//

import Foundation

enum SmallNodeType: Int {
    
    case defaultNode
    case smallNode1
}

struct SmallNodeStruct {
    
    var type: Int
    var pos: SCNVector3
}

class BuilderTools: SCNNode {

    var cameraNode: SCNNode?
    var selectedNode: SCNNode?
    var dictionaryOfSmallNodes: [String : Int]?
    
    override init() {

        super.init()
        
        print("loaded build mode")
        
        let box = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor.yellowColor()
        box.firstMaterial?.emission.contents = UIColor.yellowColor()
        let boxNode = SCNNode(geometry: box)
        self.addChildNode(boxNode)
    }
    
    func loadLevel(){
        
    }
    
    func addToDictionary(smallNode: SmallNodeStruct){
        
        let key = "\(smallNode.pos.x),\(smallNode.pos.y),\(smallNode.pos.z)"
        if dictionaryOfSmallNodes == nil {
            dictionaryOfSmallNodes = [ key : smallNode.type]
        } else {
            dictionaryOfSmallNodes![key] = smallNode.type
        }
        
    }
  

    func printDictionaryOfSmallNodes(){
        print("dictionary of small nodes:")
        print(dictionaryOfSmallNodes)
    }
    
    func setUpTools(){
        
        guard cameraNode != nil else {
            print("no camera node")
            return
        }
        
        print("setting up builder tools")
        
        selectedNode = SCNNode(geometry: SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0))
        selectedNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.yellowColor()
        selectedNode?.position = SCNVector3Make(10, 5, -10)
        selectedNode?.name = "Default_\(SmallNodeType.defaultNode.rawValue)"
        cameraNode?.addChildNode(selectedNode!)
        
    }
    
    func placeNodeInLevel(pos: SCNVector3, selectedNodeTransform: SCNMatrix4){
        
        let selNodeQua = GLKQuaternionMakeWithMatrix4(SCNMatrix4ToGLKMatrix4(selectedNodeTransform))
        let selNodePos = SCNVector3Make(selNodeQua.x, selNodeQua.y, selNodeQua.z)
        
        if let node = selectedNode {
            
            let nodeCopy: SCNNode = node.copy() as! SCNNode
            nodeCopy.position = cameraNode!.convertPosition(selNodePos, toNode: self)
            //nodeCopy.scale = SCNVector3Make(1, 1, 1)
            self.addChildNode(nodeCopy)
            let goToPosition = cameraNode!.convertPosition(pos, toNode: self)
            print(goToPosition)
            let action1 = SCNAction.moveTo(goToPosition, duration: 0.3)
            let action2 = SCNAction.scaleTo(1, duration: 0.3)
            let group = SCNAction.group([action1, action2])
            
            nodeCopy.runAction(group)
            nodeCopy.position = goToPosition
            
            var thisSmallNodeType: SmallNodeType.RawValue?
            
            if let suffix = nodeCopy.name?.componentsSeparatedByString("_").last {
                
                thisSmallNodeType = Int(suffix)
            }
            
            
            
            if let thisSmallNodeType = thisSmallNodeType {
                
                let thisSmallNodeStruct  = SmallNodeStruct(type: thisSmallNodeType, pos: nodeCopy.position)
        
                addToDictionary(thisSmallNodeStruct)
                
            }
            
            print("placing node at \(nodeCopy.position)")

        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}