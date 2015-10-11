//
//  GameScene.swift
//  JoystickDOS
//
//  Created by Berganza on 4/10/15.
//  Copyright (c) 2015 Berganza. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let joys = SKSpriteNode(imageNamed: "JOYS")
    let base = SKSpriteNode(imageNamed: "base")
    let nave = SKSpriteNode(imageNamed: "ship")
    
    var velocidadX: CGFloat = 0.0
    var velocidadY: CGFloat = 0.0
    
    var joysActivo:Bool = false
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.cyanColor()
        anchorPoint = CGPointMake(0.5, 0.5)
        
        base.position = CGPointMake(0 - 370, 0 - 190)
        //base.position = CGPointMake(CGRectGetMidX(self.frame) - 370, CGRectGetMinY(self.frame) + 200)
        base.zPosition = 1.0
        base.alpha = 0.2
        addChild(base)
        
        joys.position = base.position
        joys.zPosition = 2.0
        joys.alpha = 0.2
        joys.setScale(0.4)
        addChild(joys)
        
        nave.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame))
        nave.xScale = 0.5
        nave.yScale = 0.5
        
        nave.physicsBody = SKPhysicsBody(rectangleOfSize: nave.frame.size)
        nave.physicsBody!.applyImpulse(CGVectorMake(10, 10))

        self.physicsWorld.gravity = CGVectorMake(0, 0)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect:CGRectMake(
                CGRectGetMinX(self.frame),
                CGRectGetMinY(self.frame) + nave.frame.size.height + 10,
                self.frame.size.width,
                (self.frame.size.height - (nave.frame.size.height + 10) * 2))
                )
        
        addChild(nave)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            if (CGRectContainsPoint(joys.frame, location)){
                joysActivo = true
            } else {
                joysActivo = false
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            if joysActivo == true {
            
                let vector = CGVector(dx: location.x - base.position.x, dy: location.y - base.position.y)
                let angulo = atan2(vector.dy, vector.dx)
                let radio:CGFloat = base.frame.size.height / 2
                
                let xDist:CGFloat = sin(angulo - 1.57079633) * radio
                let yDist:CGFloat = cos(angulo - 1.57079633) * radio
                
                if (CGRectContainsPoint(base.frame, location)) {
                    joys.position = location
                } else {
                    joys.position = CGPointMake(base.position.x - xDist, base.position.y + yDist)
                }
                
                nave.zRotation = angulo - 1.57079633
                
                velocidadX = xDist / 49.0
                velocidadY = yDist / 49.0
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if joysActivo == true {
            let retorno: SKAction = SKAction.moveTo(base.position, duration: 0.05)
            retorno.timingMode = SKActionTimingMode.EaseOut
            joys.runAction(retorno)
            joysActivo = false
            velocidadX = 0
            velocidadY = 0
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        if joysActivo == true {
            nave.position = CGPointMake(nave.position.x - (velocidadX*3), nave.position.y + (velocidadY*3))
        }
    }
}
