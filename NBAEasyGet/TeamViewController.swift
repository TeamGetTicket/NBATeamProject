//
//  TeamViewController.swift
//  NBAEasyGet
//
//  Created by Chengjiu Hong on 10/15/18.
//  Copyright © 2018 PoHung Wang. All rights reserved.
//

import UIKit

class TeamViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var teams:[[String:Any]] = []
    


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        fectchTeams()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return teams.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath) as! TeamCell
        
        let team = teams[indexPath.row]
        //print(team)
        let name = team["name"] as! String
        let market = team["market"] as! String
        let teamName = market + " " + name
        
        let wins = team["wins"] as! Int
        let losses = team["losses"] as! Int
        
        cell.teamNameLabel.text = teamName
        cell.winsLabel.text = String(wins)
        cell.lossesLabel.text = String(losses)
        //print(teamName)
//        let teamAlias = team["alias"] as! String
//        let venue = team["venue"] as! [String:Any]
//        //print(venue)
//        let venueName = venue["name"] as! String
//        //print(venueName)
//        let address:String = venue["address"] as! String
//        let city:String = venue["city"] as! String
//        let state:String = venue["state"] as! String
//        let zip:String = venue["zip"] as! String
//
//        let venueAddress:String = address + ", " + city + ", " + state + ", " + zip
//
        //print(venueAddress)
        //print(city)
//        cell.teamNameLabel.text = teamName
//        cell.teamAliasLabel.text = teamAlias
//        cell.teamVenueLabel.text = venueName
//        cell.teamAddressLabel.text = venueAddress
//

        let teamImage = UIImage(named: name)

        cell.teamImage.image = teamImage
        
        
        return cell
    }
    
    func fectchTeams(){
        
        let url = URL(string: "http://api.sportradar.us/nba/trial/v5/en/seasons/2018/REG/standings.json?api_key=ksujx6az77nsanjrpe2evucc")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error{
                print(error.localizedDescription)
            }else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let conferences = dataDictionary["conferences"] as! [[String:Any]]
                let eastern = conferences[0]["divisions"] as! [[String:Any]]
                let western = conferences[1]["divisions"] as! [[String:Any]]
                let easternTeams1 = eastern[0]["teams"] as! [[String:Any]]
                let easternTeams2 = eastern[1]["teams"] as! [[String:Any]]
                let easternTeams3 = eastern[2]["teams"] as! [[String:Any]]
                let westernTeams1 = western[0]["teams"] as! [[String:Any]]
                let westernTeams2 = western[1]["teams"] as! [[String:Any]]
                let westernTeams3 = western[2]["teams"] as! [[String:Any]]
                
                for team in easternTeams1{
                    self.teams.append(team)
                }
                for team in easternTeams2{
                    self.teams.append(team)
                }
                for team in easternTeams3{
                    self.teams.append(team)
                }
                for team in westernTeams1{
                    self.teams.append(team)
                }
                for team in westernTeams2{
                    self.teams.append(team)
                }
                for team in westernTeams3{
                    self.teams.append(team)
                }
                
                //print(self.teams)
                self.tableView.reloadData()
                
            }
        }
        task.resume()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
            let team = teams[indexPath.row]
            let teamProfileViewController = segue.destination as! TeamProfileViewController
            teamProfileViewController.team = team
            
        }

    }

}
