//
//  GameScene.swift
//  FlappyBird
//
//  Created by Abhigyan Singh on 26/12/15.
//  Copyright (c) 2015 Abhigyan Singh. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    
    override func didMoveToView(view: SKView) {
        
        //Animate Background
        let bgTexture = SKTexture(imageNamed: "img/bg.png")

        let moveBg = SKAction.moveByX(-bgTexture.size().width, y: 0, duration: 9)
        let replaceBg = SKAction.moveByX(bgTexture.size().width, y: 0, duration: 0)
        let animateBg = SKAction.repeatActionForever(SKAction.sequence([moveBg, replaceBg]))
        
        for var i: CGFloat = 0; i<3; i++ {
            
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/2 + bgTexture.size().width * i, y: CGRectGetMidY(self.frame))
            bg.size.height = self.frame.height
            bg.runAction(animateBg)
            self.addChild(bg)
            
        }
        
        //Animate Bird
        let birdTexture = SKTexture(imageNamed: "img/flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "img/flappy2.png")
        
        let animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatActionForever(animation)
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.runAction(makeBirdFlap)
        self.addChild(bird)
    
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
          
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
