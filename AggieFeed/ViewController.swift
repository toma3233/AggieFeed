//
//  ViewController.swift
//  AggieFeed
//
//  Created by Tom Abraham on 1/31/21.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    // Reference to managed object context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // Data stored using CoreData
    private var items = [News]()
    private var count = 0
    private var connected = true
    
    // Create array of activities
    private var activityArray = [Post]()
    
    let database = DatabaseHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        // Calls function to scan each activity and append to array
        fetchPostData(refresh: false)
      
    }
    
    @objc private func refreshData() {
        if connected == false {
            fetchPostData(refresh: false)
        } else {
            fetchPostData(refresh: true)
        }
        
        
    }
    
    // Use completion handler to avoid loading issues
    func fetchPostData(refresh : Bool = false) {
        
        if refresh {
            tableView.refreshControl?.beginRefreshing()
            
        }
        
        if connected == false {
            tableView.refreshControl?.beginRefreshing()
            self.tableView.refreshControl?.endRefreshing()
            
        }
        
        let url = URL(string: "https://aggiefeed.ucdavis.edu/api/v1/activity/public?s=\(count)&l=25")!
        // Begins to connect to API through a URL session
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                // returns if data is not found
                guard let data = data else { return }
                
                do {
                    
                    if refresh {
                        print("Deleted everything haha")
                        self.tableView.refreshControl?.endRefreshing()
                        print("Refreshed!")
                        self.items.removeAll()
                        self.database.deleteAll()
                        self.activityArray.removeAll()
                    }
                    
                    // Decodes each byte of data according to codable structs created in Post.swift
                    let postsData = try JSONDecoder().decode([Post].self, from: data)
      
                    // Deletes everything in the CoreData DB when reading from API
                    if self.database.deleteAll() {
                        let obj = self.database.fetch(type: News.self)
                        print("AMT OF ITEMS AFTER DELETION")
                        print(obj.count)
                        //self.database.save()
                    } else {
                        let obj = self.database.fetch(type: News.self)
                        print(obj.map { $0.news_title })
                    }
                    
                    // remove all items to prepare for new ones (for pagination)
                    if refresh == false && self.connected == true {
                        self.items.removeAll()
                    }
                    
                    // appends each activity to activtyArray
                    self.activityArray.append(contentsOf: postsData)
                    for index in 0...(self.activityArray.count - 1) {
                        
                        // Print out contents of db for debugging purposes
                        let pbj = self.database.fetch(type: News.self)
                        print("Before COUNT")
                        print(pbj.count)
                        
                        let newNewsItem = News(context: self.context)
                        newNewsItem.news_displayName = self.activityArray[index].actor.displayName
                        newNewsItem.news_title = self.activityArray[index].title
                        newNewsItem.news_objectType = self.activityArray[index].object.objectType.map { $0.rawValue }
                        newNewsItem.news_published = self.activityArray[index].published
                         
                        // Print out contents of db for debugging purposes
                        for i in pbj {
                            print(i.news_title!)
                        }
                        print("After COUNT")
                        print(pbj.count)
                        print(" ")
                        print(" ")
                        
                        self.items.append(newNewsItem)
                        self.database.save()
                    }
                    
                    // Print out everything in database once API has been read
                    let pbj = self.database.fetch(type: News.self)
                    print("NEW COUNT")
                    print(pbj.count)
                    for i in pbj {
                        print(i.news_title!)
                    }
                    
                    do {
                        try self.context.save()
                    }
                    catch {
                        
                    }
                    
                }
                catch {
                    
                    // Account for no internet connect and failed API connection
                    print("API Connection Failed")
                    self.connected = false
                    let pbj = self.database.fetch(type: News.self)
                    print("NUM ITEMS IN DB")
                    print(pbj.count)
                    for i in pbj {
                        print(i.news_title!)
                    }
                    
                    // populate items array with News objects from CoreData DB
                    let req = NSFetchRequest<News>(entityName: "News")
                    do {
                        self.items = try self.context.fetch(req)
                    } catch {
                        print ("DIDNT WORK")
                    }
                }
               
                // reload table view after getting activity
                self.tableView.reloadData()
            }
           
            
            
        }.resume()
    }
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // segue to DetailVC once a cell is selected
        performSegue(withIdentifier: "showdetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Pass in information about the selected activity to DetailVC
        if let destination = segue.destination as? DetailVC {
            destination.detailedNews = items[(tableView.indexPathForSelectedRow?.row)!]
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    // returns the number of activites stored in array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let news_item = self.items[indexPath.row]
        cell.textLabel?.text = news_item.news_title
        cell.detailTextLabel?.text = news_item.news_displayName
        
        if (indexPath.row == self.items.count - 1) {
            count += 25
            fetchPostData(refresh: false)
        }
        return cell
    }
}

