//
//  VRScene_1.swift
//  VRTemplate
//
//  Created by Eric Mead on 10/14/16.
//  Copyright © 2016 Eric Mead. All rights reserved.
//

@objc(VRScene_01)
class VRScene_01: VRBaseScene {
  
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
    
    override func doAdditionalUpdate(headTransform: GVRHeadTransform) {
        
        
        
    }
    
    override func doAdditionalSetup() {
        
        setUpCompassPoints(things, backgroundContents: backgroundContents)
        
        let torusGeometry = SCNTorus(ringRadius: 4, pipeRadius: 1)
        torusGeometry.firstMaterial?.diffuse.contents = UIColor.blackColor()
        torusGeometry.firstMaterial?.specular.contents = UIColor.whiteColor()
        torusGeometry.firstMaterial?.shininess = 100.0
        torusGeometry.firstMaterial?.reflective.contents = scene.background.contents
        let torusNode = SCNNode(geometry: torusGeometry)
        torusNode.position = SCNVector3Make(-10, 0, -10)
        world.addChildNode(torusNode)
        ////////
        
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
                world.addChildNode(treeClone)
            }
        }
 
    }
    
}

