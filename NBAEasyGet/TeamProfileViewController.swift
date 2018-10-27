//
//  TeamProfileViewController.swift
//  NBAEasyGet
//
//  Created by Chengjiu Hong on 10/15/18.
//  Copyright © 2018 PoHung Wang. All rights reserved.
//

import UIKit

class TeamProfileViewController: UIViewController, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    var players: [NSDictionary] = []
    var team: [String:Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        
        if let team = team{
            self.navigationItem.title = team["name"] as? String
            let teamID = team["id"] as! String
            let url = URL(string: "http://api.sportradar.us/nba/trial/v5/en/teams/\(teamID)/profile.json?api_key=3ye63ptxw6j7xtfrwaf3jstb")!
            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
            let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else if let data = data {
                    let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let players = dataDictionary["players"] as! [NSDictionary]
                    self.players = players
                    self.tableView.reloadData()
                }
            }
            task.resume()
        }
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return players.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerCell
        
        let player = players[indexPath.row]
        let name = player["full_name"] as! String
        let number = player["jersey_number"] ?? ""
        let position = player["primary_position"] as! String
        let IncheHeight = player["height"] as! Int
        let weight = String(player["weight"] as! Int)
        
        let feet = IncheHeight/12
        let remainder = feet%12
        
        let playerImageString = name;
        let image = UIImage(named: playerImageString)
        cell.playerImage.image = image
        
        cell.heightLabel.text = " | \(feet) ft \(remainder) in"
        cell.nameLabel.text = name
        cell.numberLabel.text = "#\(number)"
        cell.positionLabel.text = position
        cell.weightLabel.text = "| \(weight) lbs"
        
        return cell
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
