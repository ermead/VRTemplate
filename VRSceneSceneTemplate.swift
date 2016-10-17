//
//  VRSceneSceneTemplate.swift
//  VRTemplate
//
//  Created by Eric Mead on 10/16/16.
//  Copyright © 2016 Eric Mead. All rights reserved.
//


import SpriteKit

@objc(VRScene_Example_01)
class VRScene_Example_01: VRBaseScene {
    
    var torusNode = SCNNode()
    var waveSkinner = SCNSkinner()
    
    required init() {
        
        print("loaded vr _Example_01")
        
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
    

    override func doAdditionalUpdate(headTransform: GVRHeadTransform) {
        

        
    }

    ////////
    
    func handleButtonB(){
        
        //do something
    }
    
    override func buttonBPressed(from: SCNVector3, projected: SCNVector3){
        print("buttonB pressed")
        print("trajectory...")
        print("from: \(from)")
        print("to: \(projected)")
        
        handleButtonB()
    }
    
    override func doAdditionalSetup() {
        
        //EXAMPLES:
        setUpCompassPoints(things, backgroundContents: backgroundContents, distance: 50.0, sizeRadius: 2.0)
        
        let torusGeometry = SCNTorus(ringRadius: 4, pipeRadius: 1)
        torusGeometry.firstMaterial?.diffuse.contents = UIColor.blackColor()
        torusGeometry.firstMaterial?.specular.contents = UIColor.whiteColor()
        torusGeometry.firstMaterial?.shininess = 100.0
        torusGeometry.firstMaterial?.reflective.contents = scene.background.contents
        torusNode = SCNNode(geometry: torusGeometry)
        torusNode.position = SCNVector3Make(-10, 0, -10)
        world.addChildNode(torusNode)
        ////////
        
        //
        let sceneWave = SCNScene(named: "art.scnassets/testWaveRig.scn")
        let wave = sceneWave!.rootNode.childNodeWithName("wave", recursively: true)
        
        waveSkinner = (wave?.skinner)!
        waveSkinner.skeleton?.position = SCNVector3Zero
        waveSkinner.skeleton?.position.y = 10
        waveNode.addChildNode(wave!)
        waveNode.addChildNode(waveSkinner.skeleton!)
        waveSkinner.skeleton?.scale = SCNVector3Make(10, 10, 10)
        world.addChildNode(waveNode)
        waveNode.eulerAngles.x = GLKMathDegreesToRadians(90)
        //
    
    
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
                treeClone.position = SCNVector3((Double(i) - 5.0) * 15, -10, (Double(j) - 5.0) * 15)
                world.addChildNode(treeClone)
            }
        }
        
    }
    
}

