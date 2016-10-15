//
//  MyTestScene.swift
//  
//
//  Created by Eric Mead on 10/9/16.
//
//


import Foundation
import SceneKit
import SpriteKit
import GameController


@objc(MyTestScene)
class MyTestScene : NSObject, VRControllerProtocol, SCNPhysicsContactDelegate {
    
    let leftKey = "a"
    let rightKey = "d"
    let forwardKey = "w"
    let backKey = "s"
    let quitKey = "p"
    
    var camNode = SCNNode()
    var scene = SCNScene();
    var cameraNode: SCNNode!
    var control: ControlScheme?

    var usingExtendedGamePad = false
    var usingStandardGamePad = false
   
    let world = SCNNode();
    let cursor = SCNNode();
    let infoLabel = SKLabelNode(text: "...")
    let infoLabelNode = SCNNode()
    var boxes = SCNNode();
    var timer = NSTimer()
    var time = 0.0
    
    var doingSomething: Bool = false
    
    let boardNode = SCNNode()
    
    var focusedNode : SCNNode?
    
    let greyMaterial = VRControllerSwift.material(color: .grayColor())
    let purpleMaterial = VRControllerSwift.material(color: .purpleColor())


    func setUpExtendedController(controller: GCController) {
        print("setting up extended controller")
        controller.extendedGamepad?.valueChangedHandler = {
            (gamepad: GCExtendedGamepad, element: GCControllerElement) in
            
            self.usingExtendedGamePad = true
            //for multiplayer:
            //if gamepad.controller?.playerIndex == .Index1 {
                //this is player1
            //} else {
                //this is player2
            //}
            
            if gamepad.buttonA == element {
                if gamepad.buttonA.pressed {
                    print("button A pressed")
                    self.control?.buttonAPressed = true
                } else if !gamepad.buttonA.pressed {
                    print("let go button A")
                    self.control?.buttonAPressed = false
                    //reset to 0
                    self.cameraNode.position = SCNVector3Zero
                }
            } else if gamepad.buttonB == element {
                if gamepad.buttonB.pressed {
                    print("button B pressed")
                    self.control?.buttonBPressed = true
                } else if !gamepad.buttonB.pressed {
                    self.control?.buttonBPressed = false
                    print("let go button B")
                }
            } else if gamepad.buttonX == element {
                if gamepad.buttonX.pressed {
                    print("button X pressed")
                } else if !gamepad.buttonX.pressed {
                    print("let go button X")
                }
            } else if gamepad.buttonY == element {
                if gamepad.buttonY.pressed {
                    print("button Y pressed")
                } else if !gamepad.buttonY.pressed {
                    print("let go button Y")
                }
            } else if gamepad.leftTrigger == element {
                if gamepad.leftTrigger.pressed {
                    print("leftTrigger pressed")
                    self.control?.leftTriggerPressed = true
                } else if !gamepad.leftTrigger.pressed {
                    print("let go leftTrigger")
                    self.control?.leftTriggerPressed = false
                }
            } else if gamepad.rightTrigger == element {
                if gamepad.rightTrigger.pressed {
                    print("rightTrigger pressed")
                    self.control?.rightTriggerPressed = true
                } else if !gamepad.rightTrigger.pressed {
                    print("let go rightTrigger")
                    self.control?.rightTriggerPressed = false
                }
            } else if gamepad.leftShoulder == element {
                if gamepad.leftShoulder.pressed {
                    print("leftShoulder pressed")
                } else if !gamepad.leftShoulder.pressed {
                    print("let go leftShoulder")
                }
            } else if gamepad.rightShoulder == element {
                if gamepad.rightShoulder.pressed {
                    print("rightShoulder pressed")
                } else if !gamepad.rightShoulder.pressed {
                    print("let go rightShoulder")
                }
            } else if (gamepad.leftThumbstick == element) {
                if (gamepad.leftThumbstick.left.value > 0.2) {
                    //do something for a left thumbstick movement in the left direction
                    print("left thumb left value: \(gamepad.leftThumbstick.left.value)")
                    self.control?.leftThumbstickLeft = gamepad.leftThumbstick.left.value
                } else if (gamepad.leftThumbstick.right.value > 0.2) {
                    //do something for a left thumbstick movement in the right direction
                    print("left thumb right value: \(gamepad.leftThumbstick.right.value)")
                      self.control?.leftThumbstickRight = gamepad.leftThumbstick.right.value
                } else if (gamepad.leftThumbstick.up.value > 0.2) {
                    //do something for a left thumbstick movement in the up direction
                    print("left thumb up value: \(gamepad.leftThumbstick.up.value)")
                      self.control?.leftThumbstickUp = gamepad.leftThumbstick.up.value
                }else if (gamepad.leftThumbstick.down.value > 0.2) {
                    //do something for a left thumbstick movement in the down direction
                    print("left thumb down value: \(gamepad.leftThumbstick.down.value)")
                      self.control?.leftThumbstickDown = gamepad.leftThumbstick.down.value
                }else if (gamepad.leftThumbstick.left.pressed == false) {
                    // do something if the left movement is let go of
                    self.control?.leftThumbstickUp = 0
                    self.control?.leftThumbstickDown = 0
                    self.control?.leftThumbstickLeft = 0
                    self.control?.leftThumbstickRight = 0
                }
            } else if (gamepad.rightThumbstick == element) {
                if (gamepad.rightThumbstick.right.value > 0.2) {
                    //do something for a right thumbstick movement in the right direction
                    print("right thumb right value: \(gamepad.rightThumbstick.right.value)")
                    self.control?.rightThumbstickRight = gamepad.rightThumbstick.right.value
                } else if (gamepad.rightThumbstick.left.value > 0.2) {
                    //do something for a right thumbstick movement in the left direction
                    print("right thumb left value: \(gamepad.rightThumbstick.left.value)")
                    self.control?.rightThumbstickLeft = gamepad.rightThumbstick.left.value
                    
                }else if (gamepad.rightThumbstick.up.value > 0.2) {
                    //do something for a right thumbstick movement in the up direction
                    print("right thumb up value: \(gamepad.rightThumbstick.up.value)")
                    self.control?.rightThumbstickUp = gamepad.rightThumbstick.up.value
                }else if (gamepad.rightThumbstick.down.value > 0.2) {
                    //do something for a right thumbstick movement in the down direction
                    print("right thumb down value: \(gamepad.rightThumbstick.down.value)")
                    self.control?.rightThumbstickDown = gamepad.rightThumbstick.down.value
                } else if (gamepad.rightThumbstick.right.pressed == false) {
                    // do something if the right movement is let go of
                    self.control?.rightThumbstickUp = 0
                    self.control?.rightThumbstickDown = 0
                    self.control?.rightThumbstickRight = 0
                    self.control?.rightThumbstickLeft = 0
                }
            } else if gamepad.dpad == element {
                
                if (gamepad.dpad.right.value > 0.1) {
                    print("dpad right")
                } else if (gamepad.dpad.right.value == 0.0) {
                    print("released right dpad")
                }
                if (gamepad.dpad.left.value > 0.1) {
                    print("dpad left")
                } else if (gamepad.dpad.left.value == 0.0) {
                    print("released left dpad")
                }
                
                if (gamepad.dpad.up.value > 0.1) {
                    print("dpad up")
                } else if (gamepad.dpad.up.value == 0.0) {
                    print("released up dpad")
                }
                
                if (gamepad.dpad.down.value > 0.1) {
                    print("dpad down")
                } else if (gamepad.dpad.down.value == 0.0) {
                    print("released down dpad")
                }
            }
            
            
        }
        
        
    }
    
 
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
        if isCollisionBetween(CC.bullet, nodeTypeTwo: CC.destroyable, contact: contact) {
            
            print("bullet hit destroyable")
            if contact.nodeA.physicsBody?.categoryBitMask == CC.destroyable.rawValue {
                
                let action = SCNAction.moveBy(SCNVector3Make(0, 3, 0), duration: 0.2)
                let action2 = action.reversedAction()
                contact.nodeA.runAction(SCNAction.sequence([action, action2]))
                
            } else if contact.nodeB.physicsBody?.categoryBitMask == CC.destroyable.rawValue{
                
                let action = SCNAction.moveBy(SCNVector3Make(0, 3, 0), duration: 0.2)
                let action2 = action.reversedAction()
                contact.nodeB.runAction(SCNAction.sequence([action, action2]))
            }
            
        }
    }
    /////////////////////////////////////////////////////////////
    static func material(color color : UIColor) -> SCNMaterial {
        let m = SCNMaterial();
        m.diffuse.contents = color;
        return m;
    }
    
    func countUp(){
        //print("time incremented: \(time)")
        time += 0.1
    }
    
 
    
    required override init() {
        
        print("loaded vr scene")
        
        super.init()
        setUp()
       
        scene.physicsWorld.contactDelegate = self
    }
    
    var xAdjust: Float = 0
    var xSwitch:Float = 1
    var maxX: Float = 4
    var minX: Float = -4
    var ySwitch:Float = 1
    var yAdjust: Float = 0
    var maxY: Float = 2
    var minY: Float = -2
    var lastPosition: SCNVector3 = SCNVector3Make(0, 0, -100)
    
    func generateSphereFocalPointAt(location: SCNVector3, color: UIColor, size: CGFloat){
        
        if self.lastPosition.z - cameraNode.position.z < -40 {
            self.lastPosition.z = -20
            self.cameraNode.position.z = 0
        }
        
        let newPosition = SCNVector3Make(self.lastPosition.x + (xAdjust), self.lastPosition.y + (yAdjust), self.lastPosition.z - 10)
        lastPosition = newPosition
        let sphere = SCNNode.init(geometry: SCNSphere.init(radius: size))
        sphere.geometry?.materials.first?.diffuse.contents = color
        sphere.position = newPosition
        sphere.physicsBody = SCNPhysicsBody.staticBody()
        boxes.addChildNode(sphere)
        
        let remove = SCNAction.removeFromParentNode()
        let delay = SCNAction.waitForDuration(20)
        let seq = SCNAction.sequence([delay, remove])
        sphere.runAction(seq)
        
        xAdjust += xSwitch
        yAdjust += ySwitch
        
        if xAdjust >= maxX || xAdjust <= minX {
            xSwitch = xSwitch * -1
        }
        
        if yAdjust >= maxY || yAdjust <= minY {
            ySwitch = ySwitch * -1
        }
    }
    
    
  
    func prepareFrameWithHeadTransform(headTransform: GVRHeadTransform) {
        
        if focusedNode != nil {
            //print("time:  \(time)")
            if time >= 0.5 {
                //they focused on something for that long
                eventTriggered()
            }
        }
        
        if cameraNode.position.y <= 0 {
           cameraNode.position.y = 0
        }
        
        
        if usingExtendedGamePad == true {
            
            let moveX = (control?.leftThumbstickRight)! - (control?.leftThumbstickLeft)!
            let moveY = (control?.rightThumbstickUp)! - (control?.rightThumbstickDown)!
            let moveZ = (control?.leftThumbstickDown)! - (control?.leftThumbstickUp)!
            let rotateBy = (control?.rightThumbstickLeft)! - (control?.rightThumbstickRight)!
            
            let actionH = SCNAction.rotateByAngle(CGFloat(GLKMathDegreesToRadians(rotateBy)), aroundAxis: SCNVector3Make(0, 1, 0), duration: 0.1)
            cameraNode.runAction(actionH)
            
            let newTransform = self.moveCamera(cameraNode.transform, x: moveX, y: moveY, z: moveZ)
            cameraNode.transform = newTransform
   
        }
       
        cursor.position = headTransform.rotateVector(SCNVector3(0, -3, -20));
     
        let headRot: GLKQuaternion  =
            GLKQuaternionMakeWithMatrix4(GLKMatrix4Transpose(headTransform.headPoseInStartSpace()))

//        let yRot = Float(headRot.y)
//        print(GLKMathRadiansToDegrees(yRot))
//        control?.currentLookDirection =   setCurrentMoveState(CGFloat(GLKMathRadiansToDegrees(yRot)))
//        let state: MoveStates = (control?.currentLookDirection)!
//        
//        let speed : Float = 0.02
//        switch state {
//            
//        case .N : cameraNode.position.z -= 0
//        case .NE : cameraNode.position.z -= 0
//        cameraNode.position.x += speed
//        case .NW : cameraNode.position.z -= 0
//        cameraNode.position.x -= speed
//        case .S : cameraNode.position.z += 0
//        case .SE : cameraNode.position.z += 0
//        cameraNode.position.x += speed
//        case .SW : cameraNode.position.z += 0
//        cameraNode.position.x -= speed
//        case .E : cameraNode.position.x += speed
//        case .W : cameraNode.position.x -= speed
//        default : break
//        }
    
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
        let positionLine = SCNVector3Make(cameraNode.position.x, cameraNode.position.y - 1, cameraNode.position.z - 1)
        let projected: SCNVector3  = multipliedByRotation(p2, rotation: cameraNode.rotation)
    
        if ((control?.buttonBPressed) == true) {
            print("trying to shoot")
            let line = CylinderLine(parent: boxes, v1: positionLine, v2: projected, radius: 0.2, radSegmentCount: 10, color: UIColor.redColor())
            line.name = "projectionLine"
            //world.addChildNode(line)
            let remove = SCNAction.removeFromParentNode()
            let delay = SCNAction.waitForDuration(1)
            let seq = SCNAction.sequence([delay, remove])
            //line.runAction(seq)
            
            let bullet = SCNSphere(radius: 0.4)
            bullet.materials.first?.diffuse.contents = UIColor.yellowColor()
            let bulletNode = SCNNode(geometry: bullet)
            bulletNode.position = positionLine
        
            bulletNode.physicsBody = SCNPhysicsBody(type: SCNPhysicsBodyType.Kinematic, shape: SCNPhysicsShape(geometry: bullet, options: nil))
            bulletNode.physicsBody?.categoryBitMask = CC.bullet.rawValue
            bulletNode.physicsBody?.contactTestBitMask = CC.destroyable.rawValue
            bulletNode.physicsBody?.collisionBitMask = CC.destroyable.rawValue
            
            world.addChildNode(bulletNode)
            let shootAction = SCNAction.moveTo(projected, duration: 2)
            let seqBullet = SCNAction.sequence([shootAction, delay, remove])
            bulletNode.runAction(seqBullet)
        }
        
        if control?.rightTriggerPressed == true {
            let pos = positionLine
            shootBullet(pos, to: projected, color: UIColor.redColor(), size: 0.25)
        }
        
        if control?.leftTriggerPressed == true {
            let pos = positionLine
            shootBullet(pos, to: projected, color: UIColor.blueColor(), size: 0.25)
        }
        
        let hits = boxes.hitTestWithSegmentFromPoint(position, toPoint: p2, options: [SCNHitTestFirstFoundOnlyKey: true]);
        
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
        
        boxes.enumerateChildNodesUsingBlock { (node, end) in
            node.geometry?.materials.first?.emission.contents = UIColor.clearColor()
        };
        
        focusedNode?.geometry?.materials.first?.emission.contents = UIColor.yellowColor().colorWithAlphaComponent(0.3)

    }
    
    func shootBullet(from: SCNVector3, to:SCNVector3, color: UIColor, size : CGFloat) {
        
        let bullet = SCNSphere(radius: size)
        bullet.materials.first?.diffuse.contents = color
        let bulletNode = SCNNode(geometry: bullet)
        bulletNode.position = from
        
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
    
    func startFocusCount(){
        
        time = 0
        
    }
    
    func eventTriggered() {
        //focusedNode?.removeFromParentNode();
   
        //cameraNode.eulerAngles.y += GLKMathDegreesToRadians(10)
        
        guard doingSomething == false else {return}
        
        if let pos = focusedNode?.position {
            doingSomething = true
            let action = SCNAction.moveTo(pos, duration: 0.5)
            action.timingMode = .EaseOut
            let delay = SCNAction.waitForDuration(0)
            let runBlock = SCNAction.runBlock({ (node) in
                self.doingSomething = false
            })
            let seq = SCNAction.sequence([action, delay, runBlock])
            //cameraNode.runAction(seq)
        }
     
      
        print("fired!")
        
        //self.generateSphereFocalPointAt(SCNVector3Zero, color: UIColor.purpleColor(), size: 2)
    }
    
    
    func setUp(){
    //MARK: SETUP
        
        let image = UIImage(named: "BG.png")
        //self.scene.background.contents = image
        self.scene.background.contents = [
            "art.scnassets/skybox/right.jpg",
            "art.scnassets/skybox/left.jpg",
            "art.scnassets/skybox/top.jpg",
            "art.scnassets/skybox/bottom.jpg",
            "art.scnassets/skybox/back.jpg",
            "art.scnassets/skybox/front.jpg",
        ]

        
        world.addChildNode(boxes)
        
        let floorBox = SCNNode.init(geometry: SCNBox(width: 200, height: 20, length: 200, chamferRadius: 0))
        floorBox.geometry?.materials.first?.diffuse.contents = UIImage(named: "Grass.png")
        
        floorBox.geometry?.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
        floorBox.geometry?.firstMaterial?.diffuse.wrapT = SCNWrapMode.Repeat
        
        floorBox.position = SCNVector3(0, -20, 0)
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
        
//        scene.rootNode.addChildNode(infoLabelNode)
//        infoLabel.fontSize = 20
//        infoLabel.fontColor = SKColor.blackColor()
//        infoLabelNode.geometry = SCNBox(width: 1, height: 1, length: 1, chamferRadius: 0.2)
    
        scene.rootNode.addChildNode(world)
     
        timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: #selector(MyTestScene.countUp), userInfo: nil, repeats: true)
        
        control = ControlScheme()
        
        let distance = 50.0
        let sizeRadius:CGFloat = 3.0
        
        let material1 = SCNMaterial()
        material1.diffuse.contents = UIColor.blackColor()
        material1.specular.contents = UIColor.whiteColor()
        material1.shininess = 100.0
        material1.reflective.contents = scene.background.contents
        
        let backSphereN = SCNNode.init(geometry: SCNSphere.init(radius: sizeRadius))
        //backSphereN.geometry?.materials.first?.diffuse.contents = UIColor.blueColor()
        backSphereN.geometry?.firstMaterial = material1
        backSphereN.position = SCNVector3(0, 0, -distance)
        backSphereN.physicsBody = SCNPhysicsBody.staticBody()
        backSphereN.physicsBody!.categoryBitMask = CC.destroyable.rawValue
        backSphereN.physicsBody!.contactTestBitMask = CC.bullet.rawValue
        backSphereN.physicsBody!.collisionBitMask = CC.bullet.rawValue
        boxes.addChildNode(backSphereN)
        
        let backSphereS = SCNNode.init(geometry: SCNSphere.init(radius: sizeRadius))
        backSphereS.geometry?.materials.first?.diffuse.contents = UIColor.redColor()
        backSphereS.position = SCNVector3(0, 0, distance)
        backSphereS.physicsBody = SCNPhysicsBody.staticBody()
        backSphereS.physicsBody!.categoryBitMask = CC.destroyable.rawValue
        backSphereS.physicsBody!.contactTestBitMask = CC.bullet.rawValue
        backSphereS.physicsBody!.collisionBitMask = CC.bullet.rawValue
        boxes.addChildNode(backSphereS)
        
        let backSphereE = SCNNode.init(geometry: SCNSphere.init(radius: sizeRadius))
        backSphereE.geometry?.materials.first?.diffuse.contents = UIColor.greenColor()
        backSphereE.position = SCNVector3(distance, 0, 0)
        backSphereE.physicsBody = SCNPhysicsBody.staticBody()
        backSphereE.physicsBody!.categoryBitMask = CC.destroyable.rawValue
        backSphereE.physicsBody!.contactTestBitMask = CC.bullet.rawValue
        backSphereE.physicsBody!.collisionBitMask = CC.bullet.rawValue
        boxes.addChildNode(backSphereE)
        
        let backSphereW = SCNNode.init(geometry: SCNSphere.init(radius: sizeRadius))
        backSphereW.geometry?.materials.first?.diffuse.contents = UIColor.whiteColor()
        backSphereW.position = SCNVector3(-distance, 0, 0)
        backSphereW.physicsBody = SCNPhysicsBody.staticBody()
        backSphereW.physicsBody!.categoryBitMask = CC.destroyable.rawValue
        backSphereW.physicsBody!.contactTestBitMask = CC.bullet.rawValue
        backSphereW.physicsBody!.collisionBitMask = CC.bullet.rawValue
        boxes.addChildNode(backSphereW)
        
        setUpControllerObservers()
        connectControllers()
        
        let scene2 = SCNScene(named: "art.scnassets/board.dae")!
        let board = scene2.rootNode.childNodeWithName("Board", recursively: true)!
        
        boardNode.addChildNode(board)
        boardNode.scale = SCNVector3Make(2, 2, 2)
        boardNode.position = SCNVector3Make(0, 0, -5)
        boardNode.eulerAngles.y = GLKMathDegreesToRadians(45)
        boxes.addChildNode(boardNode)
        
     
        
        ///////
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

extension MyTestScene {
    
    func handleKeyboardEvents(input: String) {
        
        let speed : Float = 1
        
        switch input {
            
        case leftKey: print("left")
        cameraNode.position.x -= speed
        case rightKey: print("right")
        cameraNode.position.x += speed
        case forwardKey: print("forward")
        cameraNode.position.z -= speed
        case backKey: print("back")
        cameraNode.position.z += speed
        case quitKey: cameraNode.position = SCNVector3Zero
            
        default: return
            
        }
        
    }
}

extension MyTestScene {
    
    func duplicateNode(node: SCNNode, material:SCNMaterial) -> SCNNode
    {
        let newNode: SCNNode = node.clone()
        newNode.geometry = node.geometry?.copy() as? SCNGeometry
        newNode.geometry?.firstMaterial = material
        
        return newNode
    }
}

extension MyTestScene {
    
    func multipliedByRotation(position: SCNVector3, rotation: SCNVector4)-> SCNVector3 {
        
        if (rotation.w == 0) {
            return position
        }
        let gPosition : GLKVector3 = SCNVector3ToGLKVector3(position);
        let gRotation : GLKMatrix4 = GLKMatrix4MakeRotation(rotation.w, rotation.x, rotation.y, rotation.z)
        let r : GLKVector3 = GLKMatrix4MultiplyVector3(gRotation, gPosition)
        
        return SCNVector3FromGLKVector3(r)
        
    }
    
    
    
    
    func moveCamera(matrix: SCNMatrix4, x: Float, y: Float, z: Float)->SCNMatrix4
    {
        
        let x: Float = x
        let y: Float = y
        let z: Float = z
        
        var cameraTransform = cameraNode.transform
        
        let rotatedPosition: SCNVector3  = multipliedByRotation(SCNVector3Make(x, y, z), rotation: cameraNode.rotation)
        
        cameraTransform = SCNMatrix4Translate(cameraTransform, rotatedPosition.x, rotatedPosition.y, rotatedPosition.z)
        
        return cameraTransform
        
    }

}

extension MyTestScene {
    // MARK: Game Controller
    func setUpControllerObservers(){
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyTestScene.connectControllers), name: GCControllerDidConnectNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MyTestScene.controllersDisconnected), name: GCControllerDidDisconnectNotification, object: nil)
    }
    
    func connectControllers(){
        
        self.scene.paused = false
        
        for controller in GCController.controllers() {
            
            if controller.extendedGamepad != nil {
                controller.extendedGamepad?.valueChangedHandler = nil
                setUpExtendedController(controller)
                
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



