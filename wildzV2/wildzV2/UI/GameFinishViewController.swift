//
//  GameFinishViewController.swift
//  wildzV2
//
//  Created by Mac on 17.11.2021.
//

import UIKit
class GameFinishViewController: UIViewController {
    
    var isWin: Bool?
    
    @IBOutlet weak var finishLabel: UIImageView!
    @IBOutlet weak var bg: UIImageView!
    @IBOutlet weak var nextActionButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextActionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        if isWin! {
            finishLabel.image = UIImage(named:"You win")
            bg.image = UIImage(named:"bgWithCoins")
            nextActionButton.setBackgroundImage(UIImage(named:"nextButton"), for: .normal)
        } else {
            finishLabel.image = UIImage(named:"You lose")
            bg.image = UIImage(named:"bg")
            nextActionButton.setBackgroundImage(UIImage(named:"restartButton"), for: .normal)
        }
    }
    @objc func buttonAction(sender: UIButton!) {
        if isWin! {
            self.navigationController?.popViewController(animated: false)
            (navigationController?.viewControllers.first as? GameViewController)?.newGame()
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
