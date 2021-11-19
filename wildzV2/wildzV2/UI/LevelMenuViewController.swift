//
//  LevelMenuViewController.swift
//  wildzV2
//
//  Created by Mac on 17.11.2021.
//

import GameKit

class LevelsCell: UITableViewCell {
    @IBOutlet weak var buttonImage: UIImageView!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var centerXConstaint: NSLayoutConstraint!
    @IBOutlet weak var lockLabel: UIImageView!
    
    func configer(level: Int, isLocked: Bool) {
        self.selectionStyle = .none
        
        levelLabel.text = "\(level + 1)"
        levelLabel.isHidden = isLocked
        lockLabel.isHidden = !isLocked
        lockImage.isHidden = !isLocked
        centerXConstaint.constant = (level % 2 == 0) ? 44 : -44
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        contentView.alpha = selected ? 0.5 : 1
    }
}

class LevelMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let numberOfLevels = 32
    var bestLevel: Int { return Level.shared.level }
    
    var planets: [UIImage] = [
        .init(imageLiteralResourceName: "planet1"),
        .init(imageLiteralResourceName: "planet2"),
        .init(imageLiteralResourceName: "planet3"),
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func leaderboardTapped(_ sender: Any) {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        //gcVC.leaderboardIdentifier = Consts.leaderboardID
        present(gcVC, animated: true, completion: nil)
    }
    
    @IBAction func infoButtonTap(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "info") as! InfoViewController
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = { (viewController, error) -> Void in
            if let viewController = viewController {
                self.present(viewController, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if let error = error {
                        print(error)
                    } else if let leaderboardIdentifer = leaderboardIdentifer {
                        print(leaderboardIdentifer)
                    } else {
                        print("got to nils :(")
                    }
                })
                
            } else {
                print("Local player could not be authenticated!")
                print(error as Any)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateLocalPlayer()
        
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        tableView.delegate = self
        tableView.contentInset = .init(top: 88, left: 0, bottom: 64, right: 0)
        tableView.separatorStyle = .none
        
        UserDefaults.standard.register(defaults: ["best" : 1])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let selectedRows = tableView.indexPathsForSelectedRows else { return }
        for indexPath in selectedRows { tableView.deselectRow(at: indexPath, animated: animated) }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! LevelsCell
        cell.configer(level: indexPath.row, isLocked: indexPath.row >= bestLevel)
        let planetIndex = indexPath.row % planets.count
        cell.buttonImage.image = planets[planetIndex]
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfLevels
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard bestLevel > indexPath.row else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        let vc = (storyboard?.instantiateViewController(withIdentifier: "game"))! as! UINavigationController
        (vc.viewControllers.first! as! GameViewController).level = indexPath.row + 1
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension LevelMenuViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
}

