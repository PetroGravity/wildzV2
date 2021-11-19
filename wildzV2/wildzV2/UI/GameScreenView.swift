//
//  GameScreenView.swift
//  wildzV2
//
//  Created by Mac on 19.11.2021.
//

import UIKit

class GameScreenView: UIView {
    
    @IBOutlet weak var lowerPlanet: UIImageView!
    
    @IBOutlet weak var upperPlanet: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setup() {
        let contentView = Bundle(for: GameScreenView.self).loadNibNamed("GameScreen", owner: self, options: nil)!.first as! UIView
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
