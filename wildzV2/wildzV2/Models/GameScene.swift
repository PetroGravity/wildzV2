//
//  GameScene.swift
//  wildzV2
//
//  Created by Mac on 16.11.2021.
//

import SpriteKit
import GameplayKit

protocol GameProtocol: AnyObject {
    func gameOver(didWin: Bool)
}

class GameScene: SKScene {
    
    let nuberOfSwipesToWin = 12
    
    var diretionPicker: DiretionPicker!
    var rocet = Rocet()
    
    var gameTime = 10.0
    var didStart = false
    var nuberOfSwipesDone = 0
    
    weak var gameProtocol: GameProtocol?
    var timer: Timer?
    var tochToStartView: UIView!
    let startBtn = SKSpriteNode(imageNamed: "Tap to start")
    let backgroundNode = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        let minHeight = min(frame.width, frame.height / 2)
        let height = minHeight - 32

        diretionPicker = DiretionPicker(height: height - 80)
        diretionPicker.position = .init(x: self.frame.midX, y: self.frame.midY)
        self.addChild(diretionPicker)
        
        setupSwipes()
        setNewDirection()
        
        
        rocet.createRocet()
        rocet.gameTime = gameTime
        self.addChild(rocet)
        rocet.rocetStart()
        
        
        backgroundNode.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        backgroundNode.color = .black
        backgroundNode.alpha = 0.5
        backgroundNode.position = .init(x: self.frame.midX, y: self.frame.midY)
        backgroundNode.name = "start"
        self.addChild(backgroundNode)
        startBtn.position = .init(x: self.frame.midX, y: self.frame.midY)
        startBtn.setScale(toHeight: size.width / 8)
        self.addChild(startBtn)
        self.view!.isPaused = true
    }
    
    func setupSwipes() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        rightSwipe.direction = .right
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        upSwipe.direction = .up
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        leftSwipe.direction = .down
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipe(sender:)))
        downSwipe.direction = .left
        
        [rightSwipe, upSwipe, leftSwipe, downSwipe].forEach { view?.addGestureRecognizer($0) }
        
        view?.addGestureRecognizer(rightSwipe)
    }
    
    @objc func didSwipe(sender: UISwipeGestureRecognizer) {
        if diretionPicker.direction == .init(swipeDirection: sender.direction) {
            diretionPicker.nodes.forEach { (key: Direction, value: DirectoinNode) in
                value.isHidden = true
            }
            setNewDirection()
            nuberOfSwipesDone += 1
            if nuberOfSwipesDone % (nuberOfSwipesToWin / 4) == 0 {
                rocet.rocetNotFinish(enoughSwipes: true)
            }
            if nuberOfSwipesDone == nuberOfSwipesToWin {
                timer?.invalidate()
                timer = nil
                gameProtocol?.gameOver(didWin: true)
            }
        } else {
            diretionPicker.nodes.forEach { (key: Direction, value: DirectoinNode) in
                value.shake()
            }
        }
    }
    
    func setNewDirection() {
        self.removeAction(forKey: "setNewDirection")
        diretionPicker.direction = .random
        let sqw = SKAction.sequence([
            .wait(forDuration: 1000),
            .run { self.setNewDirection() }
        ])
        self.run(sqw, withKey: "setNewDirection")
    }
    
    @objc func onTimerFires()
    {
        gameTime -= 1
        if gameTime <= 0 {
            timer?.invalidate()
            gameProtocol?.gameOver(didWin: false)
            timer = nil
        }

    }
    
    func touchDown(atPoint pos : CGPoint) {
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
     
    }
    
    func touchUp(atPoint pos : CGPoint) {
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard didStart else {
            guard let position = touches.first?.location(in: self) else { return }
            let touchedNode = self.atPoint(position)
            if touchedNode.name == "start" {
                didStart = true
                startBtn.removeFromParent()
                backgroundNode.removeFromParent()
                self.view!.isPaused = false
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(onTimerFires), userInfo: nil, repeats: true)
            }
            return
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
