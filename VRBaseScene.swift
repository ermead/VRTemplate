//
//  VRBaseScene.swift
//  VRTemplate
//
//  Created by Eric Mead on 10/14/16.
//  Copyright © 2016 Eric Mead. All rights reserved.
//


import Foundation
import SceneKit
import SpriteKit
import GameController

struct ControlScheme {
    
    //this is the projected line from the camera to the cursor
    var from: SCNVector3 = SCNVector3Zero
    var projected: SCNVector3 = SCNVector3Zero
    //
    
    var currentLookDirection: MoveStates?
    
    var leftThumbstickUp: Float = 0.0
    var leftThumbstickDown: Float = 0.0
    var leftThumbstickRight: Float = 0.0
    var leftThumbstickLeft: Float = 0.0
    
    var rightThumbstickUp: Float = 0.0
    var rightThumbstickDown: Float = 0.0
    var rightThumbstickRight: Float = 0.0
    var rightThumbstickLeft: Float = 0.0
    
    var buttonAPressed = false
    var buttonBPressed = false
    var leftTriggerPressed = false
    var rightTriggerPressed = false
}

enum MoveStates: Int {
    case N,S,E,W,NE,NW,SE,SW
}

enum CC: Int {
    
    case bullet = 1
    case destroyable
    case floor
    
}

@objc(VRBaseScene)
class VRBaseScene : NSObject, VRControllerProtocol, SCNPhysicsContactDelegate {
    
    let leftKey = "a"
    let rightKey = "d"
    let forwardKey = "w"
    let backKey = "s"
    let upKey = "q"
    let downKey = "z"
    let quitKey = "p"
    
    var camNode = SCNNode()
    var scene = SCNScene();
    var cameraNode: SCNNode!
    var control: ControlScheme?
    
    var usingExtendedGamePad = false
    var usingStandardGamePad = false
    
    let world = SCNNode();
    let cursor = SCNNode();
    
    //things in the world that one can focus the cursor on
    var things = SCNNode();
    var timer = NSTimer()
    var time = 0.0
    
    var doingSomething: Bool = false
    var focusedNode : SCNNode?
    
    var backgroundContents: AnyObject = [
        
        "art.scnassets/skybox/right.jpg",
        "art.scnassets/skybox/left.jpg",
        "art.scnassets/skybox/top.jpg",
        "art.scnassets/skybox/bottom.jpg",
        "art.scnassets/skybox/back.jpg",
        "art.scnassets/skybox/front.jpg",
        ]
    
    var floorContents: AnyObject = UIImage(named: "Grass.png")!
    
    var waveNode = SCNNode()

    func countUp(){
        //print("time incremented: \(time)")
        time += 0.1
    }
    
    func startFocusCount(){
        
        time = 0
        
    }
    

