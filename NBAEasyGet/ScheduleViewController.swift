//
//  ScheduleViewController.swift
//  NBAEasyGet
//
//  Created by Chengjiu Hong on 10/24/18.
//  Copyright © 2018 PoHung Wang. All rights reserved.
//

import UIKit

class ScheduleViewController: UIViewController {
    
    var games:[NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func fetchSchedule(){
        let date = Date()
        let caldendar = Calendar.current
        let year = caldendar.component(.year, from: date)
        let month = caldendar.component(.month, from: date)
        let day = caldendar.component(.day, from: date)
        
        let url = URL(string: "http://api.sportradar.us/nba/trial/v5/en/games/\(year)/\(month)/\(day)/schedule.json?api_key=3ye63ptxw6j7xtfrwaf3jstb")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.games = dataDictionary["games"] as! [NSDictionary]
            }
        }
        task.resume()
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
