//
//  VRScene_1.swift
//  VRTemplate
//
//  Created by Eric Mead on 10/14/16.
//  Copyright © 2016 Eric Mead. All rights reserved.
//
import SpriteKit

@objc(VRScene_01)
class VRScene_01: VRBaseScene {
    
    var torusNode = SCNNode()
    var waveSkinner = SCNSkinner()
  
    required init() {
        
        print("loaded vr scene_01")
        
        super.init()
        
        floorContents = UIImage(named: "Grass.png")!
        
        backgroundContents = [
            "art.scnassets/skybox/right.jpg",
            "art.scnassets/skybox/left.jpg",
            "art.scnassets/skybox/top.jpg",
            "art.scnassets/skybox/bottom.jpg",
            "art.scnassets/skybox/back.jpg",
            "art.scnassets/skybox/front.jpg",
            ]
 
    }
    
    
    
    override func handleKeyboardEvents(input: String) {
        
        let speed : Float = 3
        
        func resetControls(){
            control?.leftThumbstickRight = 0
            control?.leftThumbstickLeft = 0
            control?.leftThumbstickUp = 0
            control?.leftThumbstickDown = 0
            control?.rightThumbstickRight = 0
            control?.rightThumbstickLeft = 0
            control?.rightThumbstickUp = 0
            control?.rightThumbstickDown = 0
        }
        
        switch input {
            
        case "b":     buttonBPressed((control?.from)!, projected: (control?.projected)!)
        case ",":
            
            if control?.leftTriggerPressed == false {
                control?.leftTriggerPressed = true
                let delay = SCNAction.waitForDuration(0.1)
                let runBlock = SCNAction.runBlock({ (node) in
                    self.control?.leftTriggerPressed = false
                })
                let seq = SCNAction.sequence([delay, runBlock])
                world.runAction(seq)
            }
//            for bone in waveSkinner.bones {
////            if bone.name == "Armature_001_Bone_067_pose_matrix" {
////                bone.eulerAngles.y += GLKMathDegreesToRadians(1)
////            }
//            }
            
        case ".":
            
            if control?.rightTriggerPressed == false {
                control?.rightTriggerPressed = true
                let delay = SCNAction.waitForDuration(0.1)
                let runBlock = SCNAction.runBlock({ (node) in
                    self.control?.rightTriggerPressed = false
                })
                let seq = SCNAction.sequence([delay, runBlock])
                world.runAction(seq)
            }
//            for bone in waveSkinner.bones {
//                bone.eulerAngles.x -= GLKMathDegreesToRadians(1)
//            }
            
        case "<":     for bone in waveSkinner.bones {
            
           
            bone.eulerAngles.y += GLKMathDegreesToRadians(1)
            
            
            
            }
        case ">":     for bone in waveSkinner.bones {
            
         
            bone.eulerAngles.y -= GLKMathDegreesToRadians(1)
            
            
            }
        case leftKey: print("left")
        //cameraNode.position.x -= speed
        let input: Float = control?.leftThumbstickLeft == -0.5 ? 0.0 : -0.5
        resetControls()
        control?.leftThumbstickLeft = input
        control?.leftThumbstickRight = 0
        case rightKey: print("right")
        //cameraNode.position.x += speed
        let input: Float = control?.leftThumbstickRight == -0.5 ? 0.0 : -0.5
        resetControls()
        control?.leftThumbstickRight = input
        control?.leftThumbstickLeft = 0
        case forwardKey: print("forward")
        //cameraNode.position.z -= speed
        let input: Float = control?.leftThumbstickUp == -0.5 ? 0.0 : -0.5
        resetControls()
        control?.leftThumbstickUp = input
        control?.leftThumbstickDown = 0
        case backKey: print("back")
        //cameraNode.position.z += speed
        let input: Float = control?.leftThumbstickDown == -0.5 ? 0.0 : -0.5
        resetControls()
        control?.leftThumbstickDown = input
        control?.leftThumbstickUp = 0
        case upKey: print("up")
        //cameraNode.position.y += speed
        let input: Float = control?.rightThumbstickUp == 0.5 ? 0.0 : 0.5
        resetControls()
        control?.rightThumbstickUp = input
        control?.rightThumbstickDown = 0
        case downKey: print("down")
        //cameraNode.position.y -= speed
        let input: Float = control?.rightThumbstickDown == 0.5 ? 0.0 : 0.5
        resetControls()
        control?.rightThumbstickDown = input
        control?.rightThumbstickUp = 0
        case quitKey: cameraNode.position = SCNVector3Zero
            
        default: return
            
        }
        

        
    }
    
