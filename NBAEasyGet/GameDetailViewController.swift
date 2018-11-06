//
//  GameDetailViewController.swift
//  NBAEasyGet
//
//  Created by Chengjiu Hong on 10/29/18.
//  Copyright © 2018 PoHung Wang. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController {
    
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var awayImage: UIImageView!
    @IBOutlet weak var homeName: UILabel!
    @IBOutlet weak var awayName: UILabel!
    @IBOutlet weak var quarter: UILabel!
    @IBOutlet weak var clock: UILabel!
    @IBOutlet weak var homeScore: UILabel!
    @IBOutlet weak var awayScore: UILabel!
    
    
    var game: [String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let game = game{
            let gameID = game["id"] as! String
            let url = URL(string: "http://api.sportradar.us/nba/trial/v5/en/games/\(gameID)/boxscore.json?api_key=ksujx6az77nsanjrpe2evucc")!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data {
                    let data = try! JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
                    let status = data["status"] as! String
                    
                    if(status == "closed") {
                        self.clock.text = "Final"
                        let quarter = data["quarter"] as! Int
                        if(quarter > 4){
                            self.quarter.text = "OT"
                        }
                    }else{
                        let clock = data["clock"] as! String
                        let quarter = data["quarter"] as! Int
                        self.quarter.text = "Q \(quarter)"
                        self.clock.text = clock
                    }
                    
                    let home = data["home"] as! NSDictionary
                    self.homeName.text = home["name"] as? String
                    self.homeScore.text = String(home["points"] as! Int)
                    let homeImageName = UIImage(named: home["name"] as! String)
                    self.homeImage.image = homeImageName
                    
                    
                    let away = data["away"] as! NSDictionary
                    self.awayName.text = away["name"] as? String
                    self.awayScore.text = String(away["points"] as! Int)

                    let awayImageName = UIImage(named: away["name"] as! String)
                    self.awayImage.image = awayImageName

                    
                }
            }
            task.resume()
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}