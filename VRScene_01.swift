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
    let sliderNode = SCNNode()
  
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
    
            if bone.position.x > sliderNode.position.x {
                bone.eulerAngles.x += GLKMathDegreesToRadians(1)
            }
           
            
            }
        case ".":     for bone in waveSkinner.bones {
            
            if bone.position.x > sliderNode.position.x {
                bone.eulerAngles.x -= GLKMathDegreesToRadians(1)
            }
            
            }
            
        case "<":     for bone in waveSkinner.bones {
            
           
            bone.eulerAngles.y += GLKMathDegreesToRadians(1)
            
            
            
            }
        case ">":     for bone in waveSkinner.bones {
            
         
            bone.eulerAngles.y -= GLKMathDegreesToRadians(1)
            
            
            }
        case leftKey: print("left")
        //cameraNode.position.x -= speed
        let input: Float = control?.leftThumbstickLeft == 0.5 ? 0.0 : 0.5
        control?.leftThumbstickLeft = input
        control?.leftThumbstickRight = 0
        case rightKey: print("right")
        //cameraNode.position.x += speed
        let input: Float = control?.leftThumbstickRight == 0.5 ? 0.0 : 0.5
        control?.leftThumbstickRight = input
        control?.leftThumbstickLeft = 0
        case forwardKey: print("forward")
        //cameraNode.position.z -= speed
        let input: Float = control?.leftThumbstickUp == 0.5 ? 0.0 : 0.5
        control?.leftThumbstickUp = input
        control?.leftThumbstickDown = 0
        case backKey: print("back")
        //cameraNode.position.z += speed
        let input: Float = control?.leftThumbstickDown == 0.5 ? 0.0 : 0.5
        control?.leftThumbstickDown = input
        control?.leftThumbstickUp = 0
        case upKey: print("up")
        //cameraNode.position.y += speed
        let input: Float = control?.rightThumbstickUp == 0.5 ? 0.0 : 0.5
        control?.rightThumbstickUp = input
        control?.rightThumbstickDown = 0
        case downKey: print("down")
        //cameraNode.position.y -= speed
        let input: Float = control?.rightThumbstickDown == 0.5 ? 0.0 : 0.5
        control?.rightThumbstickDown = input
        control?.rightThumbstickUp = 0
        case quitKey: cameraNode.position = SCNVector3Zero
            
        default: return
            
        }
        

        
    }
    
    override func doAdditionalUpdate(headTransform: GVRHeadTransform) {
       
        sliderNode.position.x -= 0.1
        
        //rotateBones()
   
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
        waveSkinner.skeleton?.scale = SCNVector3Make(10, 10, 10)
        world.addChildNode(waveNode)
        
        waveNode.addChildNode(sliderNode)
        let box = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0)
        sliderNode.geometry = box
        sliderNode.position = SCNVector3Zero
        
        
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

