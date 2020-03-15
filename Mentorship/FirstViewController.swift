//
//  FirstViewController.swift
//  Mentorship
//
//  Created by Yugantar Jain on 14/03/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import UIKit

struct HomeData: Decodable {
    let pending_requests: Int?
    let accepted_requests: Int?
    let rejected_requests: Int?
    let completed_relations: Int?
}

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var arguments = ["Pending Requests", "Accepted Requests", "Rejected Requests", "Completed Relations"]
    var valueForArgument = [String].init(repeating: "0", count: 4)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arguments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = arguments[indexPath.row]
        cell.detailTextLabel?.text = valueForArgument[indexPath.row]
        
        return cell
    }
    
    @IBOutlet weak var statsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        statsTable.dataSource = self
        statsTable.delegate = self
        
        loadData()
    }
    
    func loadData() {
        let taskURLString = devURL + "home"
        let taskURL = URL(string: taskURLString)
        var request = URLRequest.init(url: taskURL!)
        request.setValue(token, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print ("server error")
                return
            }
            //api call successful
            do {
                let json = try JSONDecoder().decode(HomeData.self, from: data!)
                print("json decode successful")
                
                self.valueForArgument[0] = String(json.pending_requests ?? 0)
                self.valueForArgument[1] = String(json.accepted_requests ?? 0)
                self.valueForArgument[2] = String(json.rejected_requests ?? 0)
                self.valueForArgument[3] = String(json.completed_relations ?? 0)
                
                DispatchQueue.main.async {
                    self.statsTable.reloadData()
                }
            }
            catch {
                print("json decode fails")
                return
            }
        }.resume()
    }
    
}

