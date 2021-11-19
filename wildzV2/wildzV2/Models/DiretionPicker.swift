//
//  DiretionPicker.swift
//  wildzV2
//
//  Created by Mac on 18.11.2021.
//

import SpriteKit

enum Direction: CaseIterable {
    case up, down, left, right

    init(swipeDirection: UISwipeGestureRecognizer.Direction) {
        switch swipeDirection {
        case .left: self = .left
        case .right: self = .right
        case .up: self = .up
        case .down: self = .down
        default: fatalError()
        }
    }

    static var random: Direction { self.allCases.randomElement()! }
}

class DirectoinNode: SKSpriteNode {
    
    var isGrey = true {
        didSet {
            self.texture =  colorTexture
            if isGrey == false {
                self.isHidden = false
                let initScale = self.xScale
                self.run(.scale(to: initScale * 1.05, duration: 0.1)) {
                    self.setScale(initScale)
                }
            }
        }
    }

    let colorTexture: SKTexture

    init(direction: Direction) {

        switch direction {
        case .up:
            colorTexture = .init(imageNamed: "up arrow")
        case .down:
            colorTexture = .init(imageNamed: "down arrow")
        case .left:
            colorTexture = .init(imageNamed: "left arrow")
        case .right:
            colorTexture = .init(imageNamed: "right arrow")
        default:
            print("hm")
        }

        super.init(texture: colorTexture, color: .clear, size: colorTexture.size())

        if direction == .right || direction == .left {
            self.anchorPoint = .init(x: 0.5, y: 0.3)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func shake() {
        let duration: Float = 0.4
        let amplitudeX: Float = 18;
        let amplitudeY: Float = 18;
        let numberOfShakes = duration / 0.04;
        var actionsArray:[SKAction] = [];
        for _ in 1...Int(numberOfShakes) {
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2;
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2;
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02);
            shakeAction.timingMode = SKActionTimingMode.easeOut;
            actionsArray.append(shakeAction);
            actionsArray.append(shakeAction.reversed());
        }
        
        let actionSeq = SKAction.sequence(actionsArray);
        self.run(actionSeq);
    }
}

class DiretionPicker: SKNode {
    let nodes: [Direction: DirectoinNode] = [
        .right : .init(direction: .right),
        .up : .init(direction: .up),
        .left : .init(direction: .left),
        .down : .init(direction: .down),
    ]

    var direction: Direction? {
        didSet {
            nodes.forEach {
                let isColor = $0.key == self.direction
                $0.value.isGrey = !isColor
            }
        }
    }

    init(height: CGFloat) {
        super.init()

        let halfMiddleSpacing: CGFloat = 16
        let arrowWidth = height / 2 - halfMiddleSpacing
        //let offset = halfMiddleSpacing + arrowWidth / 2

        nodes.forEach { (direction: Direction, node: DirectoinNode) in

            switch direction {
            case .down:
                node.position = .init(x: 0, y: 0)
                node.setScale(toHeight: arrowWidth)
            case .up:
                node.position = .init(x: 0, y: 0)
                node.setScale(toHeight: arrowWidth)
            case .left:
                node.position = .init(x: 0, y: 0)
                node.setScale(toWidth: arrowWidth)
            case .right:
                node.position = .init(x: 0, y: 0)
                node.setScale(toWidth: arrowWidth)
            default:
                print("hm")
            }
            node.isHidden = true
            self.addChild(node)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SKSpriteNode {
    func setScale(toWidth: CGFloat) {
        let ration = toWidth / self.frame.width
        self.setScale(ration)
    }
    
    func setScale(toHeight: CGFloat) {
        let ration = toHeight / self.frame.height
        self.setScale(ration)
    }
}
