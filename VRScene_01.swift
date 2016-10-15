//
//  VRScene_1.swift
//  VRTemplate
//
//  Created by Eric Mead on 10/14/16.
//  Copyright © 2016 Eric Mead. All rights reserved.
//

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

        switch input {
        case ",":     for bone in waveSkinner.bones {
            
//            if bone.name == "Armature_001_Bone_067_pose_matrix" {
//                bone.eulerAngles.y += GLKMathDegreesToRadians(1)
//            }
            
            bone.eulerAngles.x += GLKMathDegreesToRadians(1)
            
           
            
            }
        case ".":     for bone in waveSkinner.bones {
            
        
            bone.eulerAngles.x -= GLKMathDegreesToRadians(1)
            
            
            }
            
        case "<":     for bone in waveSkinner.bones {
            
           
            bone.eulerAngles.y += GLKMathDegreesToRadians(1)
            
            
            
            }
        case ">":     for bone in waveSkinner.bones {
            
         
            bone.eulerAngles.y -= GLKMathDegreesToRadians(1)
            
            
            }
        case leftKey: print("left")
        cameraNode.position.x -= speed
        case rightKey: print("right")
        cameraNode.position.x += speed
        case forwardKey: print("forward")
        cameraNode.position.z -= speed
        case backKey: print("back")
        cameraNode.position.z += speed
        case upKey: print("up")
        cameraNode.position.y += speed
        case downKey: print("down")
        cameraNode.position.y -= speed
        case quitKey: cameraNode.position = SCNVector3Zero
            
        default: return
            
        }
        
    }
    
    override func doAdditionalUpdate(headTransform: GVRHeadTransform) {
        waveNode.position.x += 1
        
    
        
    }
    
    override func doAdditionalSetup() {
        
        setUpCompassPoints(things, backgroundContents: backgroundContents)
        
        let torusGeometry = SCNTorus(ringRadius: 4, pipeRadius: 1)
        torusGeometry.firstMaterial?.diffuse.contents = UIColor.blackColor()
        torusGeometry.firstMaterial?.specular.contents = UIColor.whiteColor()
        torusGeometry.firstMaterial?.shininess = 100.0
        torusGeometry.firstMaterial?.reflective.contents = scene.background.contents
        torusNode = SCNNode(geometry: torusGeometry)
        torusNode.position = SCNVector3Make(-10, 0, -10)
        world.addChildNode(torusNode)
        ////////
        
        let sceneWave = SCNScene(named: "art.scnassets/testWaveRig.scn")
        let wave = sceneWave!.rootNode.childNodeWithName("wave", recursively: true)
        waveSkinner = (wave?.skinner)!
        waveSkinner.skeleton?.position = SCNVector3Zero
        waveSkinner.skeleton?.position.y -= 10
        waveNode.addChildNode(wave!)
        waveSkinner.skeleton?.scale = SCNVector3Make(100, 100, 10)
        world.addChildNode(waveNode)
        
        
        let scene3 = SCNScene(named: "art.scnassets/testTree.scn")!
        let tree = scene3.rootNode.childNodeWithName("tree", recursively: true)
        let treeNode = SCNNode()
        treeNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
        treeNode.addChildNode(tree!)
        treeNode.scale = SCNVector3Make(5, 8, 5)
        treeNode.position = SCNVector3Make(5, -3, -5)
        world.addChildNode(treeNode)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "testTreeMaterial")
        
        for i in -3 ..< 13 {
            for j in 7 ..< 12 {
                let treeClone: SCNNode = duplicateNode(treeNode, material: material)
                treeClone.pivot = SCNMatrix4MakeTranslation(0, 0, 0)
                treeClone.position = SCNVector3((Double(i) - 5.0) * 5, -5, (Double(j) - 5.0) * 5)
                //world.addChildNode(treeClone)
            }
        }
 
    }
    
}

