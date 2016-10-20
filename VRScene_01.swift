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
    
    var sceneHasFog = false
    
    var isBuildMode: Bool = true
    
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
        waveSkinner.skeleton?.position.y -= 20
        
        if isBuildMode == true {
            updateForBuilderMode(headTransform)
        }
    }
    
    //MARK: updateBUILDER
    func updateForBuilderMode(headTransform: GVRHeadTransform) {
        
        guard isBuildMode == true else {return}
        
        buildModeNode?.selectedNode?.transform = headTransform.rotateMatrixForPosition(SCNVector3Make(10, 5, -10))
        buildModeNode?.selectedNode?.scale = SCNVector3Make(0.25, 0.25, 0.25)
        
        if control?.rightTriggerPressed == true {
            
            buildModeNode?.placeNodeInLevel(cursor.position, selectedNodeTransform: (buildModeNode?.selectedNode?.transform)!)
        }
        
        if control?.leftTriggerPressed == true {
            
            buildModeNode?.printDictionaryOfSmallNodes()
        }
        
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
        
        if sceneHasFog == true {
            self.scene.fogColor = UIColor.grayColor().colorWithAlphaComponent(0.3)
            self.scene.fogStartDistance = 100
            self.scene.fogEndDistance = 250
            self.scene.fogDensityExponent = 0.8
        }
        
        setUpCompassPoints(things, backgroundContents: backgroundContents, distance: 150.0, sizeRadius: 5.0)
        setUpCompassPoints(things, backgroundContents: backgroundContents, distance: 50.0, sizeRadius: 5.0)
        
        generateRandomNodesOnMap(nil, mapNode: things, widthOfMap: 200, lengthOfMap: 200, count: 10, yValue: 10, isDestroyable: true)
        
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
        waveSkinner.skeleton?.position.y = 0
        waveNode.addChildNode(wave!)
        waveSkinner.skeleton?.scale = SCNVector3Make(10, 10, 10)
        world.addChildNode(waveNode)
        
        waveNode.eulerAngles.x = GLKMathDegreesToRadians(180)
        waveNode.eulerAngles.z = GLKMathDegreesToRadians(90)

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
        
        if isBuildMode == true {
            
            setUpBuildMode()
        }
    }
    
    func setUpModels(){
        
        let scene = SCNScene(named: "models.scnassets/Models.scn")!
        
        let barrel = scene.rootNode.childNodeWithName("barrel", recursively: true)
        let barrelNode = SCNNode()
        barrelNode.name = "barrel"
        barrelNode.addChildNode(barrel!)
        barrelNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        barrelNode.scale = SCNVector3Make(5, 5, 5)
        barrelNode.position = SCNVector3Make(0, -5, -42)
        barrelNode.physicsBody = SCNPhysicsBody.kinematicBody()
        //world.addChildNode(barrelNode)
        
        let structure = scene.rootNode.childNodeWithName("structure", recursively: true)
        let structureNode = SCNNode()
        structureNode.name = "structure"
        structureNode.addChildNode(structure!)
        structureNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        structureNode.scale = SCNVector3Make(3, 3, 3)
        structureNode.position = SCNVector3Make(0, 0, -30)
        world.addChildNode(structureNode)
        
        let rock = scene.rootNode.childNodeWithName("rock", recursively: true)
        let rockNode = SCNNode()
        rockNode.name = "rock"
        rockNode.addChildNode(rock!)
        rockNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        rockNode.scale = SCNVector3Make(5, 5, 5)
        rockNode.position = SCNVector3Make(0, -5, -20)
        rockNode.physicsBody = SCNPhysicsBody.kinematicBody()
        //world.addChildNode(rockNode)
        
        let tree = scene.rootNode.childNodeWithName("tree", recursively: true)
        let treeNode = SCNNode()
        treeNode.name = "tree"
        treeNode.addChildNode(tree!)
        treeNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        treeNode.scale = SCNVector3Make(2, 2, 2)
        treeNode.position = SCNVector3Make(0, 0, -30)
        treeNode.physicsBody = SCNPhysicsBody.kinematicBody()
        //world.addChildNode(treeNode)
        
        let bamboo_1 = scene.rootNode.childNodeWithName("bambooCluster", recursively: true)
        let bamboo_1Node = SCNNode()
        bamboo_1Node.name = "bamboo"
        bamboo_1Node.addChildNode(bamboo_1!)
        bamboo_1Node.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        bamboo_1Node.scale = SCNVector3Make(3, 3, 3)
        bamboo_1Node.position = SCNVector3Make(0, 0, -40)
        //world.addChildNode(bamboo_1Node)
        
        let fern = scene.rootNode.childNodeWithName("fern", recursively: true)
        let fernNode = SCNNode()
        fernNode.name = "fern"
        fernNode.addChildNode(fern!)
        fernNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        fernNode.scale = SCNVector3Make(10, 10, 10)
        fernNode.position = SCNVector3Make(0, 0, -70)
        //world.addChildNode(fernNode)
        
        let lily = scene.rootNode.childNodeWithName("lily", recursively: true)
        let lilyNode = SCNNode()
        lilyNode.name = "lily"
        lilyNode.addChildNode(lily!)
        lilyNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        lilyNode.scale = SCNVector3Make(10, 10, 10)
        lilyNode.position = SCNVector3Make(0, 0, -80)
        //world.addChildNode(lilyNode)
        
        let light = SCNLight()
        light.type = SCNLightTypeOmni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(0, 10, -70)
        world.addChildNode(lightNode)
        
        let nodes = [barrelNode, bamboo_1Node, lilyNode, rockNode, treeNode, treeNode, treeNode, treeNode, treeNode, fernNode]
        
        generateRandomNodesOnMap(nodes, mapNode: world, widthOfMap: 300, lengthOfMap: 300, count: 50, yValue: 0, isDestroyable: false)
        
        addShaders()
        
    }
    
    func addShaders(){
        ///////////////////////////////////
        let torus1 = SCNTorus(ringRadius: 1, pipeRadius: 0.5)
        let torusNode1 = SCNNode(geometry: torus1)
        world.addChildNode(torusNode1)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.greenColor()
        torusNode1.geometry?.firstMaterial = material
        
        torusNode1.position.z = -20
        
        var shaders = NSMutableDictionary()
        
        do {
            
            shaders[SCNShaderModifierEntryPointFragment] = try String(contentsOfFile: NSBundle.mainBundle().pathForResource("colorShader", ofType: "fsh")!, encoding: NSUTF8StringEncoding)
            
        } catch {
            print("error making shader")
        }
      
        if let shaders = shaders as? NSDictionary {
            
            if let shaderDict = shaders as? [String: String] {
                material.shaderModifiers = shaderDict
            }
        }
        ///////////////////////////////////
    }

}

extension VRBaseScene {
    
    func setUpBuildMode(){
        
        buildModeNode = BuilderTools(size: 50, divisions: 10)
        self.world.addChildNode(buildModeNode!)
        buildModeNode!.cameraNode = self.cameraNode
        buildModeNode!.setUpTools()
        
    }
}