    //MARK:UPDATE
    override func doAdditionalUpdate(headTransform: GVRHeadTransform) {
    
        
        rotateBones()
        //  world.position.z += 1
        let text = SCNText(string: String(Int(time)), extrusionDepth: 0.5)
        text.chamferRadius = 1
        torusNode.geometry = text
        
        waveSkinner.skeleton?.position = world.position
        
    }
    
    
    func rotateBones(){
        let amount:Float = 1
        for bone in waveSkinner.bones {
            
            if time > 1 {
                
                if bone.name == "Armature_001_Bone_015_pose_matrix" {
                    
                    bone.eulerAngles.x -= GLKMathDegreesToRadians(amount)
                }
            }
            if time > 2 {
                
                if bone.name == "Armature_001_Bone_023_pose_matrix" {
                    
                    bone.eulerAngles.x -= GLKMathDegreesToRadians(amount)
                }
            }
            if time > 3 {
                
                if bone.name == "Armature_001_Bone_028_pose_matrix" {
                    
                    bone.eulerAngles.x -= GLKMathDegreesToRadians(amount)
                }
            }
            if time > 4 {
                
                if bone.name == "Armature_001_Bone_036_pose_matrix" {
                    
                    bone.eulerAngles.x -= GLKMathDegreesToRadians(amount)
                }
            }
            if time > 5 {
                
                if bone.name == "Armature_001_Bone_043_pose_matrix" {
                    
                    bone.eulerAngles.x -= GLKMathDegreesToRadians(amount)
                }
            }
            if time > 6 {
                
                if bone.name == "Armature_001_Bone_048_pose_matrix" {
                    
                    bone.eulerAngles.x -= GLKMathDegreesToRadians(amount)
                }
            }
            if time > 7 {
                
                if bone.name == "Armature_001_Bone_055_pose_matrix" {
                    
                    bone.eulerAngles.x -= GLKMathDegreesToRadians(amount)
                }
            }
            if time > 8 {
                
                if bone.name == "Armature_001_Bone_060_pose_matrix" {
                    
                    bone.eulerAngles.x -= GLKMathDegreesToRadians(amount)
                }
            }
        }
    }
    
    ///////
    var projectedDistance: Float = 0
    
