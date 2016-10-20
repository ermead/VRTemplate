//
//  BuilderClass.swift
//  VRTemplate
//
//  Created by Eric Mead on 10/19/16.
//  Copyright © 2016 Eric Mead. All rights reserved.
//

import Foundation


class BuilderTools: SCNNode {

//    var node: SCNNode!
    
    override init() {
//        self.node = node
        super.init()
        
        print("loaded build mode")
        
        let box = SCNBox(width: 10, height: 10, length: 10, chamferRadius: 0)
        box.firstMaterial?.diffuse.contents = UIColor.yellowColor()
        let boxNode = SCNNode(geometry: box)
        self.addChildNode(boxNode)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
}