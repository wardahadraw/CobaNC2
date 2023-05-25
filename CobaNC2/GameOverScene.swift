//
//  GameOverScene.swift
//  CobaNC2
//
//  Created by Wardah on 24/05/23.
//

import SpriteKit

class GameOverScene: SKScene {
    
    //    var background = SKSpriteNode(fileNamed: "Background")
    //
    //  init(size: CGSize, won:Bool) {
    //    super.init(size: size)
    //
    //    // 1
    //    backgroundColor = SKColor.white
    //
    //    // 2
    //    let message = won ? "You Won!" : "Game Over"
    //
    //    // 3
    //    let label = SKLabelNode(fontNamed: "SF-Pro-Rounded-Bold")
    //    label.text = message
    //    label.fontSize = 40
    //    label.fontColor = SKColor.black
    //    label.position = CGPoint(x: size.width/2, y: size.height/2)
    //    addChild(label)
    
    var background = SKSpriteNode(imageNamed: "Background")
    var playAgain = SKSpriteNode()
    var label = SKLabelNode()

    override func didMove(to view: SKView) {
        // Set up the background image
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = 1
        addChild(background)
        
//        let label = childNode(withName: "label") as! SKLabelNode
//        label.text = "Game Over"
//        label.fontSize = 48
//        label.fontColor = SKColor.white
//        label.position = CGPoint(x: size.width/2, y: size.height/1.7)
        
        playAgain = childNode(withName: "PlayAgain") as! SKSpriteNode
        playAgain.position = CGPoint(x: size.width/2, y: size.height/3)
        playAgain.zPosition = 16
    }
    
//    init(size: CGSize, won: Bool) {
//        super.init(size: size)
//
//
//
//
//
//        // Customize your game over logic
//
//
////        addChild(playAgain)
//
//        playAgain.isUserInteractionEnabled = true
//    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            print("klik")

            
            if playAgain.contains(location) {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let initialscene = GameScene(fileNamed: "GameScene")!
                initialscene.scaleMode = .aspectFill
                self.view?.presentScene(initialscene, transition:reveal)
            }
        }
    }
}
