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
    
    let builderDictionaryKey = "BuilderDictionary"
    
    var size: Int!
    var divisions: Int!
    var increment: Int!
    
    var cameraNode: SCNNode?
    var selectedNode: SCNNode?
    var dictionaryOfSmallNodes: [String : Int]?
    
    var arrayOfNodesToBuildWith: [SCNNode]?
    var counter = 0
    
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
        
        self.selectedNode?.transform = headTransform.rotateMatrixForPosition(SCNVector3Make(5, 3, -10))
        self.selectedNode?.scale = SCNVector3Make(0.25, 0.25, 0.25)
        if arrayOfNodesToBuildWith != nil {
            self.selectedNode? = arrayOfNodesToBuildWith![counter]
        }
        
        if control.rightTriggerPressed == true {
            
            self.placeNodeInLevel(scene.cursor.position, selectedNodeTransform: (self.selectedNode?.transform)!)
        }
        
        if control.leftTriggerPressed == true {
            
            self.printDictionaryOfSmallNodes()
        }
        
        if control.leftShoulderPressed == true {
            switchSelectedNode(-1)
        }
        
        if control.rightShoulderPressed == true {
            switchSelectedNode(1)
        }
        
    }
    
    func switchSelectedNode(increaseBy: Int){
        guard arrayOfNodesToBuildWith != nil else {return}
        
        selectedNode?.removeFromParentNode()
        selectedNode = nil
        
        
        counter = counter + increaseBy
        if counter >= arrayOfNodesToBuildWith!.count {
            counter = 0
        }
        
        if counter < 0 {
            counter = 0
        }
        
        selectedNode = arrayOfNodesToBuildWith![counter]
        cameraNode?.addChildNode(selectedNode!)
        
    }
    
    /////////////////////////////////////////////////////////
    func addToDictionary(smallNode: SmallNodeStruct){
        
        let key = "\(smallNode.pos.x),\(smallNode.pos.y),\(smallNode.pos.z)"
        if dictionaryOfSmallNodes == nil {
            dictionaryOfSmallNodes = [ key : smallNode.type]
        } else {
            dictionaryOfSmallNodes![key] = smallNode.type
        }
        
        let defaults = NSUserDefaults()
        defaults.setObject(dictionaryOfSmallNodes, forKey: builderDictionaryKey)
        
    }
  

    func printDictionaryOfSmallNodes(){
        print("dictionary of small nodes:")
        //print(dictionaryOfSmallNodes)
        
        let defaults = NSUserDefaults()
        print(defaults.dictionaryForKey(builderDictionaryKey))
    }
    
    func setUpTools(){
        
        guard cameraNode != nil else {
            print("no camera node")
            return
        }
        
        print("setting up builder tools")
        let size: CGFloat = CGFloat(increment)
        selectedNode = SCNNode()
//       selectedNode = SCNNode(geometry: SCNBox(width: size, height: size, length: size, chamferRadius: 0))
//        selectedNode?.geometry?.firstMaterial?.diffuse.contents = UIColor.yellowColor()
//        selectedNode?.position = SCNVector3Make(5, 3, -10)
//        selectedNode?.name = "Default_\(SmallNodeType.defaultNode.rawValue)"
        cameraNode?.addChildNode(selectedNode!)
        
        setUpArrayWithNodesToBuildWith()
        
    }
    /////////////////////////////////////////////////////////
    func setUpArrayWithNodesToBuildWith(){
        
        var array: [SCNNode] = []
        
        var counter = 1
        
        for geometry in geometries {
            
            let node = SCNNode(geometry: geometry)
            node.name = "geometries_\(counter)"
            array.append(node)
            counter = counter + 1
        }
        
        guard arrayOfNodesToBuildWith != nil else {
            arrayOfNodesToBuildWith = array
            return
        }
        
        for node in array {
            arrayOfNodesToBuildWith!.append(node)
        }
    }
    
    /////////////////////////////////////////////////////////
    
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
            nodeCopy.scale = SCNVector3Make(1, 1, 1)
            
            var thisSmallNodeType: SmallNodeType.RawValue?
            
            if let suffix = nodeCopy.name?.componentsSeparatedByString("_").last {
                
                thisSmallNodeType = Int(suffix)
            }
            
            
            
            if let thisSmallNodeType = thisSmallNodeType {
                
                let thisSmallNodeStruct  = SmallNodeStruct(type: thisSmallNodeType, pos: nodeCopy.position)
        
                addToDictionary(thisSmallNodeStruct)
                
            }
            
            guard thisSmallNodeType != nil else {return}
            print("placing node of type \(thisSmallNodeType!) at \(nodeCopy.position)")
            

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