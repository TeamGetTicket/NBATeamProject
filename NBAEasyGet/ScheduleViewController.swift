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
    var refreshControl:UIRefreshControl!
    var date = Date()
    var caldendar = Calendar.current
    var year:Int = 0
    var month:Int = 0
    var day:Int = 0
    var dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.rowHeight = 120
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControl.Event.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
         year = caldendar.component(.year, from: date)
         month = caldendar.component(.month, from: date)
         day = caldendar.component(.day, from: date)
        
         dateLabel.text = "\(month)/\(day)/\(year)"
        
        fetchSchedule(day: day,month: month,year: year)
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl){
        fetchSchedule(day: day,month: month,year: year)
    }
    
    func fetchSchedule(day: Int, month: Int, year: Int){
        let url = URL(string: "http://api.sportradar.us/nba/trial/v5/en/games/\(year)/\(month)/\(day)/schedule.json?api_key=ksujx6az77nsanjrpe2evucc")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.games = dataDictionary["games"] as! [NSDictionary]
            }
            self.refreshControl.endRefreshing()
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
            cell.timeLabel.text = "Final"
            cell.homeScore.text = "\(game["home_points"]!)"
            cell.awayScore.text = "\(game["away_points"]!)"
            
        }else if(status == "scheduled"){
            
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
        } else if (status == "inprogress"){
            cell.timeLabel.text = "In Progress"
            cell.homeScore.text = ""
            cell.awayScore.text = ""
        }
    
        cell.homeImage.image = homeImage
        cell.awayImage.image = awayImage
        cell.homeLabel.text = homeTeam
        cell.awayLabel.text = awayTeam
        
        return cell
    }
    
    @IBAction func dayBefore(_ sender: Any) {
        day -= 1
        dateLabel.text = "\(month)/\(day)/\(year)"
        fetchSchedule(day: day,month: month,year: year)
    }
    
    @IBAction func dayAfter(_ sender: Any) {
        day = day + 1
        dateLabel.text = "\(month)/\(day)/\(year)"
        fetchSchedule(day: day,month: month,year: year)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        if let indexPath = tableView.indexPath(for: cell){
            let game = games[indexPath.row]
            let gameDetailView = segue.destination as! GameDetailViewController
            gameDetailView.game = game as? [String : Any]
        }
        
    }

}
