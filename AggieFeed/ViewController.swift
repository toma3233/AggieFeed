//
//  ViewController.swift
//  AggieFeed
//
//  Created by Tom Abraham on 1/31/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var activityArray = [Post]()
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Calls function to scan each activity and append to array
        fetchPostData { (posts) in }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    
    func fetchPostData(completionHandler: @escaping ([Post]) -> Void) {
        let url = URL(string: "https://aggiefeed.ucdavis.edu/api/v1/activity/public?s=0?l=25")!
        // Begins to connect to API through a URL session
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // returns if data is not found
            guard let data = data else { return }
            
            do {
                // Decodes each byte of data according to codable structs created in Post.swift
                let postsData = try JSONDecoder().decode([Post].self, from: data)
                // appends each activity to activtyArray
                self.activityArray.append(contentsOf: postsData)
                completionHandler(postsData)
            }
            catch {
                // exception handling
                let error = error
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                // reload table view after getting activity
                self.tableView.reloadData()
            }
            
        }.resume()
    }
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("you tapped me!")
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Prints out title and actor.displayName for each table view cell
        let activity = activityArray[indexPath.row]
        cell.textLabel?.text = activity.title
        cell.detailTextLabel?.text = activity.actor.displayName
        return cell
    }
}