    required override init() {
        
        print("loaded vr base scene")
        
        super.init()
        
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(MyTestScene.countUp), userInfo: nil, repeats: true)
        control = ControlScheme()
        setUpScene()
        scene.physicsWorld.contactDelegate = self
        setUpControllerObservers()
        connectControllers()
    }
    
    func playerDidFocus(){
        // override by subclass
        
        guard doingSomething == false else {return}
        guard usingExtendedGamePad == false else {return}
        
        if let pos = focusedNode?.position {
            doingSomething = true
            let action = SCNAction.moveTo(pos, duration: 0.5)
            action.timingMode = .EaseOut
            let delay = SCNAction.waitForDuration(0)
            let runBlock = SCNAction.runBlock({ (node) in
                self.doingSomething = false
            })
            let seq = SCNAction.sequence([action, delay, runBlock])
           
            cameraNode.runAction(seq)
            
        }
    }
    
    func bulletDidHitDestroyable(node: SCNNode, with: String){
        
        guard node.physicsBody?.categoryBitMask == CC.destroyable.rawValue else {return}
        
        print("\(with) hit something")
        
        if with == "grappling hook" {
            
            let action = SCNAction.moveTo(node.position, duration: 1)
            cameraNode.runAction(action)
            
        } else {
        
        let action = SCNAction.moveBy(SCNVector3Make(0, 3, 0), duration: 0.2)
        let action2 = action.reversedAction()
        node.runAction(SCNAction.sequence([action, action2]))
        
        }
        
    }
    
    func prepareFrameWithHeadTransform(headTransform: GVRHeadTransform) {
        
        if focusedNode != nil {
            //print("time:  \(time)")
            if time >= 0.5 {
                //they focused on something for that long
                playerDidFocus()
            }
        }
        
        if cameraNode.position.y <= 0 {
            cameraNode.position.y = 0
        }
        
        
        //if usingExtendedGamePad == true {
            
            let moveX = (control?.leftThumbstickRight)! - (control?.leftThumbstickLeft)!
            let moveY = (control?.rightThumbstickUp)! - (control?.rightThumbstickDown)!
            let moveZ = (control?.leftThumbstickDown)! - (control?.leftThumbstickUp)!
            let rotateBy = (control?.rightThumbstickLeft)! - (control?.rightThumbstickRight)!
            
            let actionH = SCNAction.rotateByAngle(CGFloat(GLKMathDegreesToRadians(rotateBy)), aroundAxis: SCNVector3Make(0, 1, 0), duration: 0.1)
            cameraNode.runAction(actionH)
        
        if usingExtendedGamePad == true {
            let newTransform = self.moveCamera(cameraNode, x: moveX, y: moveY, z: moveZ)
            cameraNode.transform = newTransform
        } else {
            let newTransform = self.moveCamera(cameraNode, x: moveX, y: moveY, z: moveZ)
            cameraNode.transform = newTransform
        }
        
            
        //}
        
        cursor.position = headTransform.rotateVector(SCNVector3(0, -3, -20));
    
        // let's create long ray (100 meters) that goes the same way
        // cursor.position is directed
        
        let p2 =
            SCNVector3FromGLKVector3(
                GLKVector3MultiplyScalar(
                    GLKVector3Normalize(
                        SCNVector3ToGLKVector3(cursor.position)
                    ),
                    1000
                )
        );
        
        let position = cameraNode.position
        let positionLine = SCNVector3Make(position.x, position.y - 1,position.z - 1)
        let projected: SCNVector3  = multipliedByRotation(p2, rotation: cameraNode.rotation)
        
        control?.from = positionLine
        control?.projected = projected
        
        if ((control?.buttonBPressed) == true) {
            print("trying to shoot")
            let pos = positionLine
            buttonBPressed(pos, projected: projected)
            //shootBullet(pos, to: projected, color: UIColor.greenColor(), size: 0.25)
        }
        
        if control?.rightTriggerPressed == true {
            let pos = positionLine
            shootBullet(pos, to: projected, color: UIColor.redColor(), size: 0.25, name: "bullet")
        }
        
        if control?.leftTriggerPressed == true {
            let pos = positionLine
            shootBullet(pos, to: projected, color: UIColor.blueColor(), size: 0.25, name: "grappling hook")
        }
        
        let hits = things.hitTestWithSegmentFromPoint(position, toPoint: p2, options: [SCNHitTestFirstFoundOnlyKey: true]);
        
        if let hit = hits.first {
            if hit.node.name == "cursor" {
                return
            }
            if focusedNode == nil {
                startFocusCount()
            }
            focusedNode = hit.node;
        }
        else {
            focusedNode = nil;
        }
        
        things.enumerateChildNodesUsingBlock { (node, end) in
            node.geometry?.materials.first?.emission.contents = UIColor.clearColor()
        };
        
        focusedNode?.geometry?.materials.first?.emission.contents = UIColor.yellowColor().colorWithAlphaComponent(0.3)
        
        doAdditionalUpdate(headTransform)
    }
    
    func shootBullet(from: SCNVector3, to:SCNVector3, color: UIColor, size : CGFloat, name: String) {
        
        let bullet = SCNSphere(radius: size)
        bullet.materials.first?.diffuse.contents = color
        let bulletNode = SCNNode(geometry: bullet)
        bulletNode.position = from
        bulletNode.name = name
        
        bulletNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Kinematic, shape: SCNPhysicsShape(geometry: bullet, options: nil))
        bulletNode.physicsBody?.categoryBitMask = CC.bullet.rawValue
        bulletNode.physicsBody?.contactTestBitMask = CC.destroyable.rawValue
        bulletNode.physicsBody?.collisionBitMask = CC.destroyable.rawValue
        
        world.addChildNode(bulletNode)
        let remove = SCNAction.removeFromParentNode()
        let delay = SCNAction.waitForDuration(1)
        let shootAction = SCNAction.moveTo(to, duration: 2)
        let seqBullet = SCNAction.sequence([shootAction, delay, remove])
        bulletNode.runAction(seqBullet)
        
    }
    
    func buttonBPressed(from: SCNVector3, projected: SCNVector3){
        
        //override by subclass
   
    }
    
  
    
    func eventTriggered() {
        
        print("eventTriggered")
        //override by subclass
        
    }
    
    func doAdditionalSetup(){
        
        //override by subclass
    }
    
    func doAdditionalUpdate(headTransform: GVRHeadTransform){
        
        //override by subclass
    }
    
    
    func setUpScene(){
        //MARK: SETUP SCENE
        self.scene.background.contents = backgroundContents
        
        world.addChildNode(things)
        
        let floorBox = SCNNode.init(geometry: SCNBox(width: 200, height: 20, length: 200, chamferRadius: 0))
        floorBox.geometry?.materials.first?.diffuse.contents = floorContents
        floorBox.geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
        floorBox.geometry?.firstMaterial?.diffuse.wrapT = SCNWrapMode.Repeat
        floorBox.position = SCNVector3(0, -20, 0)
        floorBox.physicsBody = SCNPhysicsBody.staticBody()
        floorBox.physicsBody?.categoryBitMask = CC.floor.rawValue
        world.addChildNode(floorBox)
        
        cameraNode = SCNNode.init(geometry: SCNSphere.init(radius: 10))
        cameraNode.position = SCNVector3(0, 0, 0)
        world.addChildNode(cameraNode)
        cameraNode.addChildNode(camNode)
        cameraNode.addChildNode(cursor)
        
        let light = SCNLight()
        light.type = SCNLightTypeOmni
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(2,20,2)
        world.addChildNode(lightNode)
        
        cursor.geometry = SCNSphere(radius: 0.2)
        cursor.physicsBody = nil
        cursor.name = "cursor"

        scene.rootNode.addChildNode(world)
  
        ///////
        doAdditionalSetup()
        
    
        
        
    }
    
}

