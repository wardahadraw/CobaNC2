//
//  StartScene.swift
//  CobaNC2
//
//  Created by Wardah on 25/05/23.
//

import SpriteKit

class StartScene: SKScene {
    
    var background = SKSpriteNode(imageNamed: "StartScene")
    var startgame = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        // Set up the background image
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = -1
        addChild(background)
        
        startgame = childNode(withName: "StartGame") as! SKSpriteNode
        startgame.position = CGPoint(x: size.width/2, y: size.height/3)
        startgame.zPosition = 16
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            print("klik")

            
            if startgame.contains(location) {
                let reveal = SKTransition.flipHorizontal(withDuration: 0.5)
                let initialscene = GameScene(fileNamed: "GameScene")!
                initialscene.scaleMode = .aspectFill
                self.view?.presentScene(initialscene, transition:reveal)
            }
        }
    }
}
