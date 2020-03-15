//
//  MembersTableViewController.swift
//  Mentorship
//
//  Created by Yugantar Jain on 14/03/20.
//  Copyright © 2020 Yugantar Jain. All rights reserved.
//

import UIKit

struct MemberData: Decodable {
    let username: String?
    let need_mentoring: Bool?
    let available_to_mentor: Bool?
}

class MembersTableViewController: UITableViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var usernames = [String]()
    var status = [String]()
    
    let colors = [UIColor.systemPink, UIColor.blue, UIColor.systemTeal]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        loadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usernames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Configure the cell...
        cell.textLabel?.text = usernames[indexPath.row]
        cell.detailTextLabel?.text = status[indexPath.row]
        cell.imageView?.tintColor = colors[indexPath.row % 3]
        return cell
    }
    
    func loadData() {
        let taskURLString = devURL + "users"
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
                let json = try JSONDecoder().decode([MemberData].self, from: data!)
                print("json decode successful")
                for member in json {
                    self.usernames.append(member.username ?? "name")
                    
                    var statusString = "Available as: "
                    if(member.available_to_mentor!) {
                        statusString += "Mentor "
                    }
                    if(member.need_mentoring!) {
                        statusString += "Mentee"
                    }
                    statusString += "\nInterests: --"
                    self.status.append(statusString)
                }
                DispatchQueue.main.async {
                    self.spinner.isHidden = true
                    self.tableView.reloadData()
                }
            }
            catch {
                print("json decode fails")
                return
            }
        }.resume()
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        spinner.startAnimating()
        usernames.removeAll()
        status.removeAll()
        loadData()
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
