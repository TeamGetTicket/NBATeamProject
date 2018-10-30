//
//  ScheduleViewController.swift
//  NBAEasyGet
//
//  Created by Chengjiu Hong on 10/24/18.
//  Copyright © 2018 PoHung Wang. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var games:[NSDictionary] = []
    var gameInprogress:NSDictionary = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.rowHeight = 120
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateFormatter.dateFormat = "EEEE, MMM dd"
        let currentDateString: String = dateFormatter.string(from: date)
        dateLabel.text = currentDateString
        fetchSchedule()
//        gameInprogress = featchInprogressGame(gameID: "afa8ab8c-22ad-409c-b406-a252440ff992")
    }
    
    func fetchSchedule(){
        let date = Date()
        let caldendar = Calendar.current
        let year = caldendar.component(.year, from: date)
        let month = caldendar.component(.month, from: date)
        let day = caldendar.component(.day, from: date)
        let url = URL(string: "http://api.sportradar.us/nba/trial/v5/en/games/\(year)/\(month)/\(day)/schedule.json?api_key=d8nn89vtd3qe7jkwvzftfjqa")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.games = dataDictionary["games"] as! [NSDictionary]
            }
            self.tableView.reloadData()
        }
        task.resume()
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return games.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameCell
        let game = games[indexPath.row]
        
        let homeDict = game["home"] as! NSDictionary
        let homeTeam = homeDict["name"] as! String
        
        let awayDict = game["away"] as! NSDictionary
        let awayTeam = awayDict["name"] as! String
        
        let homeImageString = homeTeam.split(separator: " ")
        let awayImageString = awayTeam.split(separator: " ")
        let homeImage = UIImage(named: String(homeImageString[homeImageString.count-1]))
        let awayImage = UIImage(named: String(awayImageString[awayImageString.count-1]))
        
        let status = game["status"] as! String
        if(status == "closed" || status == "complete"){
//          ||  status == "complete"
            cell.timeLabel.text = "Final"
            cell.homeScore.text = "\(game["home_points"]!)"
            cell.awayScore.text = "\(game["away_points"]!)"
            
        }else if(status == "scheduled" || status == "inprogress"){
            
            let utc = game["scheduled"] as! String
            let separators = CharacterSet(charactersIn: "-T:+")
            let split = utc.components(separatedBy: separators)
            
            var hour = Int(split[3])!-7-12
            if(hour < 0){
                hour = -(hour)-12
            }
            
            let min = split[4]
            
            cell.timeLabel.text = "\(hour):\(min) PM PST"
            
            cell.homeScore.text = ""
            cell.awayScore.text = ""
        }
    
        cell.homeImage.image = homeImage
        cell.awayImage.image = awayImage
        cell.homeLabel.text = homeTeam
        cell.awayLabel.text = awayTeam
        
        return cell
    }

    func featchInprogressGame(gameID: String) -> NSDictionary{
        let url = URL(string: "http://api.sportradar.us/nba/trial/v5/en/games/\(gameID)/boxscore.json?api_key=d8nn89vtd3qe7jkwvzftfjqa")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                self.gameInprogress = dataDictionary
                
                // TODO: Get the array of movies
                // TODO: Store the movies in a property to use elsewhere
                // TODO: Reload your table view data
                
            }
        }
        task.resume()
        return self.gameInprogress
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
