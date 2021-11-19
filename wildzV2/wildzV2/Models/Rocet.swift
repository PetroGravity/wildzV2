//
//  Rocet.swift
//  wildzV2
//
//  Created by Mac on 16.11.2021.
//

import SpriteKit

class Rocet: SKSpriteNode {
    
    enum Distance: CaseIterable {
        case quarterDistance
        case threeQuartersDistance
        case halfDistance
        case fullDistance
    }
    
    let rocet = SKSpriteNode(imageNamed: "rocketLarge")
    let xRocetPosition = UIScreen.main.bounds.midX
    let yRocetPosition = UIScreen.main.bounds.minY
    
    var currentDistance: Distance = .quarterDistance
    var gameTime: Double?
    lazy var distances: [CGFloat] = [(CGFloat(UIScreen.main.bounds.maxY - rocet.frame.height) / 4), (CGFloat(UIScreen.main.bounds.maxY - rocet.frame.height) / 3), (CGFloat(UIScreen.main.bounds.maxY - rocet.frame.height) / 2), (CGFloat(UIScreen.main.bounds.maxY - rocet.frame.height) / 1)]
    
    func createRocet() {
        
        rocet.size = CGSize(width: 70, height: 100)
        rocet.setScale(1.0)
        rocet.position = CGPoint(x: xRocetPosition, y: yRocetPosition + 75)
        rocet.zPosition = 1

        self.addChild(rocet)
    }
    
    func rocetStart() {
        rocetMovingForward(distance: getFinishDistance(distance: currentDistance)!)
    }
    
    func rocetMovingForward(distance: CGFloat) {
        let quarterTime = gameTime! / 4
        let moveTargets = SKAction.moveTo(y: rocet.frame.origin.y + distance, duration: quarterTime)
        rocet.run(moveTargets)
    }
    
    func getFinishDistance(distance: Distance) -> CGFloat? {
        switch distance {
        case .quarterDistance:
            return distances[0]
        case .threeQuartersDistance:
            return distances[1]
        case .halfDistance:
            return distances[2]
        case .fullDistance:
            return distances[3]
        }
    }
    
    func rocetNotFinish(enoughSwipes: Bool) {
        if enoughSwipes {
            currentDistance = currentDistance.next()
            rocetMovingForward(distance: getFinishDistance(distance: currentDistance)!)
        } else {
            // BOOM?
        }
    }
    
}
extension CaseIterable where Self: Equatable, AllCases: BidirectionalCollection {
    func next() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }
    
    func previous() -> Self {
        let all = Self.allCases
        let idx = all.firstIndex(of: self)!
        let previous = all.index(before: idx)
        return all[previous < all.startIndex ? all.index(before: all.endIndex) : previous]
    }
}
