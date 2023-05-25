//
//  GameScene.swift
//  CobaNC2
//
//  Created by Wardah on 21/05/23.
//

import SpriteKit
import CoreMotion
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let motionManager  = CMMotionManager()
    
    //    var boardColor = UIColor(red: 0.81, green: 0.67, blue: 0.44, alpha: 1)
    var generateNewTint: Bool = false
    var generateHole: Bool = false
    var newBallColor: Bool = false
    var boardColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    var gameover: Bool = false
    
    var ball: SKSpriteNode!
    var tint : SKSpriteNode!
    var newtint : SKSpriteNode!
    var hole : SKSpriteNode!
    var eatCoins = 0
    
    let tintPositionRange: CGFloat = 390
    let holePositionRange: CGFloat = 390
    
    enum bitMask: UInt32 {
        case ball = 0x1
        case object = 0x2
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        self.backgroundColor = boardColor
        
        
        if motionManager.isAccelerometerAvailable {
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [weak self] (data, error) in
                if let accelerometerData = data {
                    var acceleration = accelerometerData.acceleration
                    
                    // Adjust acceleration values for landscape orientation
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                       windowScene.interfaceOrientation.isLandscape {
                        acceleration = CMAcceleration(x: acceleration.y, y: -acceleration.x, z: acceleration.z)
                    }
                    
                    // Update sprite position based on accelerometer data
                    self?.updateSpritePosition(acceleration)
                }
            }
            
            addBall()
            addHole()
            addTint()
            
        }
        
        
        
    }
    
    
    func addBall() {
        
        ball = childNode(withName: "ball") as? SKSpriteNode
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 50)
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = bitMask.ball.rawValue
        ball.physicsBody?.collisionBitMask = 0
        ball.physicsBody?.contactTestBitMask = bitMask.object.rawValue
    }
    
    
    func addHole() {
        
        hole = childNode(withName: "hole") as? SKSpriteNode
        hole.physicsBody = SKPhysicsBody(circleOfRadius: 15)
        hole.physicsBody?.affectedByGravity = false
        hole.physicsBody?.categoryBitMask = bitMask.object.rawValue
        hole.physicsBody?.collisionBitMask = 0
        hole.physicsBody?.contactTestBitMask = bitMask.ball.rawValue
    }
    
    
    func addTint() {
        
        tint = childNode(withName: "tint") as? SKSpriteNode
        tint.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        tint.physicsBody?.affectedByGravity = false
        tint.physicsBody?.categoryBitMask = bitMask.object.rawValue
        tint.physicsBody?.collisionBitMask = 0
        tint.physicsBody?.contactTestBitMask = bitMask.ball.rawValue
    }
    
    func updateSpritePosition(_ acceleration: CMAcceleration) {
        // Calculate new position based on accelerometer data
        let newPositionX = ball.position.x + CGFloat(acceleration.x * 12) // Adjust the multiplier to control sensitivity
        let newPositionY = ball.position.y + CGFloat(acceleration.y * 12) // Adjust the multiplier to control sensitivity
        
        // Limit the sprite's position within the screen bounds
        let screenSize = self.size
        let spriteSize = ball.size
        let minX = spriteSize.width / 2
        let maxX = screenSize.width - spriteSize.width / 2
        let minY = spriteSize.height / 2
        let maxY = screenSize.height - spriteSize.height / 2
        
        ball.position.x = max(min(newPositionX, maxX), minX)
        ball.position.y = max(min(newPositionY, maxY), minY)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Other update logic
        
        if newBallColor {
            let color1 = ball.color
            let color2 = tint.color
            let weight1: CGFloat = 0.7
            let weight2: CGFloat = 0.3
            
            if let mixedColor = mixColors(color1: color1, color2: color2, weight1: weight1, weight2: weight2) {
                // Use the mixedColor
                print(mixedColor)
                ball.color = mixedColor
                newBallColor = false
            }
            
            if generateHole {
                hole.position = getRandomHolePosition()
                generateHole = false
            }
        }
        
        if generateNewTint {
            let randomPosition = getRandomPosition()
            let randomColor = randomizeColor()
            tint.position = randomPosition
            tint.color = randomColor
            generateNewTint = false
        }
        
        if gameover {
            print("gameover")
            run(SKAction.sequence([
                SKAction.run() { [weak self] in
                    guard let `self` = self else { return }
                    let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                    let gameOverScene = GameOverScene(fileNamed: "GameOverScene")
                    self.view?.presentScene(gameOverScene!, transition: reveal)
                }
            ]))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bitmaskA = contact.bodyA.categoryBitMask
        let bitmaskB = contact.bodyB.categoryBitMask
        
        if (bitmaskA == bitMask.ball.rawValue && bitmaskB == bitMask.object.rawValue) {
            if contact.bodyB.node?.name == "tint" {
                // randomize si tint
                print("dapet tint")
                generateNewTint = true
                generateHole = true
                newBallColor = true
            } else if contact.bodyB.node?.name == "hole" {
                // randomize si hole
                print("masuk hole")
                ball.isHidden = true
                gameover = true
                
            }
        }
        else if (bitmaskA == bitMask.object.rawValue && bitmaskB == bitMask.ball.rawValue) {
            if contact.bodyA.node?.name == "tint" {
                // randomize si tint
                print("dapet tint")
                generateNewTint = true
                generateHole = true
                newBallColor = true
            } else if contact.bodyA.node?.name == "hole" {
                // randomize si tint
                print("masuk hole")
                ball.isHidden = true
                gameover = true
            }
        }
    }
    
    func randomizeColor() -> UIColor {
        return UIColor(red: CGFloat.random(in: 0...1),
                                  green: CGFloat.random(in: 0...1),
                                  blue: CGFloat.random(in: 0...1),
                                  alpha: 1.0)
    }
    
    
    
    func getRandomPosition() -> CGPoint {
        let minX = frame.minX + tint.size.width/2
        let maxX = frame.maxX - tint.size.width/2
        let minY = frame.minY + tint.size.height/2
        let maxY = frame.maxY - tint.size.height/2
        
        let randomX = CGFloat.random(in: minX...maxX)
        let randomY = CGFloat.random(in: minY...maxY)
        
        //        return CGPoint(x: randomX, y: randomY)
        return CGPoint(x: randomX, y: randomY)
    }
    
    
    func getRandomHolePosition() -> CGPoint {
        let minX = frame.minX + hole.size.width/2
        let maxX = frame.maxX - hole.size.width/2
        let minY = frame.minY + hole.size.height/2
        let maxY = frame.maxY - hole.size.height/2
        
        let randomX = CGFloat.random(in: minX...maxX)
        let randomY = CGFloat.random(in: minY...maxY)
        
        return CGPoint(x: randomX, y: randomY)
    }
    
    
    //    Mix ball colors with tint
    func mixColors(color1: UIColor, color2: UIColor, weight1: CGFloat, weight2: CGFloat) -> UIColor? {
        var red1: CGFloat = 0.0, green1: CGFloat = 0.0, blue1: CGFloat = 0.0, alpha1: CGFloat = 0.0
        var red2: CGFloat = 0.0, green2: CGFloat = 0.0, blue2: CGFloat = 0.0, alpha2: CGFloat = 0.0
        
        if color1.getRed(&red1, green: &green1, blue: &blue1, alpha: &alpha1),
           color2.getRed(&red2, green: &green2, blue: &blue2, alpha: &alpha2)
        {
            let newRed = (red1 * weight1) + (red2 * weight2)
            let newGreen = (green1 * weight1) + (green2 * weight2)
            let newBlue = (blue1 * weight1) + (blue2 * weight2)
            
            return UIColor(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
        }
        
        return nil
    }
    
    
}
