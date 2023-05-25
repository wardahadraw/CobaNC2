//
//  GameViewController.swift
//  CobaNC2
//
//  Created by Wardah on 21/05/23.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let initialscene = StartScene(fileNamed: "StartScene")!
        initialscene.scaleMode = .aspectFill
        
        let skView = view as! SKView
        skView.ignoresSiblingOrder = true
        skView.presentScene(initialscene)
//        skView.showsPhysics = true
        
    }


    override var prefersStatusBarHidden: Bool {
        return true
    }

}