    func makeBox(){
        
        let material1 = SCNMaterial()
        material1.diffuse.contents = UIColor.blackColor()
        material1.specular.contents = UIColor.whiteColor()
        material1.shininess = 100.0
        material1.reflective.contents = backgroundContents
        
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.01)
        box.firstMaterial = material1
        let spawnPosNode = SCNNode()
        let position = SCNVector3Make(0, 0, -3)
        spawnPosNode.position = position
        cameraNode.addChildNode(spawnPosNode)
        let boxNode = SCNNode(geometry: box)
        boxNode.position = cameraNode.convertPosition(spawnPosNode.position, toNode: things)
        things.addChildNode(boxNode)
        
        
        let delay = SCNAction.waitForDuration(0.5)
        let runBlock = SCNAction.runBlock { (node) in
            
            self.projectBox(self.projectedDistance, node: boxNode)
            
            
        }
        let seq = SCNAction.sequence([delay, runBlock])
        boxNode.runAction(seq)
    }
    
    var isMaking = false
    
    func makeOrProject(){
   
        if isMaking == false {
            isMaking = true
            projectedDistance = 0
            makeBox()
        } else {
            projectedDistance += 10
        }
    }
    
    func projectBox(distance: Float, node: SCNNode){
        print(distance)
        let projected = control?.projected
        let normalProjected = projected!.normalized()
        print(normalProjected)
        let scaledNormal = SCNVector3Make(normalProjected.x * distance, normalProjected.y * distance, normalProjected.z * distance)
        let action = SCNAction.moveBy(scaledNormal, duration: 1)
        let runBlock = SCNAction.runBlock { (node) in
            self.isMaking = false
            node.physicsBody = SCNPhysicsBody.kinematicBody()
            node.name = "grappleable"
            node.physicsBody!.categoryBitMask = CC.destroyable.rawValue
            node.physicsBody!.contactTestBitMask = CC.bullet.rawValue
            node.physicsBody!.collisionBitMask = CC.bullet.rawValue
            
        }
        node.runAction(SCNAction.sequence([action, runBlock]))
        
    }
    
    ////////
    
    override func buttonBPressed(from: SCNVector3, projected: SCNVector3){
        print("buttonB pressed")
        print("from: \(from)")
        print("to: \(projected)")
        
        makeOrProject()
    }
    
    //MARK:SETUP
    override func doAdditionalSetup() {
        
        self.scene.fogColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
        self.scene.fogStartDistance = 100
        self.scene.fogEndDistance = 250
        self.scene.fogDensityExponent = 0.8
        
        setUpCompassPoints(things, backgroundContents: backgroundContents, distance: 150.0, sizeRadius: 5.0)
        setUpCompassPoints(things, backgroundContents: backgroundContents, distance: 50.0, sizeRadius: 5.0)
        
        generateRandomNodesOnMap(nil, mapNode: things, widthOfMap: 200, lengthOfMap: 200, count: 10)
        
        let torusGeometry = SCNTorus(ringRadius: 4, pipeRadius: 1)
        torusGeometry.firstMaterial?.diffuse.contents = UIColor.blackColor()
        torusGeometry.firstMaterial?.specular.contents = UIColor.whiteColor()
        torusGeometry.firstMaterial?.shininess = 100.0
        torusGeometry.firstMaterial?.reflective.contents = scene.background.contents
        torusNode = SCNNode(geometry: torusGeometry)
        torusNode.position = SCNVector3Make(-10, 0, -100)
        world.addChildNode(torusNode)
        ////////
        
        let text = SCNText(string: "TEST", extrusionDepth: 1)
        text.chamferRadius = 0.2
        torusNode.geometry = text
        
        //
        let sceneWave = SCNScene(named: "art.scnassets/testWaveRig.scn")
        let wave = sceneWave!.rootNode.childNodeWithName("wave", recursively: true)
        
        waveSkinner = (wave?.skinner)!
        waveSkinner.skeleton?.position = SCNVector3Zero
        waveSkinner.skeleton?.position.y = 30
        waveNode.addChildNode(wave!)
        waveSkinner.skeleton?.scale = SCNVector3Make(10, 10, 10)
        //world.addChildNode(waveNode)
        
        waveNode.eulerAngles.x = GLKMathDegreesToRadians(180)
        //
        
        cameraNode.physicsBody = SCNPhysicsBody.dynamicBody()
        cameraNode.physicsBody?.categoryBitMask = CC.player.rawValue
        cameraNode.physicsBody?.collisionBitMask = CC.floor.rawValue
        //cameraNode.physicsBody?.affectedByGravity = true
        
        

        let scene3 = SCNScene(named: "art.scnassets/testTree.scn")!
        let tree = scene3.rootNode.childNodeWithName("tree", recursively: true)
        let treeNode = SCNNode()
        treeNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        treeNode.addChildNode(tree!)
        treeNode.scale = SCNVector3Make(15, 20, 15)
        treeNode.position = SCNVector3Make(5, -3, -5)
        //world.addChildNode(treeNode)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "testTreeMaterial")
        
        for i in -3 ..< 13 {
            for j in 7 ..< 12 {
                let treeClone: SCNNode = duplicateNode(treeNode, material: material)
                treeClone.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
                treeClone.position = SCNVector3((Double(i) - 5.0) * 35, -10, (Double(j) - 5.0) * 35)
                //world.addChildNode(treeClone)
            }
        }
        
        let delay = SCNAction.waitForDuration(5)
        let runBlock = SCNAction.runBlock { (node) in
            
            self.doingSomething = false
        }
        let seq = SCNAction.sequence([delay, runBlock])
        self.world.runAction(seq)
        
        //
        setUpModels()
        //
    }
    
    func setUpModels(){
        
        let scene = SCNScene(named: "models.scnassets/Models.scn")!
        
        let barrel = scene.rootNode.childNodeWithName("barrel", recursively: true)
        let barrelNode = SCNNode()
        barrelNode.addChildNode(barrel!)
        barrelNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        barrelNode.scale = SCNVector3Make(2, 2, 2)
        barrelNode.position = SCNVector3Make(0, -5, -42)
        barrelNode.physicsBody = SCNPhysicsBody.kinematicBody()
        //world.addChildNode(barrelNode)
        
        let structure = scene.rootNode.childNodeWithName("structure", recursively: true)
        let structureNode = SCNNode()
        structureNode.addChildNode(structure!)
        structureNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        structureNode.scale = SCNVector3Make(1, 1, 1)
        structureNode.position = SCNVector3Make(0, -5, -20)
        structureNode.physicsBody = SCNPhysicsBody.kinematicBody()
        //world.addChildNode(structureNode)
        
        let rock = scene.rootNode.childNodeWithName("rock", recursively: true)
        let rockNode = SCNNode()
        rockNode.addChildNode(rock!)
        rockNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        rockNode.scale = SCNVector3Make(1, 1, 1)
        rockNode.position = SCNVector3Make(0, -5, -20)
        rockNode.physicsBody = SCNPhysicsBody.kinematicBody()
        //world.addChildNode(rockNode)
        
        let tree = scene.rootNode.childNodeWithName("tree", recursively: true)
        let treeNode = SCNNode()
        treeNode.addChildNode(tree!)
        treeNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        treeNode.scale = SCNVector3Make(1, 1, 1)
        treeNode.position = SCNVector3Make(0, -10, -30)
        treeNode.physicsBody = SCNPhysicsBody.kinematicBody()
        //world.addChildNode(treeNode)
        
        let bamboo_1 = scene.rootNode.childNodeWithName("bamboo_1", recursively: true)
        let bamboo_1Node = SCNNode()
        bamboo_1Node.addChildNode(bamboo_1!)
        bamboo_1Node.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        bamboo_1Node.scale = SCNVector3Make(1, 1, 1)
        bamboo_1Node.position = SCNVector3Make(0, -10, -40)
        //world.addChildNode(bamboo_1Node)
        
        let bamboo_2 = scene.rootNode.childNodeWithName("bamboo_2", recursively: true)
        let bamboo_2Node = SCNNode()
        bamboo_2Node.addChildNode(bamboo_2!)
        bamboo_2Node.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        bamboo_2Node.scale = SCNVector3Make(1, 1, 1)
        bamboo_2Node.position = SCNVector3Make(0, -10, -50)
        //world.addChildNode(bamboo_2Node)
        
        let bamboo_3 = scene.rootNode.childNodeWithName("bamboo_3", recursively: true)
        let bamboo_3Node = SCNNode()
        bamboo_3Node.addChildNode(bamboo_3!)
        bamboo_3Node.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        bamboo_3Node.scale = SCNVector3Make(1, 1, 1)
        bamboo_3Node.position = SCNVector3Make(0, -10, -60)
        //world.addChildNode(bamboo_3Node)
        
        let fern = scene.rootNode.childNodeWithName("fern", recursively: true)
        let fernNode = SCNNode()
        fernNode.addChildNode(fern!)
        fernNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        fernNode.scale = SCNVector3Make(10, 10, 10)
        fernNode.position = SCNVector3Make(0, -10, -70)
        //world.addChildNode(fernNode)
        
        let lily = scene.rootNode.childNodeWithName("lily", recursively: true)
        let lilyNode = SCNNode()
        lilyNode.addChildNode(lily!)
        lilyNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        lilyNode.scale = SCNVector3Make(10, 10, 10)
        lilyNode.position = SCNVector3Make(0, -10, -80)
        //world.addChildNode(lilyNode)
        
        let light = SCNLight()
        light.type = SCNLightTypeOmni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(0, 10, -70)
        world.addChildNode(lightNode)
        
        let nodes = [barrelNode, structureNode, bamboo_1Node, bamboo_2Node, bamboo_3Node, lilyNode, rockNode, treeNode, fernNode]
        generateRandomNodesOnMap(nodes, mapNode: world, widthOfMap: 400, lengthOfMap: 400, count: 100)
        
        
    }
    
}

