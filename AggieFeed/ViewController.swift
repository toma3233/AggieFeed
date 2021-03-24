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
    
    // Create array of activities
    private var activityArray = [Post]()
    
    let database = DatabaseHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // Calls function to scan each activity and append to array
        fetchPostData { (posts) in }
        
        // Get items from CoreData
        //fetchNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let results = database.fetch(type: News.self)
//        print(results.map { $0.news_title })
    }
    
    
    
    func fetchNews() {
        // Fetch the data from CoreData
        do {
            self.items = try context.fetch(News.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            
        }
    }
    
    
    // Use completion handler to avoid loading issues
    func fetchPostData(completionHandler: @escaping ([Post]) -> Void) {
        let url = URL(string: "https://aggiefeed.ucdavis.edu/api/v1/activity/public?s=0&l=25")!
        // Begins to connect to API through a URL session
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            // returns if data is not found
            guard let data = data else { return }
            
            do {
                // Decodes each byte of data according to codable structs created in Post.swift
                let postsData = try JSONDecoder().decode([Post].self, from: data)
                
                
                
               
                
                if self.database.deleteAll() {
                    let obj = self.database.fetch(type: News.self)
                    print("AMT OF ITEMS AFTER DELETION")
                    print(obj.count)
                    //self.database.save()
                } else {
                    let obj = self.database.fetch(type: News.self)
                    print(obj.map { $0.news_title })
                }
                
            
                
                
                
                // How do I create a newNewsItem object for every Post object?
                
                // appends each activity to activtyArray
                self.activityArray.append(contentsOf: postsData)
                for index in 0...(self.activityArray.count - 1) {
                    let pbj = self.database.fetch(type: News.self)
                    print("Before COUNT")
                    print(pbj.count)
                    let newNewsItem = News(context: self.context)
                    newNewsItem.news_displayName = self.activityArray[index].actor.displayName
                    newNewsItem.news_title = self.activityArray[index].title
                    newNewsItem.news_objectType = self.activityArray[index].object.objectType.map { $0.rawValue }
                    newNewsItem.news_published = self.activityArray[index].published
                    
                    //self.database.add(type: News.self)
                    
//                    guard let news = self.database.add(type: News.self) else { return }
//                    news.news_displayName = self.activityArray[index].actor.displayName
//                    news.news_title = self.activityArray[index].title
//                    news.news_objectType = self.activityArray[index].object.objectType.map { $0.rawValue }
//                    news.news_published = self.activityArray[index].published
                    
                    //print(news.news_title)
                    for i in pbj {
                     print(i.news_title)
                    }
                    print("After COUNT")
                    print(pbj.count)
                    print(" ")
                    print(" ")
                    
                    
                    
                    
                    //print(newNewsItem.news_title!)
                    self.items.append(newNewsItem)
                    self.database.save()
                    //print(self.items.count)
                }
                let pbj = self.database.fetch(type: News.self)
                print("NEW COUNT")
                print(pbj.count)
                for i in pbj {
                    print(i.news_title)
                }
//
                
                
                
                
                
                
                
                //newNewsItem.news_objectType = self.activityArray[self.index].object.objectType
                
                
                do {
                    try self.context.save()
                }
                catch {
                    
                }
                
                //self.fetchNews()
                
                
                completionHandler(postsData)
            }
            catch {
                // exception handling
                
                print("API Connection Failed")
                let pbj = self.database.fetch(type: News.self)
                print("NEW COUNT")
                print(pbj.count)
                for i in pbj {
                    print(i.news_title)
                }
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
        
        // Prints out title and actor.displayName for each table view cell
//        let activity = activityArray[indexPath.row]
        let news_item = self.items[indexPath.row]
//        cell.textLabel?.text = activity.title
//        cell.detailTextLabel?.text = activity.actor.displayName
        cell.textLabel?.text = news_item.news_title
        cell.detailTextLabel?.text = news_item.news_displayName
        return cell
    }
}

