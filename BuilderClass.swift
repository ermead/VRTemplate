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
    
    var size: Int!
    var divisions: Int!
    var increment: Int!
    
    var cameraNode: SCNNode?
    var selectedNode: SCNNode?
    var dictionaryOfSmallNodes: [String : Int]?
    
    init(size: Int, divisions: Int) {
        self.size = size
        self.divisions = divisions
        self.increment = size/divisions
        if size % divisions != 0 {
            print("error number of divisions is not an even increment")
        }
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
    
    //MARK: updateBUILDER
    func updateForBuilderMode(headTransform: GVRHeadTransform, control: ControlScheme, scene: VRBaseScene){
        
        self.selectedNode?.transform = headTransform.rotateMatrixForPosition(SCNVector3Make(10, 5, -10))
        self.selectedNode?.scale = SCNVector3Make(0.25, 0.25, 0.25)
        
        if control.rightTriggerPressed == true {
            
            self.placeNodeInLevel(scene.cursor.position, selectedNodeTransform: (self.selectedNode?.transform)!)
        }
        
        if control.leftTriggerPressed == true {
            
            self.printDictionaryOfSmallNodes()
        }
        
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
        let size: CGFloat = CGFloat(increment)
        selectedNode = SCNNode(geometry: SCNBox(width: size, height: size, length: size, chamferRadius: 0))
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
            self.addChildNode(nodeCopy)

            var goToPosition = cameraNode!.convertPosition(pos, toNode: self)
            print(goToPosition)
            
            var gridCoordinates = setPosAccordingToGrid(goToPosition)
            
            if gridCoordinates.x == 0 {
                gridCoordinates.x = Float(Float(increment)/2)
            } else if gridCoordinates.x == abs(gridCoordinates.x) {
                gridCoordinates.x = (gridCoordinates.x) * Float(increment) + Float(Float(increment)/2)
            } else {
                gridCoordinates.x = (gridCoordinates.x) * Float(increment) + Float(Float(increment)/2)
            }
            
            if gridCoordinates.y == 0 {
                gridCoordinates.y = Float(Float(increment)/2)
            } else if gridCoordinates.y == abs(gridCoordinates.y) {
                gridCoordinates.y = (gridCoordinates.y) * Float(increment) + Float(Float(increment)/2)
            } else {
                gridCoordinates.y = (gridCoordinates.y) * Float(increment) + Float(Float(increment)/2)
            }
            
            if gridCoordinates.z == 0 {
                gridCoordinates.z = Float(Float(increment)/2)
            } else if gridCoordinates.z == abs(gridCoordinates.z) {
                gridCoordinates.z = (gridCoordinates.z) * Float(increment) + Float(Float(increment)/2)
            } else {
                gridCoordinates.z = (gridCoordinates.z) * Float(increment) + Float(Float(increment)/2)
            }
            
            goToPosition = SCNVector3Make(gridCoordinates.x, gridCoordinates.y, gridCoordinates.z)
            
            
            let action1 = SCNAction.moveTo(goToPosition, duration: 0.3)
            let action2 = SCNAction.scaleTo(1, duration: 0.3)
            let action3 = SCNAction.rotateToX(0, y: 0, z: 0, duration: 0.3)
            let group = SCNAction.group([action1, action2, action3])
            
            nodeCopy.runAction(group)
            nodeCopy.position = goToPosition
            nodeCopy.eulerAngles.x = 0
            nodeCopy.eulerAngles.y = 0
            nodeCopy.eulerAngles.z = 0
          
            
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
    
    func setPosAccordingToGrid(pos: SCNVector3)-> SCNVector3 {
        
        //print("size: \(size)")
        print("divisions: \(divisions)")
        print("increment: \(increment)")
      
        var updatedPosition = pos
        
        var xCoordinate = (pos.x/Float(increment))
        var yCoordinate = (pos.y/Float(increment))
        var zCoordinate = (pos.z/Float(increment))
        
        if abs(pos.x % Float(increment)) > Float(Float(increment)/2) {
            
            print("rounding x up")
            if xCoordinate == abs(xCoordinate) {
                xCoordinate = Float(Int(xCoordinate)) + 1
            } else {
                xCoordinate = Float(Int(xCoordinate)) - 1
            }
            
        } else {
            
            print("rounding x down")
            xCoordinate = Float(Int(xCoordinate))
        }
        
        if abs(pos.y % Float(increment)) > Float(Float(increment)/2) {
            
            print("rounding y up")
            if yCoordinate == abs(yCoordinate) {
                yCoordinate = Float(Int(yCoordinate)) + 1
            } else {
                yCoordinate = Float(Int(yCoordinate)) - 1
            }
            
        } else {
            
            print("rounding y down")
            yCoordinate = Float(Int(yCoordinate))
        }
        
        if abs(pos.z % Float(increment)) > Float(Float(increment)/2) {
            
            print("rounding z up")
            if zCoordinate == abs(zCoordinate) {
                zCoordinate = Float(Int(zCoordinate)) + 1
            } else {
                zCoordinate = Float(Int(zCoordinate)) - 1
            }
            
        } else {
            
            print("rounding z down")
            zCoordinate = Float(Int(zCoordinate))
        }
        
        if yCoordinate < 0 {
            yCoordinate = 0
        }
        
        updatedPosition = SCNVector3Make(Float(xCoordinate), Float(yCoordinate), Float(zCoordinate))
        print("coordinates: \(updatedPosition)")
        return updatedPosition
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}