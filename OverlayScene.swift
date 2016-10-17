//
//  OverlayScene.swift
//  VRTemplate
//
//  Created by Eric Mead on 10/16/16.
//  Copyright © 2016 Eric Mead. All rights reserved.
//

import Foundation
import SpriteKit


class OverlayScene : SKScene {
    
    var overlayHealth:String = "100"
    
    override init() {
        
        super.init(size: CGSize(width: 200, height: 200))
        
        print("loaded overlayScene")
        
        let node = SKSpriteNode(imageNamed: "Grass.png")
        node.position.x = self.size.width/2
        node.position.y  = self.size.height/2
        node.size = CGSize(width: 50, height: 50)
        self.addChild(node)
        
        let nodeHealth = SKLabelNode(text: overlayHealth)
        nodeHealth.fontSize = 24
        nodeHealth.fontColor = SKColor.whiteColor()
        nodeHealth.position.x = 4 * (self.size.width/5)
        nodeHealth.position.y  = 4 * (self.size.height/5)
        self.addChild(nodeHealth)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}