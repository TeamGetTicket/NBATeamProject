//
//  PlayerViewController.swift
//  NBAEasyGet
//
//  Created by Chengjiu Hong on 10/15/18.
//  Copyright © 2018 PoHung Wang. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstnameLabel: UILabel!
    @IBOutlet weak var lastnameLabel: UILabel!
    @IBOutlet weak var seasonsYearLabel: UILabel!
    @IBOutlet weak var ppgLabel: UILabel!
    @IBOutlet weak var rpgLabel: UILabel!
    @IBOutlet weak var apgLabel: UILabel!
    @IBOutlet weak var spgLabel: UILabel!
    @IBOutlet weak var bpgLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var birthbateLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var collegeLabel: UILabel!
    @IBOutlet weak var draftDateLabel: UILabel!
    //@IBOutlet weak var aliasLabel: UILabel!
    @IBOutlet weak var debutYearLabel: UILabel!
    @IBOutlet weak var experienceYearLabel: UILabel!
    
    var player: [String: Any]?
    var playerID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let player = player{
            
            //self.navigationItem.title = player["name"] as? String
            playerID = player["id"] as! String
             //let url = URL(string: "http://api.sportradar.us/nba/trial/v5/en/players/\(playerID)/profile.json?api_key=d8nn89vtd3qe7jkwvzftfjqa")!
            //print(playerID)
            
            fectchPlayers()
        }
        
        
        
        //fectchAlias()
}

    func fectchPlayers(){

        //print(playerID)
    let urlString = "http://api.sportradar.us/nba/trial/v5/en/players/" + self.playerID as! String + "/profile.json?api_key=d8nn89vtd3qe7jkwvzftfjqa"
        //print(urlString)
        let url = URL(string: urlString)!

        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error{
                print(error.localizedDescription)
            }else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                //print(dataDictionary)
               // let id = dataDictionary["id"]
                //print(id)
                let lastname = dataDictionary["last_name"] as! String
                self.lastnameLabel.text = lastname
                let firstname = dataDictionary["first_name"] as! String
                self.firstnameLabel.text = firstname
                let height = dataDictionary["height"] as! integer_t
                self.heightLabel.text = String (height)
                let weight = dataDictionary["weight"] as! integer_t
                self.weightLabel.text = String (weight)
                let birthday = dataDictionary["birthdate"] as! String
                self.birthbateLabel.text = birthday
                
                //get age with birthday
                let year = birthday.split(separator: "-")
                let year2 = Int(year[0])
                let date = NSDate()
                let calendar = NSCalendar.current
                let currentYear = calendar.component(.year, from: date as Date)
                let age = currentYear - year2! ?? 0
                self.ageLabel.text = String (age)

                let college = dataDictionary["college"] as! String
                self.collegeLabel.text = college
                let experience = dataDictionary["experience"] as! String
                self.experienceYearLabel.text = experience
                
                let draft = dataDictionary["draft"] as! [String:Any]
                let pick = draft["pick"] as! String
                self.draftDateLabel.text = pick
                let debut = draft["year"] as! integer_t
                self.debutYearLabel.text = String (debut)
                
                let seasons = dataDictionary["seasons"] as! [[String:Any]]
                let season1 = seasons[0]
                let year1 = season1["year"] as! integer_t
                self.seasonsYearLabel.text = String (year1)
                let teams = season1["teams"] as! [[String:Any]]
                
                let dictionary = teams[0]
                let average = dictionary["average"] as! [String:Any]
                let point = average["points"] as! NSNumber
                self.ppgLabel.text = point.stringValue
                let rebound = average["rebounds"] as! NSNumber
                self.rpgLabel.text = rebound.stringValue
                let assist = average["assists"] as! NSNumber
                self.apgLabel.text = assist.stringValue
                let steal = average["steals"] as! NSNumber
                self.spgLabel.text = steal.stringValue
                let block = average["blocks"] as! NSNumber
                self.bpgLabel.text = block.stringValue
                
                let playerImageString = firstname + " " + lastname
                self.profileImageView.image = UIImage(named: playerImageString)
            }
        }
        task.resume()
    }

}
