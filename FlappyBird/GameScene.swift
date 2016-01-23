//
//  GameScene.swift
//  FlappyBird
//
//  Created by Abhigyan Singh on 26/12/15.
//  Copyright (c) 2015 Abhigyan Singh. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    var movingObjects = SKSpriteNode()
    var gameOver = false
    var score = 0
    var scoreLabel = SKLabelNode()
    var gameOverLabel = SKLabelNode()
    var labelContainer = SKLabelNode()
    let wingSFX = SKAction.playSoundFileNamed("sfx_wing.caf", waitForCompletion: false)
    let dieSFX = SKAction.playSoundFileNamed("sfx_die.caf", waitForCompletion: false)
    let swooshSFX = SKAction.playSoundFileNamed("sfx_swoosh.caf", waitForCompletion: false)
    let hitSFX = SKAction.playSoundFileNamed("sfx_hit.caf", waitForCompletion: false)
    let pointSFX = SKAction.playSoundFileNamed("sfx_point.caf", waitForCompletion: false)
    
    enum ColliderType : UInt32 {
        
        case Bird = 1
        case Object = 2
        case Gap = 4
        
    }
    
    override func didMoveToView(view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        self.addChild(movingObjects)
        self.addChild(labelContainer)
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "0"
        scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.frame.size.height - 70)
        self.addChild(scoreLabel)
        
        makeBg()
        makeBird()
        
        let ground = SKNode()
        ground.position = CGPointMake(0, 0)
        ground.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.frame.size.width, 1))
        ground.physicsBody!.dynamic = false
        ground.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        
        self.addChild(ground)
        
        _ = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: Selector("makePipes"), userInfo: nil, repeats: true)
    
    }
    
    func makeBird() {
        
        let birdTexture = SKTexture(imageNamed: "img/flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "img/flappy2.png")
        
        let animation = SKAction.animateWithTextures([birdTexture, birdTexture2], timePerFrame: 0.1)
        let makeBirdFlap = SKAction.repeatActionForever(animation)
        bird = SKSpriteNode(texture: birdTexture)
        bird.position = CGPoint(x: CGRectGetMidX(self.frame), y: CGRectGetMidY(self.frame))
        bird.runAction(makeBirdFlap)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture.size().height/2)
        bird.physicsBody!.dynamic = true
        bird.physicsBody!.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        movingObjects.addChild(bird)

    }
    
    func makeBg() {
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
            movingObjects.addChild(bg)
        }

    }
    
    func makePipes() {
        let gapHeight = bird.size.height * 4
        let movementAmount = arc4random() % UInt32(self.frame.size.height/2)
        let pipeOffset = CGFloat(movementAmount) - self.frame.size.height/4
        let movePipes = SKAction.moveByX(-self.frame.size.width * 2, y: 0, duration: NSTimeInterval(self.frame.width/100))
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes,removePipes])
        
        //Pipe
        let pipeTexture1 = SKTexture(imageNamed: "img/pipe1.png")
        let pipe1 = SKSpriteNode(texture: pipeTexture1)
        pipe1.position = CGPointMake(CGRectGetMidX(self.frame) + self.frame.size.width, CGRectGetMidY(self.frame) + pipeTexture1.size().height/2 + gapHeight/2 + pipeOffset)
        pipe1.runAction(moveAndRemovePipes)
        pipe1.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTexture1.size())
        pipe1.physicsBody!.dynamic = false
        pipe1.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        movingObjects.addChild(pipe1)
        
        let pipeTexture2 = SKTexture(imageNamed: "img/pipe2.png")
        let pipe2 = SKSpriteNode(texture: pipeTexture2)
        pipe2.position = CGPointMake(CGRectGetMidX(self.frame) + self.frame.size.width, CGRectGetMidY(self.frame) - pipeTexture2.size().height/2 - gapHeight/2 + pipeOffset)
        pipe2.runAction(moveAndRemovePipes)
        pipe2.physicsBody = SKPhysicsBody(rectangleOfSize: pipeTexture1.size())
        pipe2.physicsBody!.dynamic = false
        pipe2.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        movingObjects.addChild(pipe2)
        
        let gap = SKNode()
        gap.position = CGPoint(x: CGRectGetMidX(self.frame) + self.frame.size.width, y: CGRectGetMidY(self.frame) + pipeOffset)
        gap.runAction(moveAndRemovePipes)
        gap.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(pipe1.size.width/4, gapHeight))
        gap.physicsBody!.dynamic = false
        gap.physicsBody!.categoryBitMask = ColliderType.Gap.rawValue
        gap.physicsBody!.contactTestBitMask = ColliderType.Bird.rawValue
        gap.physicsBody!.collisionBitMask = ColliderType.Gap.rawValue
        movingObjects.addChild(gap)
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            score++
            scoreLabel.text = String(score)
            runAction(pointSFX)
        }
        else {
            if (gameOver == false) {
                runAction(hitSFX)
                runAction(dieSFX)
                runAction(swooshSFX)
                gameOver = true
                self.speed = 0
                gameOverLabel.fontName = "Helvetica"
                gameOverLabel.fontSize = 30
                gameOverLabel.text = "Game Over! Tap to play again."
                gameOverLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
                labelContainer.addChild(gameOverLabel)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    
        if (gameOver == false) {
            bird.physicsBody!.velocity = CGVectorMake(0, 0)
            bird.physicsBody!.applyImpulse(CGVectorMake(0, 80))
            runAction(wingSFX)
        }
        else {
            score = 0
            scoreLabel.text = "0"
            bird.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
            bird.physicsBody!.velocity = CGVectorMake(0, 0)
            movingObjects.removeAllChildren()
            makeBg()
            makeBird()
            self.speed = 1
            gameOver = false
            labelContainer.removeAllChildren()
            
            
        }
        
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
