//
//  GameControllerManager.swift
//  VRTemplate
//
//  Created by Eric Mead on 10/14/16.
//  Copyright © 2016 Eric Mead. All rights reserved.
//

import GameController


func setUpExtendedController(controller: GCController, scene: VRBaseScene) {
    print("setting up extended controller")
    controller.extendedGamepad?.valueChangedHandler = {
        (gamepad: GCExtendedGamepad, element: GCControllerElement) in
        
        scene.usingExtendedGamePad = true
        //for multiplayer:
        //if gamepad.controller?.playerIndex == .Index1 {
        //this is player1
        //} else {
        //this is player2
        //}
        
        if gamepad.buttonA == element {
            if gamepad.buttonA.pressed {
                print("button A pressed")
                scene.control?.buttonAPressed = true
            } else if !gamepad.buttonA.pressed {
                print("let go button A")
                scene.control?.buttonAPressed = false
                //reset to 0
                scene.cameraNode.position = SCNVector3Zero
                scene.cameraNode.rotation = SCNVector4Zero
                scene.world.position = SCNVector3Zero
                scene.world.rotation = SCNVector4Zero
            }
        } else if gamepad.buttonB == element {
            if gamepad.buttonB.pressed {
                print("button B pressed")
                scene.control?.buttonBPressed = true
            } else if !gamepad.buttonB.pressed {
                scene.control?.buttonBPressed = false
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
                scene.control?.leftTriggerPressed = true
            } else if !gamepad.leftTrigger.pressed {
                print("let go leftTrigger")
                scene.control?.leftTriggerPressed = false
            }
        } else if gamepad.rightTrigger == element {
            if gamepad.rightTrigger.pressed {
                print("rightTrigger pressed")
                scene.control?.rightTriggerPressed = true
            } else if !gamepad.rightTrigger.pressed {
                print("let go rightTrigger")
                scene.control?.rightTriggerPressed = false
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
                scene.control?.leftThumbstickLeft = gamepad.leftThumbstick.left.value
            } else if (gamepad.leftThumbstick.right.value > 0.2) {
                //do something for a left thumbstick movement in the right direction
                print("left thumb right value: \(gamepad.leftThumbstick.right.value)")
                scene.control?.leftThumbstickRight = gamepad.leftThumbstick.right.value
            } else if (gamepad.leftThumbstick.up.value > 0.2) {
                //do something for a left thumbstick movement in the up direction
                print("left thumb up value: \(gamepad.leftThumbstick.up.value)")
                scene.control?.leftThumbstickUp = gamepad.leftThumbstick.up.value
            }else if (gamepad.leftThumbstick.down.value > 0.2) {
                //do something for a left thumbstick movement in the down direction
                print("left thumb down value: \(gamepad.leftThumbstick.down.value)")
                scene.control?.leftThumbstickDown = gamepad.leftThumbstick.down.value
            }else if (gamepad.leftThumbstick.left.pressed == false) {
                // do something if the left movement is let go of
                scene.control?.leftThumbstickUp = 0
                scene.control?.leftThumbstickDown = 0
                scene.control?.leftThumbstickLeft = 0
                scene.control?.leftThumbstickRight = 0
            }
        } else if (gamepad.rightThumbstick == element) {
            if (gamepad.rightThumbstick.right.value > 0.2) {
                //do something for a right thumbstick movement in the right direction
                print("right thumb right value: \(gamepad.rightThumbstick.right.value)")
                scene.control?.rightThumbstickRight = gamepad.rightThumbstick.right.value
            } else if (gamepad.rightThumbstick.left.value > 0.2) {
                //do something for a right thumbstick movement in the left direction
                print("right thumb left value: \(gamepad.rightThumbstick.left.value)")
                scene.control?.rightThumbstickLeft = gamepad.rightThumbstick.left.value
                
            }else if (gamepad.rightThumbstick.up.value > 0.2) {
                //do something for a right thumbstick movement in the up direction
                print("right thumb up value: \(gamepad.rightThumbstick.up.value)")
                scene.control?.rightThumbstickUp = gamepad.rightThumbstick.up.value
            }else if (gamepad.rightThumbstick.down.value > 0.2) {
                //do something for a right thumbstick movement in the down direction
                print("right thumb down value: \(gamepad.rightThumbstick.down.value)")
                scene.control?.rightThumbstickDown = gamepad.rightThumbstick.down.value
            } else if (gamepad.rightThumbstick.right.pressed == false) {
                // do something if the right movement is let go of
                scene.control?.rightThumbstickUp = 0
                scene.control?.rightThumbstickDown = 0
                scene.control?.rightThumbstickRight = 0
                scene.control?.rightThumbstickLeft = 0
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
