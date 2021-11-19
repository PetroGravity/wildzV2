//
//  GameViewController.swift
//  wildzV2
//
//  Created by Mac on 16.11.2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var level: Int?
    @IBOutlet weak var skView: SKView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = false
            view.showsNodeCount = false
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        newGame()
    }
    
    @IBAction func testButtonTap(_ sender: Any) {
        
    }
    
    func newGame() {
        let scene = GameScene()
        scene.backgroundColor = .clear
        //scene.gameProtocol = self
        scene.scaleMode = .resizeFill
        scene.gameProtocol = self
        skView.allowsTransparency = true
        skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
extension GameViewController: GameProtocol {
    func gameOver(didWin: Bool) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "finish") as! GameFinishViewController
        vc.isWin = didWin
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