extension VRBaseScene {
    
    //MARK: PHYSICS
    /////////////////////////////////////////////////////////////
    func isCollisionBetween(nodeTypeOne: CC, nodeTypeTwo: CC, contact: SCNPhysicsContact)->Bool {
        
        let isANodeTypeOne = contact.nodeA.physicsBody!.categoryBitMask == nodeTypeOne.rawValue
        let isANodeTypeTwo = contact.nodeA.physicsBody!.categoryBitMask == nodeTypeTwo.rawValue
        let isBNodeTypeOne = contact.nodeB.physicsBody!.categoryBitMask == nodeTypeOne.rawValue
        let isBNodeTypeTwo = contact.nodeB.physicsBody!.categoryBitMask == nodeTypeTwo.rawValue
        
        if (isANodeTypeOne && isBNodeTypeTwo) || (isANodeTypeTwo && isBNodeTypeOne) {
            return true
        } else {
            return false
        }
    }
    
    func physicsWorld(world: SCNPhysicsWorld, didBeginContact contact: SCNPhysicsContact) {
        //
        if isCollisionBetween(CC.bullet, nodeTypeTwo: CC.destroyable, contact: contact) {
            
            print("bullet hit destroyable")
            if contact.nodeA.physicsBody?.categoryBitMask == CC.destroyable.rawValue {
                
                self.bulletDidHitDestroyable(contact.nodeA, with: contact.nodeB.name!)
                
                
            } else if contact.nodeB.physicsBody?.categoryBitMask == CC.destroyable.rawValue{
                
                self.bulletDidHitDestroyable(contact.nodeB, with: contact.nodeA.name!)
                
            }
            
        }
        //
    }
    /////////////////////////////////////////////////////////////
}

extension VRBaseScene {
    
    func handleKeyboardEvents(input: String) {
        
        let speed : Float = 3
        
        switch input {
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
}

extension VRBaseScene {
    
    func duplicateNode(node: SCNNode, material:SCNMaterial) -> SCNNode
    {
        let newNode: SCNNode = node.clone()
        newNode.geometry = node.geometry?.copy() as? SCNGeometry
        newNode.geometry?.firstMaterial = material
        
        return newNode
    }
}

extension VRBaseScene {
    
    func multipliedByRotation(position: SCNVector3, rotation: SCNVector4)-> SCNVector3 {
        
        if (rotation.w == 0) {
            return position
        }
        let gPosition : GLKVector3 = SCNVector3ToGLKVector3(position);
        let gRotation : GLKMatrix4 = GLKMatrix4MakeRotation(rotation.w, rotation.x, rotation.y, rotation.z)
        let r : GLKVector3 = GLKMatrix4MultiplyVector3(gRotation, gPosition)
        
        return SCNVector3FromGLKVector3(r)
        
    }
  
    func moveCamera(node: SCNNode, x: Float, y: Float, z: Float)->SCNMatrix4
    {
        
        let x: Float = x
        let y: Float = y
        let z: Float = z
        
        var cameraTransform = node.transform
  
        let rotatedPosition: SCNVector3  = multipliedByRotation(SCNVector3Make(x, y, z), rotation: node.rotation)
        
        cameraTransform = SCNMatrix4Translate(cameraTransform, rotatedPosition.x, rotatedPosition.y, rotatedPosition.z)
        
        return cameraTransform
        
    }
    

    
}

extension VRBaseScene {
    // MARK: Game Controller
    func setUpControllerObservers(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VRBaseScene.connectControllers), name: GCControllerDidConnectNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VRBaseScene.controllersDisconnected), name: GCControllerDidDisconnectNotification, object: nil)
    }
    
    func connectControllers(){
        
        self.scene.paused = false
        
        for controller in GCController.controllers() {
            
            if controller.extendedGamepad != nil {
                controller.extendedGamepad?.valueChangedHandler = nil
                setUpExtendedController(controller, scene: self)
                
            } else if controller.gamepad != nil {
                controller.gamepad?.valueChangedHandler = nil
                setUpStandardController(controller)
            }
        }
    }
    
    func controllersDisconnected(){
        self.scene.paused = true
    }
    
    func setUpStandardController(controller: GCController) {
        print("setting up standard controller")
        
        self.usingStandardGamePad = true
        
    }
}



