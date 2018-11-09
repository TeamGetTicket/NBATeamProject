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
    @IBOutlet weak var homeTotalScore: UILabel!
    @IBOutlet weak var awayTotalScore: UILabel!
    
    
    @IBOutlet weak var homeQ1: UILabel!
    @IBOutlet weak var homeQ2: UILabel!
    @IBOutlet weak var homeQ3: UILabel!
    @IBOutlet weak var homeQ4: UILabel!
    @IBOutlet weak var awayQ1: UILabel!
    @IBOutlet weak var awayQ2: UILabel!
    @IBOutlet weak var awayQ3: UILabel!
    @IBOutlet weak var awayQ4: UILabel!
    @IBOutlet weak var homeTeamScoreImage: UIImageView!
    @IBOutlet weak var awayTeamScoreImage: UIImageView!
    
    @IBOutlet weak var homeLeaderImage: UIImageView!
    @IBOutlet weak var homeLeaderName: UILabel!
    @IBOutlet weak var homeLeaderScore: UILabel!
    
    @IBOutlet weak var awayLeaderScore: UILabel!
    @IBOutlet weak var awayLeaderImage: UIImageView!
    @IBOutlet weak var awayLeaderName: UILabel!
    
    
    
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
                    let homeLeadDict = home["leaders"] as! NSDictionary
                    let homeLeadPointDict = homeLeadDict["points"] as! [NSDictionary]
                    let pointDict = homeLeadPointDict[0]
                    let homeStat = pointDict["statistics"] as! NSDictionary
                    self.homeLeaderName.text = pointDict["full_name"] as? String
                    self.homeLeaderScore.text = String(homeStat["points"] as! Int)
                    let homeLeaderImageName = UIImage(named: pointDict["full_name"] as! String)
                    self.homeLeaderImage.image = homeLeaderImageName
                    
                    self.homeName.text = home["name"] as? String
                    self.homeScore.text = String(home["points"] as! Int)
                    self.homeTotalScore.text = String(home["points"] as! Int)
                    let homeImageName = UIImage(named: home["name"] as! String)
                    self.homeImage.image = homeImageName
                    self.homeTeamScoreImage.image = homeImageName
                    let homeScoreDict = home["scoring"] as! [NSDictionary]

                    for quarter in homeScoreDict{
                        if(quarter["number"]as! Int == 1){
                            if(quarter["points"] as! Int != 0){
                                self.homeQ1.text = String(quarter["points"] as! Int)
                            }else{
                                self.homeQ1.text = "0"
                            }
                        }else if(quarter["number"]as! Int == 2){
                            if(quarter["points"] as! Int != 0){
                                self.homeQ2.text = String(quarter["points"] as! Int)
                            }else{
                                self.homeQ2.text = "0"
                            }
                        }else if(quarter["number"]as! Int == 3){
                            if(quarter["points"] as! Int != 0){
                                self.homeQ3.text = String(quarter["points"] as! Int)
                            }else{
                                self.homeQ3.text = "0"
                            }
                        }else if(quarter["number"]as! Int == 4){
                            if(quarter["points"] as! Int != 0){
                                self.homeQ4.text = String(quarter["points"] as! Int)
                            }else{
                                self.homeQ4.text = "0"
                            }
                        }
                    }
                    
                    let away = data["away"] as! NSDictionary

                    let awayLeadDict = away["leaders"] as! NSDictionary
                    let awayLeadPointDict = awayLeadDict["points"] as! [NSDictionary]
                    let awayPointDict = awayLeadPointDict[0]
                    let awayStat = awayPointDict["statistics"] as! NSDictionary
                    self.awayLeaderName.text = awayPointDict["full_name"] as? String
                    self.awayLeaderScore.text = String(awayStat["points"] as! Int)
                    let awayLeaderImageName = UIImage(named: awayPointDict["full_name"] as! String)
                    self.awayLeaderImage.image = awayLeaderImageName
                    
                    self.awayName.text = away["name"] as? String
                    self.awayScore.text = String(away["points"] as! Int)
                    self.awayTotalScore.text = String(away["points"] as! Int)
                    let awayScoreDict = away["scoring"] as! [NSDictionary]
                    
                    for quarter in awayScoreDict{
                        if(quarter["number"]as! Int == 1){
                            if(quarter["points"] as! Int != 0){
                                self.awayQ1.text = String(quarter["points"] as! Int)
                            }else{
                                self.awayQ1.text = "0"
                            }
                        }else if(quarter["number"]as! Int == 2){
                            if(quarter["points"] as! Int != 0){
                                self.awayQ2.text = String(quarter["points"] as! Int)
                            }else{
                                self.awayQ2.text = "0"
                            }
                        }else if(quarter["number"]as! Int == 3){
                            if(quarter["points"] as! Int != 0){
                                self.awayQ3.text = String(quarter["points"] as! Int)
                            }else{
                                self.awayQ3.text = "0"
                            }
                        }else if(quarter["number"]as! Int == 4){
                            if(quarter["points"] as! Int != 0){
                                self.awayQ4.text = String(quarter["points"] as! Int)
                            }else{
                                self.awayQ4.text = "0"
                            }
                            
                        }
                    }

                    let awayImageName = UIImage(named: away["name"] as! String)
                    self.awayImage.image = awayImageName
                    self.awayTeamScoreImage.image = awayImageName
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
