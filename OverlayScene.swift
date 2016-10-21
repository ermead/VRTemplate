//
//  OverlayScene.swift
//  VRTemplate
//
//  Created by Eric Mead on 10/16/16.
//  Copyright © 2016 Eric Mead. All rights reserved.
//

import Foundation
import SpriteKit

struct Hub {
    
    let image = SKSpriteNode(imageNamed: "Grass.png")
    var overlayHealth:String = "100"
    let health = SKLabelNode(text: "Test")
}


class OverlayScene : SKScene {

    override init() {
        
        super.init(size: CGSize(width: 200, height: 200))
        
        print("loaded overlayScene")
        
//        let hub = Hub()
//        let node = hub.image
//        node.position.x = self.size.width/2
//        node.position.y  = self.size.height/2
//        node.size = CGSize(width: 50, height: 50)
//        self.addChild(node)
//        
//        let nodeHealth = hub.health
//        nodeHealth.fontSize = 24
//        nodeHealth.fontColor = SKColor.whiteColor()
//        nodeHealth.position.x = 4 * (self.size.width/5)
//        nodeHealth.position.y  = 4 * (self.size.height/5)
//        self.addChild(nodeHealth)
        
        let scene = SKScene(fileNamed: "art.scnassets/SpriteKitScene.sks")
        let scene1 = scene?.scene

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}